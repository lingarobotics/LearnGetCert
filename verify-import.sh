#!/bin/bash
# Verification Script for Repository Import
# Run this after import to verify everything is correct

set -e

TARGET_PREFIX="learn-get-happy"
EXPECTED_AT_ROOT=("README.md" "idea.html")

echo "==================================="
echo "Import Verification Script"
echo "==================================="
echo ""

# Check if we're in the right directory
if [ ! -d ".git" ]; then
    echo "✗ Error: Not in a git repository"
    exit 1
fi
echo "✓ In git repository"

# Check if import directory exists
if [ ! -d "$TARGET_PREFIX" ]; then
    echo "✗ Error: $TARGET_PREFIX directory not found"
    echo "  The import may not have completed successfully"
    exit 1
fi
echo "✓ Import directory exists: $TARGET_PREFIX/"

# Check if import directory has files
FILE_COUNT=$(find "$TARGET_PREFIX" -type f | wc -l)
if [ "$FILE_COUNT" -eq 0 ]; then
    echo "✗ Error: $TARGET_PREFIX directory is empty"
    exit 1
fi
echo "✓ Import directory contains $FILE_COUNT files"

# Verify existing files are still present
echo ""
echo "Checking existing repository files..."
for file in "${EXPECTED_AT_ROOT[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✓ $file exists"
    else
        echo "  ✗ Warning: Expected file $file not found"
    fi
done

# Check for unexpected files at root (excluding documentation)
echo ""
echo "Checking for unexpected files at root..."
# Define allowed files
ALLOWED_FILES=("$TARGET_PREFIX" ".git" "README.md" "idea.html" "INDEX.md")
ALLOWED_PATTERNS=("IMPORT_" "PR_DESCRIPTION.md" "import-repository.sh" "verify-import.sh" "QUICKSTART.md")

# Get all files and filter against allowed list
UNEXPECTED_FILES=""
for file in *; do
    SKIP=false
    # Check exact matches
    for allowed in "${ALLOWED_FILES[@]}"; do
        if [ "$file" = "$allowed" ]; then
            SKIP=true
            break
        fi
    done
    # Check pattern matches
    if [ "$SKIP" = false ]; then
        for pattern in "${ALLOWED_PATTERNS[@]}"; do
            if [[ "$file" == "$pattern"* ]]; then
                SKIP=true
                break
            fi
        done
    fi
    # If not skipped, it's unexpected
    if [ "$SKIP" = false ]; then
        UNEXPECTED_FILES="$UNEXPECTED_FILES$file"$'\n'
    fi
done
if [ -z "$UNEXPECTED_FILES" ]; then
    echo "  ✓ No unexpected files at root"
else
    echo "  ⚠ Warning: Unexpected files found at root:"
    echo "$UNEXPECTED_FILES" | while read -r file; do
        echo "    - $file"
    done
fi

# Verify git history for imported files
echo ""
echo "Checking commit history..."
COMMIT_COUNT=$(git log --oneline "$TARGET_PREFIX" 2>/dev/null | wc -l || echo "0")
if [ "$COMMIT_COUNT" -gt 0 ]; then
    echo "  ✓ Found $COMMIT_COUNT commits in import history"
    echo ""
    echo "  Recent commits in $TARGET_PREFIX:"
    git log --oneline "$TARGET_PREFIX" | head -5 | while read -r line; do
        echo "    $line"
    done
else
    echo "  ✗ Warning: No commit history found for $TARGET_PREFIX"
    echo "    History may not have been preserved"
fi

# Check branch
echo ""
echo "Current branch: $(git branch --show-current)"
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" = "import/learn-get-happy" ]; then
    echo "  ✓ On import branch"
elif [ "$CURRENT_BRANCH" = "main" ]; then
    echo "  ⚠ Warning: On main branch (expected import/learn-get-happy)"
else
    echo "  ℹ On branch: $CURRENT_BRANCH"
fi

# Summary
echo ""
echo "==================================="
echo "Verification Summary"
echo "==================================="
echo ""
echo "Directory Structure:"
echo "  LearnGetCert/"
echo "  ├── README.md (existing)"
echo "  ├── idea.html (existing)"
for file in IMPORT_README.md IMPORT_INSTRUCTIONS.md PR_DESCRIPTION.md import-repository.sh verify-import.sh; do
    if [ -f "$file" ]; then
        echo "  ├── $file (documentation, can be removed after merge)"
    fi
done
echo "  └── $TARGET_PREFIX/ ($FILE_COUNT files imported)"
echo ""

# Check if directory looks correct
echo "Sample files in $TARGET_PREFIX/:"
ls -la "$TARGET_PREFIX" | head -10

echo ""
echo "==================================="
echo "Next Steps"
echo "==================================="
echo ""
echo "1. Review the imported files:"
echo "   cd $TARGET_PREFIX && ls -la"
echo ""
echo "2. Check commit history:"
echo "   git log --oneline $TARGET_PREFIX | head -20"
echo ""
echo "3. Run tests (if applicable):"
echo "   npm test  # or your test command"
echo ""
echo "4. Push the branch:"
echo "   git push -u origin import/learn-get-happy"
echo ""
echo "5. Create pull request:"
echo "   gh pr create --base main --head import/learn-get-happy \\"
echo "     --title 'Import lingarobotics/learn-get-happy into learngetcert' \\"
echo "     --body-file PR_DESCRIPTION.md"
echo ""

exit 0
