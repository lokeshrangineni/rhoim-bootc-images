#!/usr/bin/env bash
# Install vLLM with CUDA support using pre-built wheels
# Falls back to source build only if wheels are unavailable

set -euo pipefail

VLLM_VERSION="${1:-0.12.0}"

echo "[vLLM CUDA] Installing vLLM ${VLLM_VERSION} from PyPI wheels..."

# Try pre-built wheel first (fastest)
if pip install --no-cache-dir "vllm==${VLLM_VERSION}"; then
    echo "[vLLM CUDA] Successfully installed vLLM ${VLLM_VERSION} from PyPI"
else
    echo "[vLLM CUDA] PyPI wheel failed, trying vLLM wheel index..."
    pip install --no-cache-dir "vllm==${VLLM_VERSION}" \
        --extra-index-url https://wheels.vllm.ai/nightly || \
    pip install --no-cache-dir vllm
fi

echo "[vLLM CUDA] vLLM installation completed successfully!"

