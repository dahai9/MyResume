#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

HOST="${HOST:-127.0.0.1}"
PORT="${PORT:-8010}"

if ! command -v uv >/dev/null 2>&1; then
    echo "uv is required. Install it from https://docs.astral.sh/uv/ and rerun this script." >&2
    exit 1
fi

uv sync

if [[ "$(uname)" == "Darwin" ]]; then
    (sleep 1.5 && open "http://${HOST}:${PORT}/resume") &
fi

echo "Starting MyResume at http://${HOST}:${PORT}/resume"
exec uv run uvicorn app:app --reload --host "$HOST" --port "$PORT"
