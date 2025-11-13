#!/bin/bash
# Repository Import Script
# This script imports lingarobotics/learn-get-happy into lingarobotics/learngetcert
# Preserves commit history using git subtree

set -e  # Exit on error

# Configuration
SOURCE_REPO_URL="https://github.com/lingarobotics/learn-get-happy.git"
SOURCE_BRANCH="main"
TARGET_PREFIX="learn-get-happy"
REMOTE_NAME="source-repo"
IMPORT_BRANCH="import/learn-get-happy"

echo "==================================="
echo "Repository Import Script"
echo "==================================="
echo ""
echo "Source: $SOURCE_REPO_URL"
echo "Target Directory: $TARGET_PREFIX/"
echo "Import Branch: $IMPORT_BRANCH"
echo ""

# Step 1: Ensure we're on the main branch
echo "Step 1: Checking out main branch..."
git fetch origin main
git checkout main
git pull origin main || echo "Already up to date"
echo "✓ On main branch"
echo ""

# Step 2: Create import branch
echo "Step 2: Creating import branch..."
if git rev-parse --verify "$IMPORT_BRANCH" >/dev/null 2>&1; then
    echo "Branch $IMPORT_BRANCH already exists, switching to it..."
    git checkout "$IMPORT_BRANCH"
else
    echo "Creating new branch $IMPORT_BRANCH..."
    git checkout -b "$IMPORT_BRANCH"
fi
echo "✓ Import branch ready"
echo ""

# Step 3: Add source repository as remote
echo "Step 3: Adding source repository as remote..."
if git remote get-url "$REMOTE_NAME" >/dev/null 2>&1; then
    echo "Remote $REMOTE_NAME already exists"
    git remote set-url "$REMOTE_NAME" "$SOURCE_REPO_URL"
else
    git remote add "$REMOTE_NAME" "$SOURCE_REPO_URL"
fi
echo "✓ Remote configured"
echo ""

# Step 4: Fetch source repository
echo "Step 4: Fetching source repository..."
git fetch "$REMOTE_NAME" "$SOURCE_BRANCH"
echo "✓ Source repository fetched"
echo ""

# Step 5: Import using git subtree
echo "Step 5: Importing repository using git subtree..."
echo "This preserves all commit history from the source repository..."
git subtree add --prefix="$TARGET_PREFIX" "$REMOTE_NAME/$SOURCE_BRANCH"
echo "✓ Repository imported"
echo ""

# Step 6: Verify import
echo "Step 6: Verifying import..."
if [ -d "$TARGET_PREFIX" ]; then
    echo "✓ Directory $TARGET_PREFIX exists"
    echo ""
    echo "Contents of $TARGET_PREFIX:"
    ls -la "$TARGET_PREFIX" | head -20
    echo ""
    echo "Recent commits in imported directory:"
    git log --oneline "$TARGET_PREFIX" | head -10
else
    echo "✗ Error: Directory $TARGET_PREFIX not found!"
    exit 1
fi
echo ""

# Step 7: Show status
echo "Step 7: Repository status..."
echo "Current branch:"
git branch --show-current
echo ""
echo "Remotes:"
git remote -v
echo ""

# Step 8: Push to origin (if desired)
echo "==================================="
echo "Import Complete!"
echo "==================================="
echo ""
echo "Next steps:"
echo "1. Review the imported files: ls -la $TARGET_PREFIX/"
echo "2. Run tests to ensure nothing broke"
echo "3. Push the branch: git push origin $IMPORT_BRANCH"
echo "4. Create a pull request on GitHub"
echo ""
echo "To push now, run:"
echo "  git push -u origin $IMPORT_BRANCH"
echo ""
echo "To create a PR via gh CLI:"
echo "  gh pr create --base main --head $IMPORT_BRANCH \\"
echo "    --title 'Import lingarobotics/learn-get-happy into learngetcert' \\"
echo "    --body-file PR_DESCRIPTION.md"
echo ""
echo "To pull future updates from source repository:"
echo "  git subtree pull --prefix=$TARGET_PREFIX $REMOTE_NAME $SOURCE_BRANCH"
echo ""
