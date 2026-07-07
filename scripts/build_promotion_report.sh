#!/usr/bin/env bash
# Builds the promotion report markdown. Pure text generation - no CI
# platform dependency at all.
#
# Usage: build_promotion_report.sh <source_env> <target_env> <image_tag> \
#          <image_digest> <previous_tag> <output_file>
set -euo pipefail

SOURCE_ENV="${1:?}"
TARGET_ENV="${2:?}"
IMAGE_TAG="${3:?}"
IMAGE_DIGEST="${4:?}"
PREVIOUS_TAG="${5:-none}"
OUTPUT_FILE="${6:?}"

cat > "$OUTPUT_FILE" <<EOF
## Promotion Report: ${SOURCE_ENV} → ${TARGET_ENV}

| Field | Value |
|---|---|
| New image tag | \`${IMAGE_TAG}\` |
| Image digest | \`${IMAGE_DIGEST}\` |
| Previous ${TARGET_ENV} tag | \`${PREVIOUS_TAG}\` |
| ${SOURCE_ENV} health check | Passed (Cloud Run Job executed successfully, file confirmed in bucket) |
| Rollback | Revert this merge, or re-promote tag \`${PREVIOUS_TAG}\` |

This PR was opened automatically because **${SOURCE_ENV}** passed its
post-deploy smoke test. Merging it will deploy this image to **${TARGET_ENV}**.

If this PR already existed (multiple ${SOURCE_ENV} deploys batched together),
it has been updated in place to point at the latest verified image rather
than opening a duplicate.
EOF
