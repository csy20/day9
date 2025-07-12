#!/bin/bash

# Git Workflow Helper Script for Flutter Recipe App
# Usage: ./git-helper.sh [command]

case "$1" in
  "setup")
    echo "🔧 Setting up Git configuration..."
    git config --global user.name "Developer"
    git config --global user.email "developer@example.com"
    git config --global init.defaultBranch main
    echo "✅ Git configured successfully!"
    ;;
    
  "status")
    echo "📋 Current Git Status:"
    git status --short
    echo ""
    echo "📊 Repository Info:"
    echo "Current branch: $(git branch --show-current)"
    echo "Total commits: $(git rev-list --count HEAD)"
    echo "Last commit: $(git log -1 --pretty=format:'%h - %s (%cr)')"
    ;;
    
  "log")
    echo "📜 Recent Git History:"
    git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit -10
    ;;
    
  "quick-commit")
    if [ -z "$2" ]; then
      echo "❌ Please provide a commit message"
      echo "Usage: ./git-helper.sh quick-commit \"Your commit message\""
      exit 1
    fi
    echo "🚀 Quick commit process..."
    git add .
    git status --short
    echo ""
    read -p "Proceed with commit? (y/N): " confirm
    if [[ $confirm == [yY] ]]; then
      git commit -m "$2"
      echo "✅ Committed successfully!"
    else
      echo "❌ Commit cancelled"
    fi
    ;;
    
  "feature")
    if [ -z "$2" ]; then
      echo "❌ Please provide a feature name"
      echo "Usage: ./git-helper.sh feature feature-name"
      exit 1
    fi
    echo "🌟 Creating feature branch: feature/$2"
    git checkout -b "feature/$2"
    echo "✅ Feature branch created and checked out!"
    ;;
    
  "finish-feature")
    current_branch=$(git branch --show-current)
    if [[ $current_branch != feature/* ]]; then
      echo "❌ Not on a feature branch"
      exit 1
    fi
    echo "🔄 Finishing feature branch: $current_branch"
    git checkout main
    git merge "$current_branch"
    echo "🗑️  Delete feature branch? (y/N): "
    read confirm
    if [[ $confirm == [yY] ]]; then
      git branch -d "$current_branch"
      echo "✅ Feature branch deleted!"
    fi
    ;;
    
  "sync")
    echo "🔄 Syncing with remote..."
    git fetch --all
    git status
    echo ""
    echo "💡 Run 'git pull' to update your local branch"
    ;;
    
  "backup")
    echo "💾 Creating backup commit..."
    git add .
    git commit -m "Backup: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "✅ Backup created!"
    ;;
    
  "clean")
    echo "🧹 Cleaning repository..."
    echo "This will remove untracked files. Continue? (y/N): "
    read confirm
    if [[ $confirm == [yY] ]]; then
      git clean -fd
      echo "✅ Repository cleaned!"
    fi
    ;;
    
  *)
    echo "🔧 Flutter Recipe App - Git Helper"
    echo "Available commands:"
    echo "  setup           - Configure Git settings"
    echo "  status          - Show detailed repository status"
    echo "  log             - Show recent commit history"
    echo "  quick-commit    - Add all changes and commit with message"
    echo "  feature         - Create a new feature branch"
    echo "  finish-feature  - Merge feature branch back to main"
    echo "  sync            - Fetch updates from remote"
    echo "  backup          - Create a quick backup commit"
    echo "  clean           - Remove untracked files"
    echo ""
    echo "Usage: ./git-helper.sh [command] [arguments]"
    echo "Example: ./git-helper.sh quick-commit \"Add new feature\""
    ;;
esac
