#!/usr/bin/env bash
# Prints the environment name (dev/staging/prod) whose status file changed
# in the most recent commit. Plain git diff - portable to any platform's
# checkout.
set -euo pipefail

CHANGED=$(git diff --name-only HEAD~1 HEAD -- status/)

for env in dev staging prod; do
  if echo "$CHANGED" | grep -q "status/${env}.json"; then
    echo "$env"
    exit 0
  fi
done

echo ""
