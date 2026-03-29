#!/usr/bin/env bash
# deploy.sh — Syncs grants-portal to public GitHub repo.
# Usage: bash apps/grants-portal/deploy.sh

set -e

SITE_DIR="C:/croquet-os/apps/grants-portal"
DEPLOY_DIR="C:/croquet-os/apps/.grants-portal-deploy"
REMOTE="https://github.com/automatebrisbaneai/grants-portal.git"

VAULT_HASH=$(git -C "C:/croquet-os" rev-parse --short HEAD 2>/dev/null || echo "unknown")

echo "Syncing grants-portal to public repo..."
echo "Vault commit: $VAULT_HASH"

# 1. Ensure local clone exists
if [ ! -d "$DEPLOY_DIR/.git" ]; then
    echo "Cloning public repo (first time only)..."
    git clone "$REMOTE" "$DEPLOY_DIR"
else
    echo "Pulling latest from public repo..."
    git -C "$DEPLOY_DIR" pull --ff-only origin main 2>/dev/null || true
fi

# 2. Wipe existing content (except .git)
find "$DEPLOY_DIR" -mindepth 1 -maxdepth 1 ! -name '.git' -exec rm -rf {} +

# 3. Copy site files in (NO config.js — API key must not go to public repo)
cp "$SITE_DIR/index.html" "$DEPLOY_DIR/"
cp "$SITE_DIR/grants.json" "$DEPLOY_DIR/"
cp "$SITE_DIR/deploy.sh" "$DEPLOY_DIR/"

# 4. Stage all changes
git -C "$DEPLOY_DIR" add -A

# 5. Check if there's anything to commit
if git -C "$DEPLOY_DIR" diff --cached --quiet; then
    echo "No changes to sync — public repo already up to date."
    exit 0
fi

# 6. Commit and push
git -C "$DEPLOY_DIR" commit -m "sync: vault $VAULT_HASH"
git -C "$DEPLOY_DIR" push origin main

echo "Synced to public repo (vault $VAULT_HASH)"
