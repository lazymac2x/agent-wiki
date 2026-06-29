#!/usr/bin/env bash
# desc: frontmatter → 모든 폴더 INDEX.md + 루트 llms.txt 자동생성(drift 구조적 차단). --verify=stale시 CI fail
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
# 정렬·비교를 바이트 결정론으로 고정 — sort collation 이 로케일 의존이면 INDEX 순서가 OS마다 달라져
# --verify 가 타 OS(Windows/Linux)서 거짓 STALE. LC_ALL=C 로 macOS/Linux/Git Bash 동일 출력 보장.
export LC_ALL=C
if [[ -n "${1:-}" && "${1:-}" != "--verify" ]]; then echo "❌ 알 수 없는 인자: '$1' (사용: gen-index.sh [--verify])"; exit 2; fi
VERIFY=0; [[ "${1:-}" == "--verify" ]] && VERIFY=1
EXCLUDE_DIRS='\./\.git|\./node_modules|/archive|/scratch|\./\.claude|/_template|\./\.cache|\./docs'
GEN_MARK="<!-- [GENERATED] scripts/gen-index.sh — 이 라인 아래 수기편집 금지. 사람용 글은 PROSE 블록에. -->"

# fm_get <file> <key>  : YAML frontmatter(첫 --- ~ 둘째 ---)에서 key 값 추출
fm_get() {
  awk -v k="^$2:[[:space:]]*" '
    {sub(/\r$/,"")}                                  # CRLF 내성(Windows)
    NR==1 && $0!="---" {exit}
    /^---[[:space:]]*$/ {c++; if(c==2) exit; next}
    c==1 && $0 ~ k {sub(/^[^:]*:[[:space:]]*/,""); print; exit}' "$1" 2>/dev/null || true
}
# sh_desc <file> : 스크립트의 `# desc:` 헤더
sh_desc() { grep -m1 '^# desc:' "$1" 2>/dev/null | tr -d '\r' | sed 's/^# desc:[[:space:]]*//' || true; }

# 한 폴더의 INDEX.md 본문 생성 → stdout
build_index() {
  local dir="$1" rel name desc title prose=""
  rel="${dir#./}"; [[ "$rel" == "." ]] && rel="(루트)"
  # 기존 PROSE 블록 보존
  if [[ -f "$dir/INDEX.md" ]]; then
    prose="$(awk '/<!-- PROSE:START -->/{f=1;next} /<!-- PROSE:END -->/{f=0} f' "$dir/INDEX.md" 2>/dev/null || true)"
  fi
  echo "# INDEX — $rel"
  echo ""
  echo "$GEN_MARK"
  echo "<!-- PROSE:START -->"
  if [[ -n "$prose" ]]; then echo "$prose"; else echo "_이 폴더의 지도. 항목은 frontmatter에서 자동 등재된다._"; fi
  echo "<!-- PROSE:END -->"
  echo ""
  # 노트(.md, INDEX 제외)
  local notes=() entry
  while IFS= read -r f; do notes+=("$f"); done < <(find "$dir" -maxdepth 1 -name '*.md' ! -name 'INDEX.md' | sort)
  if (( ${#notes[@]} )); then
    echo "## Notes"
    for f in "${notes[@]}"; do
      name="$(fm_get "$f" name)"; [[ -z "$name" ]] && name="$(basename "$f" .md)"
      desc="$(fm_get "$f" description)"; st="$(fm_get "$f" status)"
      if [[ -z "$desc" ]]; then
        case "$name" in
          AGENTS) desc="단일 정본 헌장(7대 법칙·frontmatter 계약·게이트)";;
          CLAUDE) desc="Claude Code 전용 오버레이(@AGENTS.md import)";;
          README) desc="사람용 6폴더 멘탈모델·빠른 시작";;
          *) desc="(no description)";;
        esac
      fi
      badge=""; case "$st" in DRAFT) badge="[DRAFT] ";; DEPRECATED) badge="[DEPRECATED] ";; esac
      echo "- [[$name]] — ${badge}${desc}"
    done
    echo ""
  fi
  # 스크립트(.sh)
  local shs=()
  while IFS= read -r f; do shs+=("$f"); done < <(find "$dir" -maxdepth 1 -name '*.sh' | sort)
  if (( ${#shs[@]} )); then
    echo "## Scripts"
    for f in "${shs[@]}"; do
      desc="$(sh_desc "$f")"; [[ -z "$desc" ]] && desc="(no desc)"
      echo "- \`$(basename "$f")\` — $desc"
    done
    echo ""
  fi
  # 하위폴더(INDEX 보유 예정)
  local subs=()
  while IFS= read -r d; do subs+=("$d"); done < <(find "$dir" -maxdepth 1 -mindepth 1 -type d | grep -Ev "$EXCLUDE_DIRS" | sort || true)
  local printed_sub=0
  for d in ${subs[@]+"${subs[@]}"}; do
    # 내용(.md/.sh/하위 .md) 있는 폴더만
    if find "$d" -name '*.md' -o -name '*.sh' 2>/dev/null | grep -q . ; then
      [[ $printed_sub == 0 ]] && { echo "## Subfolders"; printed_sub=1; }
      echo "- [$(basename "$d")/]($(basename "$d")/INDEX.md)"
    fi
  done
  (( printed_sub )) && echo ""
}

# 내용 있는 모든 폴더 수집 (직속 OR 자손에 노트가 있으면 INDEX 생성 — 허브 폴더 항해 보존)
DIRS=()
while IFS= read -r d; do DIRS+=("$d"); done < <( { echo "."; find . -mindepth 1 -type d | grep -Ev "$EXCLUDE_DIRS"; } | while IFS= read -r d; do
  if find "$d" \( -name '*.md' -o -name '*.sh' \) 2>/dev/null | grep -Ev "$EXCLUDE_DIRS" | grep -q .; then echo "$d"; fi
done | sort -u )

STALE=0
gen_one() { # path content  (temp/프로세스치환 미사용 — 문자열 직접비교)
  local target="$1" content="$2" cur
  if [[ $VERIFY == 1 ]]; then
    cur="$(tr -d '\r' < "$target" 2>/dev/null || true)"   # CRLF 정규화 + $()가 후행개행 제거 → 크로스플랫폼 정합
    if [[ "$cur" != "$content" ]]; then
      echo "STALE: $target (gen-index.sh로 재생성 필요)"; STALE=1
    fi
  else
    printf '%s\n' "$content" > "$target"
  fi
}

for d in "${DIRS[@]}"; do
  gen_one "$d/INDEX.md" "$(build_index "$d")"
done

# 루트 llms.txt
build_llms() {
  echo "# agent-wiki"
  echo ""
  echo "> 지식 자산화 OS 템플릿 — 하네스 노하우·도메인 지식·개인 운영지식을 검증된 토큰효율 자산으로 굳히고 코어 에이전트가 그 위에서 일하는 lean·확장형 저장소."
  echo ""
  echo "규칙 본체는 AGENTS.md 한 파일(헌장). 모든 폴더는 같은 모양 INDEX.md(자동생성)를 가진다. 본문은 JIT로 끌어다 쓴다: 식별자만 적재하고 ripgrep으로 frontmatter 검색."
  echo ""
  echo "## Charter"
  echo "- [AGENTS.md](AGENTS.md): 단일 정본 헌장(7대 법칙·frontmatter 계약·게이트)"
  echo "- [README.md](README.md): 사람용 6폴더 멘탈모델"
  echo ""
  echo "## Agents"
  for f in agents/*.agent.md agents/_panel/*.md; do [[ -e "$f" ]] || continue; [[ "$(basename "$f")" == INDEX.md ]] && continue; echo "- [$f]($f): $(fm_get "$f" description)"; done
  echo ""
  echo "## Harness"
  for f in harness/workflows/*.md harness/patterns/*.md; do [[ -e "$f" ]] || continue; [[ "$(basename "$f")" == INDEX.md ]] && continue; echo "- [$f]($f): $(fm_get "$f" description)"; done
  echo ""
  echo "## Wiki"
  echo "- [wiki/INDEX.md](wiki/INDEX.md): domain(개발)·factory(제조)·personal(개인) 3트랙"
  echo ""
  echo "## Projects"
  for d in projects/*/; do [[ "$d" == *_template/ ]] && continue
    if [[ -f "${d}llms.txt" ]]; then echo "- [${d}llms.txt](${d}llms.txt) (preload 대상)"
    elif [[ -f "${d}INDEX.md" ]]; then echo "- [${d}INDEX.md](${d}INDEX.md)"; fi
  done
  echo ""
  echo "## Optional"
  echo "- [.ops/INDEX.md](.ops/INDEX.md): 토큰예산·SOT 레지스트리·git·모델티어링(컨텍스트 빡빡하면 드롭)"
  echo "- [templates/INDEX.md](templates/INDEX.md) · [prompts/INDEX.md](prompts/INDEX.md) · [scripts/INDEX.md](scripts/INDEX.md)"
}
gen_one "llms.txt" "$(build_llms)"

if [[ $VERIFY == 1 ]]; then
  if (( STALE )); then echo "❌ gen-index --verify FAIL: 커밋된 INDEX/llms.txt가 stale. 'bash scripts/gen-index.sh' 후 재커밋."; exit 1; fi
  echo "✅ gen-index --verify OK"
else
  echo "✅ INDEX.md(${#DIRS[@]}개 폴더) + llms.txt 재생성 완료"
fi
