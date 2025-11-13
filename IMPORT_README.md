# Repository Import: learn-get-happy → LearnGetCert

This directory contains tools and documentation for importing the `lingarobotics/learn-get-happy` repository into `lingarobotics/learngetcert` while preserving commit history.

## Overview

This import will:
- ✅ Preserve complete commit history from the source repository
- ✅ Place all imported files under `learn-get-happy/` directory
- ✅ Keep existing LearnGetCert files untouched
- ✅ Enable future updates from source repository
- ✅ Maintain clean repository structure

## Quick Start

### Option 1: Automated Script (Recommended)

Run the provided script:

```bash
./import-repository.sh
```

This will:
1. Create/checkout the `import/learn-get-happy` branch
2. Add source repository as remote
3. Fetch source repository
4. Import using git subtree
5. Verify the import

### Option 2: GitHub Actions Workflow

A GitHub Actions workflow template is provided at `.github/workflows/import-repository.yml.template`.

To use it:
1. Rename the file: `mv .github/workflows/import-repository.yml.template .github/workflows/import-repository.yml`
2. Go to Actions tab in GitHub
3. Select "Import learn-get-happy Repository" workflow
4. Click "Run workflow"
5. Review and merge the created PR

### Option 3: Manual Import

If you prefer manual control, follow the steps in `IMPORT_INSTRUCTIONS.md`.

## Files in This PR

| File | Purpose |
|------|---------|
| `import-repository.sh` | Automated import script (recommended) |
| `verify-import.sh` | Verification script to run after import |
| `IMPORT_INSTRUCTIONS.md` | Detailed manual instructions |
| `IMPORT_README.md` | This file - overview and quick reference |
| `PR_DESCRIPTION.md` | Template for the PR description |
| `.github/workflows/import-repository.yml.template` | Optional GitHub Actions workflow |

## Requirements

- Git with subtree support (usually included in Git 1.7.11+)
- Write access to lingarobotics/LearnGetCert repository
- Read access to lingarobotics/learn-get-happy repository
- GitHub CLI (optional, for creating PR)

## Import Methods

### Method 1: Git Subtree (Recommended)

```bash
git subtree add --prefix=learn-get-happy source-repo/main
```

**Advantages:**
- Preserves complete commit history
- Easy to pull future updates
- Integrated into Git
- Well-documented

**Disadvantages:**
- Requires Git 1.7.11+
- Slightly more complex than simple copy

### Method 2: Read-Tree (Alternative)

```bash
git read-tree --prefix=learn-get-happy/ -u source-repo/main
```

**Advantages:**
- Works with older Git versions
- Simpler operation

**Disadvantages:**
- May not preserve full history as cleanly
- Harder to pull future updates

### Method 3: Filter-Repo (Advanced)

For complex scenarios, see `IMPORT_INSTRUCTIONS.md` for filter-repo approach.

## Troubleshooting

### Error: Source repository not found

**Problem:** `fatal: Authentication failed` or `404 Not Found`

**Solutions:**
1. Verify the repository URL is correct
2. Check you have read access to the source repository
3. If private, authenticate with:
   ```bash
   gh auth login
   # or
   git config --global credential.helper store
   ```

### Error: Subtree command not found

**Problem:** `git: 'subtree' is not a git command`

**Solutions:**
1. Update Git to 1.7.11 or later
2. Use the read-tree method instead (see IMPORT_INSTRUCTIONS.md)

### Merge Conflicts

**Problem:** Files from source conflict with target repository

**Solutions:**
1. The import uses `--prefix` so conflicts should be rare
2. If conflicts occur, keep target repo files and place source files under `learn-get-happy/`
3. Manually resolve: `git status` and edit conflicting files

### Permission Denied

**Problem:** Cannot push to origin

**Solutions:**
1. Verify you have write access to the repository
2. Check authentication: `gh auth status`
3. Use SSH instead of HTTPS if needed

## Verification Steps

After import, verify everything is correct:

### 1. Check Directory Structure

```bash
ls -la
# Should show: README.md, idea.html, learn-get-happy/

ls -la learn-get-happy/
# Should show files from source repository
```

### 2. Verify Commit History

```bash
git log --oneline learn-get-happy/ | head -20
# Should show commits from source repository
```

### 3. Check File Count

```bash
find learn-get-happy -type f | wc -l
# Should match file count in source repository
```

### 4. Verify No Root Files Added

```bash
git diff main --name-only | grep -v "^learn-get-happy/"
# Should only show IMPORT_* files (can be removed after merge)
```

## Post-Import Actions

### Push and Create PR

```bash
# Push the branch
git push -u origin import/learn-get-happy

# Create PR (using gh CLI)
gh pr create --base main --head import/learn-get-happy \
  --title "Import lingarobotics/learn-get-happy into learngetcert" \
  --body-file PR_DESCRIPTION.md
```

### Clean Up Documentation Files

After the PR is merged, you can remove the import documentation:

```bash
git rm IMPORT_README.md IMPORT_INSTRUCTIONS.md PR_DESCRIPTION.md import-repository.sh
git commit -m "Clean up import documentation files"
```

### Remove Source Remote (Optional)

If you don't need to pull future updates:

```bash
git remote remove source-repo
```

## Future Updates

To pull updates from the source repository:

```bash
# Preserving individual commits
git subtree pull --prefix=learn-get-happy source-repo main

# Squashing all updates into one commit
git subtree pull --prefix=learn-get-happy source-repo main --squash
```

## Support

For issues or questions:

1. Check troubleshooting section above
2. Review `IMPORT_INSTRUCTIONS.md` for detailed steps
3. Contact repository maintainers (lingarobotics)
4. Check Git subtree documentation: `git subtree --help`

## Expected Timeline

- Import preparation: 5 minutes
- Running import script: 2-5 minutes
- Verification: 5 minutes
- PR review: 1-2 days
- Merge: 1 minute

Total: ~15 minutes of active work + review time

## License Considerations

Ensure that:
- Source repository license is compatible with target repository
- Proper attribution is maintained
- License files are preserved in `learn-get-happy/` directory

Review licenses before merging!

## Additional Resources

- [Git Subtree Documentation](https://git-scm.com/book/en/v2/Git-Tools-Advanced-Merging#_subtree_merge)
- [GitHub CLI Documentation](https://cli.github.com/manual/)
- [Git Read-Tree Documentation](https://git-scm.com/docs/git-read-tree)

---

**Note:** This import preserves the complete history of the source repository. All original commits, authors, and timestamps are maintained under the `learn-get-happy/` directory.
