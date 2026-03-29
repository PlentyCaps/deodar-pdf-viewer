#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────
# Deodar PDF Viewer — release script
# Usage:
#   ./release.sh                        # auto-bumps patch version
#   ./release.sh 1.2.0                  # explicit version
#   ./release.sh 1.2.0 "Release notes"  # version + custom notes
# ─────────────────────────────────────────────────────────────
set -euo pipefail

GH=/home/capsbot/bin/gh
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# ── Colours ──────────────────────────────────────────────────
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
info()    { echo -e "${GREEN}▶ $*${NC}"; }
warn()    { echo -e "${YELLOW}⚠ $*${NC}"; }
die()     { echo -e "${RED}✗ $*${NC}" >&2; exit 1; }

# ── 1. Determine version ──────────────────────────────────────
CURRENT_VERSION=$(grep '^version:' pubspec.yaml | awk '{print $2}' | cut -d+ -f1)

if [[ -n "${1:-}" ]]; then
  NEW_VERSION="$1"
else
  # Auto-bump patch (1.1.0 → 1.1.1)
  IFS='.' read -r MAJOR MINOR PATCH <<< "$CURRENT_VERSION"
  NEW_VERSION="$MAJOR.$MINOR.$((PATCH + 1))"
fi

NOTES="${2:-}"
BUILD_NUMBER=$(grep '^version:' pubspec.yaml | awk '{print $2}' | cut -d+ -f2)
NEW_BUILD=$((BUILD_NUMBER + 1))

info "Current version : $CURRENT_VERSION+$BUILD_NUMBER"
info "New version     : $NEW_VERSION+$NEW_BUILD"

# ── 2. Check for uncommitted changes ─────────────────────────
if [[ -n "$(git status --porcelain)" ]]; then
  warn "Uncommitted changes detected — they will be included in this release commit."
fi

# ── 3. Bump version in pubspec.yaml ──────────────────────────
info "Bumping version in pubspec.yaml…"
sed -i "s/^version: .*/version: $NEW_VERSION+$NEW_BUILD/" pubspec.yaml

# ── 4. flutter pub get ───────────────────────────────────────
info "Running flutter pub get…"
flutter pub get

# ── 5. Build release APK ─────────────────────────────────────
info "Building release APK…"
flutter build apk --release

APK_PATH="build/app/outputs/flutter-apk/app-release.apk"
[[ -f "$APK_PATH" ]] || die "APK not found at $APK_PATH"
APK_SIZE=$(du -sh "$APK_PATH" | cut -f1)
info "APK built: $APK_SIZE"

# ── 6. Commit & push ─────────────────────────────────────────
info "Committing changes…"
git add -A
git commit -m "Release v$NEW_VERSION

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>"

info "Pushing to GitHub…"
git push origin main

# ── 7. Create GitHub release ─────────────────────────────────
TAG="v$NEW_VERSION"

# Delete existing release/tag with same name if present
if $GH release view "$TAG" &>/dev/null; then
  warn "Release $TAG already exists — deleting it…"
  $GH release delete "$TAG" --yes
  git tag -d "$TAG" 2>/dev/null || true
  git push origin ":refs/tags/$TAG" 2>/dev/null || true
fi

if [[ -z "$NOTES" ]]; then
  NOTES="Release $TAG"
fi

info "Creating GitHub release $TAG…"
$GH release create "$TAG" \
  "$APK_PATH#deodar-pdf-viewer.apk" \
  --title "Deodar PDF viewer $TAG" \
  --notes "$NOTES" \
  --latest

info "Done! Release $TAG is live."
$GH release view "$TAG" --json url --jq '.url'
