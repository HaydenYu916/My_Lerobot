#!/usr/bin/env bash

set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 user@host [remote_base_dir]" >&2
  exit 1
fi

TARGET_HOST="$1"
REMOTE_BASE_DIR="${2:-\$HOME/hao_new}"
LOCAL_BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
REMOTE_PROJECT_DIR="${REMOTE_BASE_DIR}/lerobot"

echo "Syncing ${LOCAL_BASE_DIR} -> ${TARGET_HOST}:${REMOTE_BASE_DIR}"
rsync -avz --delete \
  --exclude '.git/' \
  --exclude '.venv/' \
  --exclude '__pycache__/' \
  --exclude '*.pyc' \
  "${LOCAL_BASE_DIR}/" "${TARGET_HOST}:${REMOTE_BASE_DIR}/"

echo "Running remote bootstrap on ${TARGET_HOST}"
ssh "$TARGET_HOST" "bash ${REMOTE_PROJECT_DIR}/deploy/bootstrap_server.sh ${REMOTE_PROJECT_DIR}"

echo
echo "Done."
echo "Remote project: ${TARGET_HOST}:${REMOTE_PROJECT_DIR}"
echo "If you need optional extras, run:"
echo "  ssh ${TARGET_HOST} 'LEROBOT_EXTRAS=feetech,intelrealsense bash ${REMOTE_PROJECT_DIR}/deploy/bootstrap_server.sh ${REMOTE_PROJECT_DIR}'"
