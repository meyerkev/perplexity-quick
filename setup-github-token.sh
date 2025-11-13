#!/bin/bash
# Helper script to set up GitHub token as repository secret

set -e

echo "GitHub Token Setup Helper"
echo "========================"
echo ""
echo "This script will help you set up a GitHub Personal Access Token"
echo "as a repository secret for the dependency upgrade workflow."
echo ""
echo "Prerequisites:"
echo "  1. GitHub CLI (gh) installed and authenticated"
echo "  2. A Personal Access Token with 'repo' scope"
echo ""
echo "If you don't have a token yet, create one at:"
echo "  https://github.com/settings/tokens"
echo ""
read -p "Press Enter to continue or Ctrl+C to exit..."

# Get repository name
REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null || echo "")

if [ -z "$REPO" ]; then
    echo ""
    echo "Could not detect repository. Please provide repository name:"
    echo "  Format: username/repository-name"
    read -p "Repository: " REPO
else
    echo ""
    echo "Detected repository: $REPO"
    read -p "Is this correct? (y/n): " CONFIRM
    if [ "$CONFIRM" != "y" ]; then
        read -p "Enter repository name (username/repo): " REPO
    fi
fi

echo ""
echo "Enter your GitHub Personal Access Token:"
echo "  (Token will be hidden for security)"
read -s TOKEN

if [ -z "$TOKEN" ]; then
    echo "Error: Token cannot be empty"
    exit 1
fi

echo ""
echo "Setting secret 'PAT_TOKEN' for repository $REPO..."

# Set the secret
echo -n "$TOKEN" | gh secret set PAT_TOKEN --repo "$REPO"

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Successfully set PAT_TOKEN secret!"
    echo ""
    echo "You can now run the 'Upgrade Dependencies' workflow from the Actions tab."
else
    echo ""
    echo "❌ Failed to set secret. Please check:"
    echo "  1. GitHub CLI is authenticated (gh auth login)"
    echo "  2. You have admin access to the repository"
    echo "  3. The token is valid"
    exit 1
fi

