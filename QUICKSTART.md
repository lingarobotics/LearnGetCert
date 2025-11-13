# Quick Start: Import learn-get-happy Repository

**Goal:** Import `lingarobotics/learn-get-happy` into `lingarobotics/learngetcert` with full history preservation.

## TL;DR - Just Run This

```bash
./import-repository.sh
```

Then:
```bash
./verify-import.sh
git push -u origin import/learn-get-happy
gh pr create --base main --head import/learn-get-happy \
  --title "Import lingarobotics/learn-get-happy into learngetcert" \
  --body-file PR_DESCRIPTION.md
```

## What You Get

After import, your repository will look like:

```
LearnGetCert/
├── README.md                  (existing - unchanged)
├── idea.html                  (existing - unchanged)
└── learn-get-happy/          (new - imported with full history)
    ├── [all files from learn-get-happy]
    └── ...
```

## Prerequisites

- Git 1.7.11+ (for subtree support)
- Write access to lingarobotics/LearnGetCert
- Read access to lingarobotics/learn-get-happy
- GitHub CLI (optional, for PR creation)

## Three Import Methods

### Method 1: Automated Script ⭐ (Recommended)

```bash
./import-repository.sh
```

**Pros:** Fully automated, handles everything
**Time:** 2-5 minutes

### Method 2: GitHub Actions

1. Rename workflow: `mv .github/workflows/import-repository.yml.template .github/workflows/import-repository.yml`
2. Push to enable workflow
3. Go to Actions tab → "Import learn-get-happy Repository" → Run workflow
4. Review the automatically created PR

**Pros:** No local setup needed, creates PR automatically
**Time:** 5-10 minutes (automated)

### Method 3: Manual

See `IMPORT_INSTRUCTIONS.md` for detailed step-by-step instructions.

**Pros:** Full control over each step
**Time:** 10-15 minutes

## After Import

### Verify Everything Worked

```bash
./verify-import.sh
```

This checks:
- ✓ Import directory exists and has files
- ✓ Existing files unchanged
- ✓ Commit history preserved
- ✓ No unexpected files at root

### Create the Pull Request

```bash
# Push the import branch
git push -u origin import/learn-get-happy

# Create PR (using gh CLI)
gh pr create --base main --head import/learn-get-happy \
  --title "Import lingarobotics/learn-get-happy into learngetcert" \
  --body-file PR_DESCRIPTION.md

# Or create PR manually via GitHub UI
```

### Review Checklist for the PR

- [ ] Build/tests pass
- [ ] License compatibility confirmed
- [ ] File placement correct (all under `learn-get-happy/`)
- [ ] Commit history preserved
- [ ] No unintended changes to existing files

## Troubleshooting

### "Authentication failed"

**Solution:** The source repository requires authentication.

If you have access:
```bash
gh auth login
# Then run import script again
```

If you don't have access, contact the repository owner.

### "Subtree not found"

**Solution:** Update Git or use the alternative method in `IMPORT_INSTRUCTIONS.md`.

### "Conflicts detected"

**Solution:** Unlikely with `--prefix`, but if it happens:
1. Keep target repo files at root
2. Ensure source files go under `learn-get-happy/`
3. Manually resolve with `git status` and edit

## What Gets Preserved

✅ **All commits** - Complete history from source repo
✅ **Authors** - Original commit authors maintained
✅ **Timestamps** - Original commit dates preserved  
✅ **File structure** - All files/directories from source

## Future Updates

Pull updates from source repository:

```bash
# With history preservation
git subtree pull --prefix=learn-get-happy source-repo main

# Or squashed (single commit)
git subtree pull --prefix=learn-get-happy source-repo main --squash
```

## Cleanup After Merge

Remove import documentation:
```bash
git rm IMPORT_*.md PR_DESCRIPTION.md QUICKSTART.md \
  import-repository.sh verify-import.sh \
  .github/workflows/import-repository.yml.template

git commit -m "Clean up import documentation"
```

Optionally remove source remote:
```bash
git remote remove source-repo
```

## Need Help?

1. **Quick reference:** This file (QUICKSTART.md)
2. **Detailed instructions:** IMPORT_INSTRUCTIONS.md
3. **Complete overview:** IMPORT_README.md
4. **Troubleshooting:** IMPORT_README.md → Troubleshooting section

## Files Reference

| File | Purpose | When to Use |
|------|---------|-------------|
| **QUICKSTART.md** | This file - fastest path to import | Start here |
| **import-repository.sh** | Automated import script | Run to import |
| **verify-import.sh** | Verification script | Run after import |
| **IMPORT_README.md** | Comprehensive overview | Detailed reference |
| **IMPORT_INSTRUCTIONS.md** | Step-by-step manual guide | Manual import |
| **PR_DESCRIPTION.md** | PR description template | Creating PR |

## Expected Timeline

- **Setup:** 1 minute (read this file)
- **Import:** 2-5 minutes (run script)
- **Verify:** 2 minutes (run verification)
- **Push & PR:** 2 minutes
- **Total:** ~10 minutes active work

Then wait for PR review and merge.

---

**Ready?** Run: `./import-repository.sh` 🚀
