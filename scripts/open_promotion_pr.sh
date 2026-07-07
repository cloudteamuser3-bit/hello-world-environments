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
else
  echo "==> Opening new PR on branch $BRANCH"
  gh pr create --base main --head "$BRANCH" --title "$TITLE" --body-file "$BODY_FILE" --label "$LABELS"
fi
# ---- END SEAM ----
