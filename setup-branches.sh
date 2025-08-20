#!/bin/bash

# WordPress Docker Development Setup - Branch Strategy Initialization
# Initialisiert die Branch-Strategie und GitHub Protection Rules

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🌿 Initializing Branch Strategy${NC}"
echo -e "${BLUE}==============================${NC}"
echo ""

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo -e "${RED}❌ Not in a git repository. Please run 'git init' first.${NC}"
    exit 1
fi

# Check if remote origin exists
if ! git remote get-url origin > /dev/null 2>&1; then
    echo -e "${YELLOW}⚠️ No remote origin found. Please add your GitHub repository:${NC}"
    echo -e "${YELLOW}   git remote add origin <your-github-repo-url>${NC}"
    exit 1
fi

echo -e "${BLUE}📋 Creating branches...${NC}"

# Create develop branch
if ! git show-ref --verify --quiet refs/heads/develop; then
    echo -e "${YELLOW}🌿 Creating develop branch...${NC}"
    git checkout -b develop
    git push -u origin develop
    echo -e "${GREEN}✅ develop branch created and pushed${NC}"
else
    echo -e "${GREEN}✅ develop branch already exists${NC}"
fi

# Create prod branch
if ! git show-ref --verify --quiet refs/heads/prod; then
    echo -e "${YELLOW}🚀 Creating prod branch...${NC}"
    git checkout -b prod
    git push -u origin prod
    echo -e "${GREEN}✅ prod branch created and pushed${NC}"
else
    echo -e "${GREEN}✅ prod branch already exists${NC}"
fi

# Switch back to main
git checkout main

echo ""
echo -e "${BLUE}🔧 Setting up branch protection...${NC}"

# Create branch protection configuration
cat > .github/branch-protection.md << 'EOF'
# Branch Protection Rules Setup

## Required GitHub Settings

### 1. main Branch Protection:
- ✅ Require a pull request before merging
- ✅ Require status checks to pass before merging
- ✅ Require branches to be up to date before merging
- ✅ Require conversation resolution before merging
- ✅ Include administrators
- ✅ Restrict pushes that create files that use the git push --force-with-lease command

### 2. prod Branch Protection:
- ✅ Require a pull request before merging
- ✅ Require status checks to pass before merging
- ✅ Require branches to be up to date before merging
- ✅ Require conversation resolution before merging
- ✅ Include administrators
- ✅ Restrict pushes that create files that use the git push --force-with-lease command
- 🚀 Require deployments to succeed before merging

### 3. develop Branch Protection:
- ✅ Require a pull request before merging
- ✅ Require status checks to pass before merging
- ✅ Require branches to be up to date before merging

## Status Checks to Require:
- CI - Tests

## Setup Instructions:
1. Go to your GitHub repository
2. Navigate to Settings > Branches
3. Add rule for each branch (main, prod, develop)
4. Configure the settings as listed above
5. Save changes
EOF

echo -e "${GREEN}✅ Branch protection configuration created${NC}"

# Create initial commit for new branches
echo ""
echo -e "${BLUE}📝 Creating initial commits...${NC}"

# Check if we have uncommitted changes
if [ -n "$(git status --porcelain)" ]; then
    echo -e "${YELLOW}📦 Committing current changes...${NC}"
    git add .
    git commit -m "feat: initial branch strategy setup"
    git push origin main
    echo -e "${GREEN}✅ Changes committed and pushed to main${NC}"
fi

# Update develop branch with latest changes
echo -e "${YELLOW}🔄 Updating develop branch...${NC}"
git checkout develop
git merge main
git push origin develop
echo -e "${GREEN}✅ develop branch updated${NC}"

# Update prod branch with latest changes
echo -e "${YELLOW}🔄 Updating prod branch...${NC}"
git checkout prod
git merge main
git push origin prod
echo -e "${GREEN}✅ prod branch updated${NC}"

# Switch back to main
git checkout main

echo ""
echo -e "${BLUE}📋 Branch Structure Summary${NC}"
echo -e "${BLUE}==========================${NC}"
git branch -a
echo ""

echo -e "${GREEN}🎉 Branch strategy initialized successfully!${NC}"
echo ""
echo -e "${BLUE}📋 Next Steps:${NC}"
echo -e "1. ${YELLOW}Configure branch protection rules in GitHub${NC}"
echo -e "2. ${YELLOW}Set up GitHub Secrets for deployment${NC}"
echo -e "3. ${YELLOW}Test the CI/CD pipeline${NC}"
echo ""
echo -e "${BLUE}📚 Documentation:${NC}"
echo -e "- Branch Strategy: BRANCH_STRATEGY.md"
echo -e "- Branch Protection: .github/branch-protection.md"
echo ""
echo -e "${GREEN}Happy coding! 🚀${NC}"
