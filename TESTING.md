# Semantic Release Testing Guide

This package is set up for testing semantic-release configurations with support for main, alpha, and next release channels.

## Setup

1. **Install dependencies:**
   ```bash
   npm install
   ```

2. **Initialize git repository (if not already done):**
   ```bash
   git init
   git add .
   git commit -m "chore: initial commit"
   ```

3. **Set up environment variables (optional for dry-run):**
   ```bash
   # For actual releases (not needed for dry-run):
   export GITHUB_TOKEN="your_github_token"
   export NPM_TOKEN="your_npm_token"
   ```

## Quick Start - Interactive Test Scenarios

Run the interactive test script:

```bash
./test-scenarios.sh
```

This will guide you through 6 different test scenarios:
1. Patch release (fix commit)
2. Minor release (feat commit)
3. Major release (breaking change)
4. Alpha pre-release
5. Next pre-release
6. Reset repository to initial state

## Manual Testing

### Test Scenario 1: Patch Release (Main Branch)

```bash
# Ensure you're on main branch
git checkout -B main

# Make a fix commit
echo "// Bug fix" >> src/index.ts
git add .
git commit -m "fix: resolve division precision issue"

# Dry-run release (should bump patch version)
npm run release:dry
```

Expected: `1.0.0 → 1.0.1`

### Test Scenario 2: Minor Release (Main Branch)

```bash
# Ensure you're on main branch
git checkout main

# Make a feature commit
echo "// New feature" >> src/index.ts
git add .
git commit -m "feat: add modulo operation to calculator"

# Dry-run release (should bump minor version)
npm run release:dry
```

Expected: `1.0.0 → 1.1.0`

### Test Scenario 3: Major Release (Main Branch)

```bash
# Ensure you're on main branch
git checkout main

# Make a breaking change commit
echo "// Breaking change" >> src/index.ts
git add .
git commit -m "feat: redesign calculator API

BREAKING CHANGE: Calculator methods now return objects instead of numbers"

# Dry-run release (should bump major version)
npm run release:dry
```

Expected: `1.0.0 → 2.0.0`

### Test Scenario 4: Alpha Pre-release

```bash
# Create and checkout alpha branch
git checkout -B alpha

# Make a feature commit
echo "// Alpha feature" >> src/index.ts
git add .
git commit -m "feat: add experimental power function"

# Dry-run alpha release
npm run release:dry:alpha
```

Expected: `1.1.0-alpha.1` (or increment if alpha already exists)

### Test Scenario 5: Next Pre-release

```bash
# Create and checkout next branch
git checkout -B next

# Make a feature commit
echo "// Next feature" >> src/index.ts
git add .
git commit -m "feat: add square root function"

# Dry-run next release
npm run release:dry:next
```

Expected: `1.1.0-next.1` (or increment if next already exists)

## Available NPM Scripts

### Dry-run Scripts (Safe Testing)
- `npm run release:dry` - Test release on main branch
- `npm run release:dry:alpha` - Test alpha pre-release
- `npm run release:dry:next` - Test next pre-release

### Actual Release Scripts (Use with caution)
- `npm run release` - Actual release on main branch
- `npm run release:alpha` - Actual alpha pre-release
- `npm run release:next` - Actual next pre-release

### Other Scripts
- `npm run build` - Build TypeScript
- `npm test` - Run tests

## Commit Message Format

This project follows the [Conventional Commits](https://www.conventionalcommits.org/) specification:

- `feat:` - New feature (minor version bump)
- `fix:` - Bug fix (patch version bump)
- `perf:` - Performance improvement (patch version bump)
- `refactor:` - Code refactoring (patch version bump)
- `docs:` - Documentation only (no release)
- `style:` - Code style changes (no release)
- `test:` - Adding tests (no release)
- `chore:` - Maintenance tasks (no release)

Add `BREAKING CHANGE:` in commit body for major version bump.

### Examples

**Patch release:**
```bash
git commit -m "fix: correct calculator rounding error"
```

**Minor release:**
```bash
git commit -m "feat: add percentage calculation method"
```

**Major release:**
```bash
git commit -m "feat: change API to async methods

BREAKING CHANGE: All calculator methods now return Promises"
```

## Branch Configuration

The `.releaserc.json` file configures three release channels:

1. **main** - Production releases (1.0.0, 1.1.0, 2.0.0)
2. **alpha** - Alpha pre-releases (1.1.0-alpha.1, 1.1.0-alpha.2)
3. **next** - Next pre-releases (1.1.0-next.1, 1.1.0-next.2)

## What Gets Released

When semantic-release runs, it will:

1. ✅ Analyze commits since last release
2. ✅ Determine version bump (major/minor/patch)
3. ✅ Generate release notes
4. ✅ Update `CHANGELOG.md`
5. ✅ Update `package.json` version
6. ✅ Create git tag
7. ✅ Publish to npm (if configured)
8. ✅ Create GitHub release (if configured)

## Troubleshooting

### "No release published" message

This is normal if:
- No commits with feat/fix/BREAKING CHANGE since last release
- Only commits with docs/chore/style/test types

### Dry-run shows errors

Dry-run will show some errors for GitHub/npm publishing, which is expected when tokens aren't configured. Focus on whether the version number calculation is correct.

## Resetting Test State

To reset and start over:

```bash
# Option 1: Use the interactive script
./test-scenarios.sh
# Choose option 6

# Option 2: Manual reset
git checkout main
git reset --hard HEAD~5  # Adjust number based on commits
```

## Next Steps

After testing locally with dry-run:

1. Configure GitHub repository
2. Set up `GITHUB_TOKEN` in CI/CD
3. Set up `NPM_TOKEN` in CI/CD
4. Remove `--dry-run` flags when ready for actual releases
5. Set up branch protection rules for main
