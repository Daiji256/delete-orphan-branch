#!/bin/bash
set -euo pipefail

now=$(date +%s)
git fetch --prune --all
head="$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null)"
git branch -r --format="%(refname:short)" | while read -r remote; do
  if [[ "$remote" == "origin" ]]; then
    continue
  fi

  if [[ "$remote" == "$head" ]]; then
    continue
  fi

  branch="${remote#origin/}"
  if ! [[ "$branch" =~ $BRANCH_REGEX ]]; then
    continue
  fi

  commit_count=$(git rev-list --count "$remote")
  if [[ "$commit_count" -ne 1 ]]; then
    continue
  fi

  committer_name=$(git log -1 --format=%an "$remote")
  if [[ "$committer_name" != "$EXPECTED_COMMITTER_NAME" ]]; then
    continue
  fi

  committer_email=$(git log -1 --format=%ae "$remote")
  if [[ "$committer_email" != "$EXPECTED_COMMITTER_EMAIL" ]]; then
    continue
  fi

  commit_message=$(git log -1 --format=%s "$remote")
  if [[ -n "${EXPECTED_COMMIT_MESSAGE:-}" && "$commit_message" != "$EXPECTED_COMMIT_MESSAGE" ]]; then
    continue
  fi

  commit_date=$(git log -1 --format=%ct "$remote")
  age=$((now - commit_date))
  if [[ "$age" -lt "$OLDER_THAN_SECONDS" ]]; then
    continue
  fi

  echo "Deleting branch: $branch"
  git push origin --delete "$branch"
done
