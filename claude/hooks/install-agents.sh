#!/usr/bin/env bash
# Installs msitarzewski/agency-agents into ~/.claude/agents/ for cloud sessions.
set -euo pipefail

[ "${CLAUDE_CODE_REMOTE:-}" = "true" ] || exit 0

AGENTS_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/agents"
SRC_DIR="$HOME/.cache/agency-agents"

# Already installed (e.g. resumed container): nothing to do.
if [ -d "$AGENTS_DIR" ] && [ -n "$(ls -A "$AGENTS_DIR" 2>/dev/null)" ]; then
  exit 0
fi

if [ -d "$SRC_DIR/.git" ]; then
  git -C "$SRC_DIR" pull --ff-only --quiet || true
else
  GIT_LFS_SKIP_SMUDGE=1 git clone --depth 1 --quiet \
    https://github.com/msitarzewski/agency-agents "$SRC_DIR"
fi

(cd "$SRC_DIR" && ./scripts/install.sh --tool claude-code --no-interactive)
