#!/usr/bin/env bash
# Overwrites environments/<env>.yaml with new desired state. Pure file I/O.
#
# Usage: update_environment_file.sh <env> <image_tag> <image_digest> <promoted_from>
set -euo pipefail

ENV="${1:?}"
IMAGE_TAG="${2:?}"
IMAGE_DIGEST="${3:?}"
PROMOTED_FROM="${4:?}"

cat > "environments/${ENV}.yaml" <<EOF
image_tag: "${IMAGE_TAG}"
image_digest: "${IMAGE_DIGEST}"
promoted_from: "${PROMOTED_FROM}"
promoted_at: "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
promoted_by: "pending human approval"
EOF
