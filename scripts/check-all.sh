#!/usr/bin/env bash
# desc: CI 진입점 — gen-index --verify + wiki-lint. 이게 fail이면 라운드/배포/커밋 미종료
set -uo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"; cd "$ROOT"
RC=0
echo "═══ check-all : agent-wiki dogfood 게이트 ═══"

echo "── [1/2] gen-index --verify (INDEX/llms.txt drift) ──"
bash scripts/gen-index.sh --verify || RC=1

echo "── [2/2] wiki-lint (frontmatter·헤드라인·링크·freshness·size) ──"
bash scripts/wiki-lint.sh || RC=1

echo "════════════════════════════"
if (( RC == 0 )); then
  echo "✅ check-all PASS — 커밋/PROVEN 승격 가능"
else
  echo "❌ check-all FAIL — 위 항목 수정 후 재실행. (가짜0 금지: 통과 전 커밋·배포 금지)"
fi
exit $RC
