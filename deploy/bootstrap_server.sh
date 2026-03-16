#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="${1:-$HOME/hao_new/lerobot}"
ENV_NAME="${2:-lerobot}"
PYTHON_VERSION="${PYTHON_VERSION:-3.10}"
MINIFORGE_DIR="${MINIFORGE_DIR:-$HOME/miniforge3}"
LEROBOT_EXTRAS="${LEROBOT_EXTRAS:-}"
INSTALL_LOCKED="${INSTALL_LOCKED:-0}"

if [[ ! -d "$PROJECT_DIR" ]]; then
  echo "Project directory not found: $PROJECT_DIR" >&2
  exit 1
fi

SUDO=""
if [[ "${EUID}" -ne 0 ]] && command -v sudo >/dev/null 2>&1; then
  SUDO="sudo"
fi

if command -v apt-get >/dev/null 2>&1; then
  ${SUDO} apt-get update
  ${SUDO} apt-get install -y \
    build-essential \
    cmake \
    curl \
    git \
    pkg-config \
    python3-dev \
    wget \
    libavformat-dev \
    libavcodec-dev \
    libavdevice-dev \
    libavutil-dev \
    libswscale-dev \
    libswresample-dev \
    libavfilter-dev
fi

if [[ ! -x "${MINIFORGE_DIR}/bin/conda" ]]; then
  INSTALLER="/tmp/Miniforge3-$(uname)-$(uname -m).sh"
  wget -O "$INSTALLER" "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
  bash "$INSTALLER" -b -p "$MINIFORGE_DIR"
fi

source "${MINIFORGE_DIR}/etc/profile.d/conda.sh"

if ! conda env list | awk '{print $1}' | grep -Fxq "$ENV_NAME"; then
  conda create -y -n "$ENV_NAME" "python=${PYTHON_VERSION}"
fi

conda activate "$ENV_NAME"
conda install -y -c conda-forge ffmpeg

python -m pip install --upgrade pip setuptools wheel

cd "$PROJECT_DIR"

if [[ "$INSTALL_LOCKED" == "1" && -f requirements-ubuntu.txt ]]; then
  python -m pip install -r requirements-ubuntu.txt
elif [[ -n "$LEROBOT_EXTRAS" ]]; then
  python -m pip install -e ".[${LEROBOT_EXTRAS}]"
else
  python -m pip install -e .
fi

echo
echo "Bootstrap complete."
echo "Activate with:"
echo "  source ${MINIFORGE_DIR}/etc/profile.d/conda.sh && conda activate ${ENV_NAME}"
echo "Verify with:"
echo "  cd ${PROJECT_DIR} && lerobot-info"
