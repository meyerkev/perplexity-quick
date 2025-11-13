#!/bin/bash
set -e

# Get current timestamp down to the second
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
BRANCH_NAME="dependency-upgrade-${TIMESTAMP}"

echo "Creating branch: ${BRANCH_NAME}"

# Checkout new branch
git checkout -b "${BRANCH_NAME}"

echo "Running make upgrade..."

# Run make upgrade
make upgrade

# Check if there are any changes
if git diff --quiet requirements.txt; then
    echo "No changes to requirements.txt. Nothing to commit."
    git checkout main
    git branch -d "${BRANCH_NAME}"
    exit 0
fi

echo "Committing changes..."

# Stage and commit changes
git add requirements.txt
git commit -m "Upgrade dependencies to latest versions"

echo "Pushing branch to origin..."

# Push branch to origin
git push -u origin "${BRANCH_NAME}"

echo "Creating pull request..."

# Create pull request using GitHub CLI
gh pr create --title "Upgrade dependencies (${TIMESTAMP})" --body "Automated dependency upgrade from requirements.base.txt" || {
    echo "Failed to create PR. You may need to install GitHub CLI (gh) or authenticate."
    echo "Branch pushed successfully. Create PR manually at: https://github.com/$(git config --get remote.origin.url | sed 's/.*github.com[:/]\(.*\)\.git/\1/')/compare/${BRANCH_NAME}"
    exit 1
}

echo "Done! Pull request created successfully."

