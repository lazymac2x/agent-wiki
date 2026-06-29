#!/usr/bin/env bash
# desc: 커밋 전 게이트 — check-all.sh(문서품질) 강제 + staged-scope 경고. install-hooks.sh가 .git/hooks/pre-commit에서 호출
set -uo pipefail
ROOT="$(git rev-parse --show-toplevel 2>/dev/null)"
[ -z "$ROOT" ] && ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT"

# (1) staged-scope 경고 — 경로한정 add 위반(git add -A로 핫스팟 다수 동시 스테이징) 탐지
HOT='AGENTS.md CLAUDE.md INDEX.md llms.txt .ops/sot-registry.md'
staged="$(git diff --cached --name-only 2>/dev/null || true)"
hotcount=0
for h in $HOT; do echo "$staged" | grep -qxF "$h" && hotcount=$((hotcount+1)); done
if (( hotcount >= 2 )); then
  echo "⚠️  [pre-commit] 핫스팟 파일 ${hotcount}개 동시 스테이징 — CODEOWNERS single-writer 권고(.ops/git-conventions.md). 의도면 진행."
fi

# (2) 문서품질 게이트(강제) — check-all 통과 못 하면 커밋 차단
echo "[pre-commit] agent-wiki 문서품질 게이트(check-all) 실행…"
if bash scripts/check-all.sh; then
  exit 0
else
  echo ""
  echo "🚫 커밋 차단: check-all 미통과. 수정 후 재커밋."
  echo "   (긴급 우회 git commit --no-verify 는 가짜0 금지 — 권장하지 않음)"
  exit 1
fi
