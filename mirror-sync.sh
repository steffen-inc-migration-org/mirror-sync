#!/bin/bash
git fetch --all

source_branches=$(git branch --all | grep remotes/source/)

echo "Source branches:"
echo "$source_branches"

for source_branch_ref in $source_branches; do
  source_branch_name=${source_branch_ref#remotes/source/}
  
  # Checkout if source branch exists on mirror
  git rev-parse --verify remotes/origin/"$source_branch_name"
  result_code=$?

  # If branch exists on mirror, pull changes from source repository into it
  # If branch does not exist on mirror, create it from source repository
  if [ $result_code -eq 0 ]; then
    git checkout -B "$source_branch_name" remotes/origin/"$source_branch_name"
    git pull --no-rebase --no-edit source "$source_branch_name"
  else
    git checkout -b "$source_branch_name" "$source_branch_ref"
  fi

  git push origin "$source_branch_name"
  git push source "$source_branch_name"
done
