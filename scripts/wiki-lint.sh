#!/usr/bin/env bash
# desc: 단일 chokepoint 린터 — frontmatter/헤드라인≤150/깨진[[link]]/freshness/size/dup/preload존재/죽은경로/고아/헌장 (bash3.2 호환)
set -uo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"; cd "$ROOT"
# 글자수는 로케일 비의존(tr+wc -c, charlen 함수) — LC_CTYPE 강제 제거(UTF-8 은 macOS 전용 로케일명이a Linux/MSYS서 C 폴백→오작동)
EXCLUDE='\./\.git|/node_modules|/archive|/scratch|\./\.claude|/_template|\./\.cache|\./docs'
REQ_KEYS="name description type track status owner created updated source links"
DEADPATHS=''   # 프로젝트별 알려진 죽은 경로(공백구분). 비우면 검사 안 함 — 회귀 발견 시 추가.
# 순수 템플릿 게이트: 개인/프로젝트/페르소나/스킬 식별자 잔존 금지(대소문자 무관)
PERSONAL='runvault|lumen|gocjh1|lazymac|최종호|dany|폴리봇|polymarket|apify|brian|plausible.{0,2}run|맥스튜디오|aether|nexus|lazydev|spirit-matrix|kairos|dev-squad|canonical_user_id|beta_free_mode|polybot|coindany|hero8962|kis-bot|kis-dexter|한국투자|v0\.41'
FAIL=0; WARN=0; GITLESS=0
err()  { echo "❌ P0/P1 $1"; FAIL=$((FAIL+1)); }
warn() { echo "⚠️  $1"; WARN=$((WARN+1)); }

fm_get() { awk -v k="^$2:[[:space:]]*" '{sub(/\r$/,"")} NR==1&&$0!="---"{exit} /^---[[:space:]]*$/{c++; if(c==2)exit; next} c==1&&$0~k{sub(/^[^:]*:[[:space:]]*/,"");print;exit}' "$1" 2>/dev/null || true; }
has_fm() { head -1 "$1" 2>/dev/null | tr -d '\r' | grep -q '^---[[:space:]]*$'; }
# 크로스플랫폼 mtime(YYYY-MM-DD): BSD stat → GNU stat → GNU date -r
mtime_date() {
  local d
  d=$(stat -f '%Sm' -t '%Y-%m-%d' "$1" 2>/dev/null) && [ -n "$d" ] && { echo "$d"; return; }
  d=$(stat -c '%y' "$1" 2>/dev/null | cut -d' ' -f1) && [ -n "$d" ] && { echo "$d"; return; }
  d=$(date -r "$1" +%Y-%m-%d 2>/dev/null) && [ -n "$d" ] && { echo "$d"; return; }
  echo "0000-00-00"
}
strip_code() { awk '{sub(/\r$/,"")} /^```/{fence=!fence;next} !fence' "$1" | sed 's/`[^`]*`//g'; }   # 펜스+인라인 코드 제거(+CRLF 내성)
# UTF-8 codepoint 길이(로케일 비의존 — 연속바이트 0x80-0xBF 제거 후 바이트수). macOS/Linux/Git Bash 동일.
charlen() { printf '%s' "$1" | LC_ALL=C tr -d '\200-\277' | LC_ALL=C wc -c | tr -d ' '; }

NOTES=()
while IFS= read -r f; do NOTES+=("$f"); done < <(find . -name '*.md' ! -name 'INDEX.md' | grep -Ev "$EXCLUDE" | grep -Ev '^\./(AGENTS|CLAUDE|README|CONTRIBUTING)\.md$' | sort)

TMPD="$ROOT/.cache"; mkdir -p "$TMPD"
DEFFILE="$TMPD/deffile.$$"; DESCFILE="$TMPD/descfile.$$"; IDXREFS="$TMPD/idxrefs.$$"; NAMEFILE="$TMPD/namefile.$$"
: > "$DEFFILE"; : > "$DESCFILE"; : > "$IDXREFS"; : > "$NAMEFILE"
trap 'rm -f "$DEFFILE" "$DESCFILE" "$IDXREFS" "$NAMEFILE"' EXIT

# [[name]] 정의 집합 = 노트 name + 파일 basename + 헌장 docs
for f in ${NOTES[@]+"${NOTES[@]}"}; do
  n="$(fm_get "$f" name)"; [[ -n "$n" ]] && echo "$n" >> "$DEFFILE"
  b="$(basename "$f" .md)"; echo "$b" >> "$DEFFILE"; echo "${b%.agent}" >> "$DEFFILE"
done
for cf in AGENTS CLAUDE README; do echo "$cf" >> "$DEFFILE"; done
sort -u "$DEFFILE" -o "$DEFFILE" 2>/dev/null || true

for f in ${NOTES[@]+"${NOTES[@]}"}; do
  if ! has_fm "$f"; then err "frontmatter 없음: $f"; continue; fi
  for k in $REQ_KEYS; do v="$(fm_get "$f" "$k")"; [[ -z "$v" ]] && err "frontmatter '$k' 누락/빈값: $f"; done
  name="$(fm_get "$f" name)"; desc="$(fm_get "$f" description)"; base="$(basename "$f" .md)"; base="${base%.agent}"
  [[ -n "$name" && "$name" != "$base" ]] && err "name($name) != 파일명slug($base): $f"
  printf '%s\t%s\n' "${name:-$base}" "$f" >> "$NAMEFILE"
  if [[ -n "$desc" ]]; then
    clen=$(charlen "$desc")
    (( clen > 150 )) && err "description ${clen}자(>150): $f"
    printf '%s\t%s\n' "$(printf '%s' "$desc" | tr -d '[:space:]')" "$f" >> "$DESCFILE"
  fi
  links="$(fm_get "$f" links)"; [[ -z "$links" || "$links" == "none" ]] && warn "links 비어있음(고아 위험): $f"
  # 깨진 [[link]] (코드 제외)
  while IFS= read -r tgt; do
    [[ -z "$tgt" ]] && continue
    grep -qxF "$tgt" "$DEFFILE" || err "깨진 [[link]] '[[$tgt]]' → 대상노트 없음: $f"
  done < <(strip_code "$f" | grep -oE '\[\[[^]]+\]\]' 2>/dev/null | sed -E 's/\[\[([^]]+)\]\]/\1/' | sort -u)
  # 죽은 경로 blocklist (회귀)
  for dead in $DEADPATHS; do grep -qF "$dead" "$f" && err "죽은 경로 '$dead' 잔존(회귀): $f"; done
  # 개인정보 blocklist (순수 템플릿)
  phit="$(grep -ioE "$PERSONAL" "$f" 2>/dev/null | sort -u | tr '\n' ',')"
  [[ -n "$phit" ]] && err "개인정보/프로젝트/스킬명 잔존(템플릿 위반): $f → ${phit%,}"
  # preload/참조 repo-상대 경로 존재성 (agents 카드 vacuous green husk 차단)
  case "$f" in
    *.agent.md)
      while IFS= read -r p; do
        [[ -z "$p" ]] && continue
        case "$p" in /*|"~"*|*"<"*|*"__"*) continue;; esac
        [[ -f "$ROOT/$p" ]] || err "preload/참조 경로 부재(죽은 포인터): $f → $p"
      done < <(grep -oE '"[a-zA-Z0-9_./-]+\.(md|txt|json)"' "$f" | tr -d '"' | sort -u) ;;
  esac
  # source freshness (파일·디렉터리 모두 -e, dir 은 자체 mtime 프록시)
  src="$(fm_get "$f" source)"; upd="$(fm_get "$f" updated)"
  if [[ -n "$src" && "$src" != "none" ]]; then
    resolved=""
    for cand in "$ROOT/$src" "$src" "${src/#\~/$HOME}"; do [[ -z "$resolved" && -e "$cand" ]] && resolved="$cand"; done
    if [[ -n "$resolved" ]]; then
      sdate=""
      case "$resolved" in
        "$ROOT"/*)   # in-repo: git은 mtime 미보존(clone=클론시각) → 커밋일로 비교. 미커밋/non-git=skip(거짓 STALE 방지)
          rel="${resolved#$ROOT/}"
          if git -C "$ROOT" rev-parse --git-dir >/dev/null 2>&1; then
            sdate="$(git -C "$ROOT" log -1 --format=%cs -- "$rel" 2>/dev/null || true)"
          else GITLESS=1; fi ;;
        *) sdate="$(mtime_date "$resolved")" ;;   # 외부트리: mtime
      esac
      [[ -n "$sdate" && -n "$upd" && "$sdate" > "$upd" ]] && err "source 가 updated($upd) 이후 변경됨(stale, $sdate): $f → $src"
    else
      warn "source 경로 미해소(외부트리?) — loud skip, 수동 freshness 확인: $f → $src"
    fi
  fi
  bytes=$(wc -c <"$f" | tr -d ' '); lines=$(wc -l <"$f" | tr -d ' ')
  (( bytes > 25600 )) && err "노트 ${bytes}B(>25KB) — compaction-on-write 분할: $f"
  (( lines > 200 ))   && err "노트 ${lines}줄(>200) — 분할: $f"
  (( bytes > 20480 && bytes <= 25600 )) && warn "노트 ${bytes}B(25KB 근접): $f"
done

# dup-description (단일 SOT 헤드라인 복붙 의심)
if [[ -s "$DESCFILE" ]]; then
  while IFS= read -r dupkey; do
    [[ -z "$dupkey" ]] && continue
    files=$(awk -F'\t' -v k="$dupkey" '$1==k{print $2}' "$DESCFILE" | tr '\n' ' ')
    warn "description 중복(dup-SOT 의심): $files"
  done < <(cut -f1 "$DESCFILE" | sort | uniq -d)
fi

# dup-NAME: 두 노트가 같은 slug → [[link]] 모호 (FAIL)
if [[ -s "$NAMEFILE" ]]; then
  while IFS= read -r dn; do
    [[ -z "$dn" ]] && continue
    files=$(awk -F'\t' -v k="$dn" '$1==k{print $2}' "$NAMEFILE" | tr '\n' ' ')
    err "dup-NAME '$dn' — [[link]] 모호(두 노트가 같은 slug): $files"
  done < <(cut -f1 "$NAMEFILE" | sort | uniq -d)
fi

# sot-registry 완전성: wiki/domain·wiki/factory 의 PROVEN 정본은 .ops/sot-registry.md 에 [[name]] 등재 의무
REG=".ops/sot-registry.md"
if [[ -f "$REG" ]]; then
  for f in ${NOTES[@]+"${NOTES[@]}"}; do
    case "$f" in ./wiki/domain/*|./wiki/factory/*) ;; *) continue;; esac
    [[ "$(fm_get "$f" status)" == "PROVEN" ]] || continue
    nm="$(fm_get "$f" name)"; [[ -z "$nm" ]] && continue
    grep -qF "[[$nm]]" "$REG" || err "PROVEN 정본 미등록(sot-registry 누락): $f → 표에 [[$nm]] 추가"
  done
fi

# 고아 노트: 모든 노트 name 이 어떤 INDEX.md 에서 [[name]] 으로 도달 가능한가 (check-orphans 실체화)
while IFS= read -r idx; do strip_code "$idx" | grep -oE '\[\[[^]]+\]\]' 2>/dev/null | sed -E 's/\[\[([^]]+)\]\]/\1/'; done \
  < <(find . -name 'INDEX.md' | grep -Ev "$EXCLUDE") | sort -u > "$IDXREFS"
for f in ${NOTES[@]+"${NOTES[@]}"}; do
  nm="$(fm_get "$f" name)"; [[ -z "$nm" ]] && nm="$(basename "$f" .md)"; nm="${nm%.agent}"
  grep -qxF "$nm" "$IDXREFS" || err "고아 노트(어떤 INDEX 에서도 미링크): $f (name=$nm)"
done

# 헌장 docs: frontmatter 면제하되 깨진[[link]]+size 는 게이트(self-dogfood 완결)
for cf in ./AGENTS.md ./CLAUDE.md ./README.md; do
  [[ -f "$cf" ]] || continue
  phit="$(grep -ioE "$PERSONAL" "$cf" 2>/dev/null | sort -u | tr '\n' ',')"
  [[ -n "$phit" ]] && err "개인정보/프로젝트/스킬명 잔존(헌장 — 템플릿 위반): $cf → ${phit%,}"
  bytes=$(wc -c <"$cf"|tr -d ' '); lines=$(wc -l <"$cf"|tr -d ' ')
  (( bytes > 25600 )) && err "헌장 ${bytes}B(>25KB): $cf"
  [[ "$cf" == ./CLAUDE.md ]] && (( lines > 200 )) && err "CLAUDE.md ${lines}줄(>200·token-budget): $cf"
  while IFS= read -r tgt; do
    [[ -z "$tgt" ]] && continue
    grep -qxF "$tgt" "$DEFFILE" || err "헌장 깨진 [[link]] '[[$tgt]]': $cf"
  done < <(strip_code "$cf" | grep -oE '\[\[[^]]+\]\]' | sed -E 's/\[\[([^]]+)\]\]/\1/' | sort -u)
done

# INDEX/llms.txt size
while IFS= read -r f; do
  bytes=$(wc -c <"$f" | tr -d ' '); lines=$(wc -l <"$f" | tr -d ' ')
  (( bytes > 25600 )) && err "INDEX ${bytes}B(>25KB) — 폴더 분할: $f"
  (( lines > 200 ))   && err "INDEX ${lines}줄(>200): $f"
done < <(find . \( -name 'INDEX.md' -o -name 'llms.txt' \) | grep -Ev "$EXCLUDE")

# .txt(llms.txt 등) 개인정보 blocklist — .md 외 갑 봉합(생성물 포함: 진원=생성기면 거기서 잡힘)
while IFS= read -r f; do
  phit="$(grep -ioE "$PERSONAL" "$f" 2>/dev/null | sort -u | tr '\n' ',')"
  [[ -n "$phit" ]] && err "개인정보/프로젝트/스킬명 잔존(.txt — 템플릿 위반): $f → ${phit%,}"
done < <(find . -name '*.txt' | grep -Ev "$EXCLUDE")

# 설정/스크립트 개인정보 blocklist — .md/.txt 외 사각지대 봉합(.sh·CODEOWNERS·.gitignore·.gitattributes·.claude). wiki-lint.sh 자신은 PERSONAL 정의부라 제외
while IFS= read -r f; do
  case "$f" in */wiki-lint.sh) continue;; esac
  phit="$(grep -ioE "$PERSONAL" "$f" 2>/dev/null | sort -u | tr '\n' ',')"
  [[ -n "$phit" ]] && err "개인정보/프로젝트/스킬명 잔존(설정/스크립트 — 템플릿 위반): $f → ${phit%,}"
done < <(find . \( -name '*.sh' -o -name 'CODEOWNERS' -o -name '.gitignore' -o -name '.gitattributes' -o -name '*.json' -o -name '*.yml' -o -name '*.yaml' -o -name '*.toml' -o -name 'Makefile' -o -path './.claude/*' \) -type f | grep -Ev '/\.git/|/\.cache/')

(( GITLESS )) && warn "freshness 가드 일부 비활성: git 미초기화 → in-repo source 변경탐지 OFF(무음 아님·이 경고로 표면화). 'git init && bash scripts/install-hooks.sh' 로 활성(+ pre-commit 강제)."
echo "────────────────────────────────"
echo "wiki-lint: 노트 ${#NOTES[@]}개 · FAIL(P0/P1) $FAIL · WARN(P2) $WARN"
(( FAIL > 0 )) && { echo "❌ wiki-lint FAIL"; exit 1; }
echo "✅ wiki-lint PASS"
