#!/usr/bin/env bash
# Build vLLM from source with CUDA support
# This script handles the complete build process for GPU-enabled vLLM

set -euo pipefail

VLLM_VERSION="${1:-0.8.5}"
VLLM_SRC_DIR="/tmp/vllm-src"

echo "[vLLM CUDA Build] Starting vLLM ${VLLM_VERSION} CUDA build..."

# Clone vLLM repository
echo "[vLLM CUDA Build] Cloning vLLM repository..."
if ! git clone --depth 1 --branch "v${VLLM_VERSION}" https://github.com/vllm-project/vllm.git "${VLLM_SRC_DIR}" 2>/dev/null; then
    echo "[vLLM CUDA Build] Branch v${VLLM_VERSION} not found, using main branch..."
    git clone --depth 1 https://github.com/vllm-project/vllm.git "${VLLM_SRC_DIR}"
fi

cd "${VLLM_SRC_DIR}"

# Install build requirements
echo "[vLLM CUDA Build] Installing build requirements..."
pip install --no-cache-dir -r requirements/build.txt
if [ -f requirements/cuda.txt ]; then
    pip install --no-cache-dir -r requirements/cuda.txt
elif [ -f requirements/common.txt ]; then
    pip install --no-cache-dir -r requirements/common.txt
fi

# Build vLLM from source with CUDA support
echo "[vLLM CUDA Build] Building vLLM with CUDA support (this may take a while)..."
CUDA_HOME="${CUDA_HOME:-/usr/local/cuda}" \
CMAKE_BUILD_PARALLEL_LEVEL="${CMAKE_BUILD_PARALLEL_LEVEL:-4}" \
MAX_JOBS="${MAX_JOBS:-4}" \
SETUPTOOLS_SCM_PRETEND_VERSION="${VLLM_VERSION}" \
pip install --no-cache-dir . --no-build-isolation

# Cleanup
echo "[vLLM CUDA Build] Cleaning up build artifacts..."
rm -rf "${VLLM_SRC_DIR}"

echo "[vLLM CUDA Build] vLLM ${VLLM_VERSION} CUDA build completed successfully!"

