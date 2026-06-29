#!/usr/bin/env bash
# desc: git pre-commit hook 배선 — 규칙을 컨텍스트(권고)에서 강제(집행)로. 최초 1회
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"; cd "$ROOT"
[[ -d .git || -f .git ]] || { echo "❌ git repo 아님. 먼저: git init"; exit 1; }   # -f .git = linked worktree(gitdir 포인터)
mkdir -p .git/hooks
cat > .git/hooks/pre-commit <<'HOOK'
#!/usr/bin/env bash
# agent-wiki pre-commit — check-all 통과 못 하면 커밋 차단(가짜0 금지의 런타임 게이트)
exec bash "$(git rev-parse --show-toplevel)/.claude/hooks/pre-commit.sh"
HOOK
chmod +x .git/hooks/pre-commit
echo "✅ .git/hooks/pre-commit 배선 완료 → 커밋 시 scripts/check-all.sh 강제"
