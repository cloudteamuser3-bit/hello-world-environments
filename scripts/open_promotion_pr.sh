#!/usr/bin/env bash
# ---- PLATFORM-SPECIFIC SEAM ----
# The only GitHub-specific call in this whole repo: `gh pr create`. On
# GitLab, swap this one script's body for `glab mr create` (or a raw REST
# call) - nothing else in the pipeline needs to change, because every
# caller of this script only passes plain arguments and reads no
# GitHub-specific output.
#
# Usage: open_promotion_pr.sh <branch> <title> <body_file> <labels>
# Requires: gh CLI authenticated (GH_TOKEN env var)
set -euo pipefail

BRANCH="${1:?}"
TITLE="${2:?}"
BODY_FILE="${3:?}"
LABELS="${4:-promotion}"

git checkout -B "$BRANCH"
git add environments/
git commit -m "$TITLE" || { echo "No changes to commit"; exit 0; }
git push --force origin "$BRANCH"

if gh pr list --head "$BRANCH" --json number --jq '.[0].number' | grep -q .; then
  echo "==> Updating existing PR on branch $BRANCH"
  PR_NUMBER=$(gh pr list --head "$BRANCH" --json number --jq '.[0].number')
  gh pr edit "$PR_NUMBER" --body-file "$BODY_FILE"
  PR_URL="$PR_NUMBER"
else
  echo "==> Opening new PR on branch $BRANCH"
  PR_URL=$(gh pr create --base main --head "$BRANCH" --title "$TITLE" --body-file "$BODY_FILE")
fi

if [ -n "${LABELS:-}" ]; then
  # Try to create any labels that don't exist
  IFS=',' read -ra ADDR <<< "$LABELS"
  for label in "${ADDR[@]}"; do
    label=$(echo "$label" | xargs)
    if [ -n "$label" ]; then
      if ! gh label list --json name --jq '.[].name' 2>/dev/null | grep -qFx "$label"; then
        echo "==> Attempting to create label: $label"
        gh label create "$label" --color "bfd4f2" --description "Automatically created label" || true
      fi
    fi
  done

  echo "==> Attempting to add labels to PR ($PR_URL): $LABELS"
  gh pr edit "$PR_URL" --add-label "$LABELS" || echo "==> Failed to add labels (might lack permissions or label doesn't exist)"
fi
# ---- END SEAM ----
