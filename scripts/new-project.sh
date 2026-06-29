#!/usr/bin/env bash
# desc: 스캐폴더 — --agent-only <name>(외부코드=brain+pointer) | --buildable <name>(자기완결 서브트리). stamp+INDEX재생성+notify
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"; cd "$ROOT"
TODAY="$(date +%F)"

usage() { echo "사용법: new-project.sh --agent-only <name> | --buildable <name>   (name=kebab-slug)"; exit 1; }
MODE="${1:-}"; NAME="${2:-}"
[[ -z "$MODE" || -z "$NAME" ]] && usage
[[ "$NAME" =~ ^[a-z0-9][a-z0-9-]*$ ]] || { echo "❌ name 은 kebab-slug([a-z0-9-]): '$NAME'"; exit 1; }

stamp() { # frontmatter(첫 ---..---)만 치환 — 본문 코드펜스 예시 오염 방지(awk scoped)
  local f="$1" nm="${2:-$NAME}" desc="${NAME} 코어 에이전트(비즈로직) — TODO(owner) 채우기"
  awk -v nm="$nm" -v today="$TODAY" -v desc="$desc" '
    BEGIN{fm=0}
    {sub(/\r$/,"")}
    NR==1 && $0=="---"{fm=1; print; next}
    fm==1 && $0=="---"{fm=2; print; next}
    fm==1 && /^name:/{print "name: " nm; next}
    fm==1 && /^created:/{print "created: " today; next}
    fm==1 && /^updated:/{print "updated: " today; next}
    fm==1 && /^description:/{print "description: " desc; next}
    {print}
  ' "$f" > "$f.tmp" && mv "$f.tmp" "$f"
}

case "$MODE" in
  --agent-only)
    TGT="agents/${NAME}.agent.md"
    [[ -e "$TGT" ]] && { echo "❌ 이미 존재: $TGT"; exit 1; }
    [[ -f templates/core-agent.md ]] || { echo "❌ templates/core-agent.md 없음"; exit 1; }
    cp templates/core-agent.md "$TGT"; stamp "$TGT"
    # 도메인 지식 포인터(dual-home 금지·이름 충돌 회피 — 코어=agents/<name>, 지식=wiki/domain/<name>-notes)
    DOM="wiki/domain/${NAME}-notes.md"
    if [[ ! -e "$DOM" ]]; then
      printf '%s\n' "---" "name: ${NAME}-notes" "description: ${NAME} 공유 도메인 지식·함정(brain의 JIT 검색면) — TODO(owner)" \
        "type: reference" "track: dev" "status: DRAFT" "owner: you" "created: $TODAY" "updated: $TODAY" \
        "source: none" "links: [[${NAME}]]" "---" "" "# ${NAME} 도메인 지식" "" "> TODO: 외부코드 패턴/함정 캡처. 코어 에이전트는 [[${NAME}]](\`agents/${NAME}.agent.md\`)." > "$DOM"
    fi
    echo "✅ 외부코드 프로젝트 stamp: $TGT (type:agent·DRAFT) + $DOM"
    ;;
  --buildable)
    TGT="projects/${NAME}"
    [[ -e "$TGT" ]] && { echo "❌ 이미 존재: $TGT"; exit 1; }
    [[ -d projects/_template ]] || { echo "❌ projects/_template 없음"; exit 1; }
    cp -R projects/_template "$TGT"
    find "$TGT" -name '*.bak' -delete 2>/dev/null || true
    # 자기완결 서브트리 — llms.txt/INDEX stamp
    [[ -f "$TGT/llms.txt" ]] && sed -i.bak "s/__PROJECT__/$NAME/g" "$TGT/llms.txt" && rm -f "$TGT/llms.txt.bak"
    echo "✅ from-scratch 프로젝트 시드: $TGT (llms.txt+INDEX). 채울 때 reference/howto/explanation/decisions/<slug>.md 추가(Diátaxis)."
    ;;
  *) usage ;;
esac

echo "── INDEX/llms.txt 재생성 ──"
bash scripts/gen-index.sh >/dev/null && echo "✅ 인덱스 갱신"
echo ""
echo "다음: ① 코어 카드 채우기 → ② wiki 링크 → ③ PDCA 1라운드(prompts/pdca-round.md) → ④ check-all.sh → ⑤ 텔레그램 notify(.ops/notify.md)"
