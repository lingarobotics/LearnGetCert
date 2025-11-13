# Repository Import Instructions

## Status: Awaiting Source Repository Access

This branch (`import/learn-get-happy`) has been prepared to import the `lingarobotics/learn-get-happy` repository into `lingarobotics/learngetcert` while preserving commit history.

### Issue Encountered

The source repository `https://github.com/lingarobotics/learn-get-happy.git` is either:
- Private and requires authentication
- Does not exist yet
- Has a different name/location

### Completed Steps

1. ✅ Created branch `import/learn-get-happy` from `main`
2. ✅ Added source repository as remote named `source-repo`
3. ⏸️ Unable to fetch source repository (authentication required)

### Manual Steps Required

To complete the import, a repository owner with appropriate access should run the following commands:

```bash
# 1. Navigate to the repository
cd /path/to/LearnGetCert

# 2. Checkout the import branch
git checkout import/learn-get-happy

# 3. Verify the source-repo remote is configured (should already be done)
git remote -v | grep source-repo
# If not present, add it:
# git remote add source-repo https://github.com/lingarobotics/learn-get-happy.git

# 4. Fetch the source repository
git fetch source-repo main

# 5. Import using git subtree (preserves history)
git subtree add --prefix=learn-get-happy source-repo/main

# Alternative if git subtree is not available:
# git read-tree --prefix=learn-get-happy/ -u source-repo/main

# 6. Verify the import
ls -la learn-get-happy/
git log --oneline -20

# 7. Push the changes
git push origin import/learn-get-happy

# 8. Create PR via GitHub UI or CLI:
gh pr create --base main --head import/learn-get-happy \
  --title "Import lingarobotics/learn-get-happy into learngetcert" \
  --body "See PR_DESCRIPTION.md for details"
```

### Verification Steps

After import:
- [ ] Confirm all files from source repo are under `learn-get-happy/` directory
- [ ] Verify commit history is preserved: `git log learn-get-happy/`
- [ ] Check no files were added to repository root unintentionally
- [ ] Build and tests pass
- [ ] License and attribution are correct

### Future Updates

To pull future updates from the source repository:

```bash
git subtree pull --prefix=learn-get-happy source-repo main --squash
```

### Removing the Source Remote (Optional, After Merge)

```bash
git remote remove source-repo
```

### Alternative Method Without Git Subtree

If `git subtree` is not available:

```bash
# Fetch the source repository
git fetch source-repo main

# Create a temporary branch with source content
git branch temp-import source-repo/main

# Create an orphan branch to reorganize files
git checkout --orphan temp-reorg
git rm -rf .
git read-tree --prefix=learn-get-happy/ temp-import
git commit -m "Reorganize files under learn-get-happy/"

# Merge into import branch
git checkout import/learn-get-happy
git merge --allow-unrelated-histories temp-reorg

# Clean up temporary branches
git branch -D temp-import temp-reorg
```

## Expected Repository Structure After Import

```
LearnGetCert/
├── README.md                    (existing)
├── idea.html                    (existing)
└── learn-get-happy/            (imported)
    ├── [all files from source repo]
    └── ...
```

## Questions?

Contact the repository owner (lingarobotics) if:
- The source repository URL is incorrect
- You need different import configuration
- You encounter merge conflicts
