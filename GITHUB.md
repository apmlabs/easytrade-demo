# GitHub Repository Setup Guide

This guide shows how to create a private GitHub repository from your local project while protecting sensitive information.

## Step 1: Create .gitignore File

Create a `.gitignore` file to protect sensitive data:

```bash
cat > .gitignore << 'EOF'
# Sensitive files
secrets.yaml
*.pem
*.key

# AWS credentials
.aws/
aws-credentials*

# Environment files
.env
.env.local
.env.production

# Logs
*.log
logs/

# Temporary files
*.tmp
*.temp
.DS_Store
Thumbs.db

# IDE files
.vscode/
.idea/
*.swp
*.swo

# Node modules (if any)
node_modules/

# Python cache (if any)
__pycache__/
*.pyc
EOF
```

## Step 2: Initialize Git Repository

```bash
# Initialize git repository
git init

# Check what files will be tracked (secrets.yaml should NOT appear)
git status

# Add all files
git add .

# Make initial commit
git commit -m "Initial commit: easyTrade AWS deployment scripts and documentation"
```

## Step 3: Create Private GitHub Repository

### Option A: Using GitHub CLI (if available)
```bash
# Create private repository
gh repo create easytrade-demo --private --description "easyTrade Dynatrace demo application deployment scripts and documentation for AWS EC2"

# Push code
git push -u origin main
```

### Option B: Manual Creation
1. Go to https://github.com/new
2. Repository name: `easytrade-demo`
3. Set to **Private**
4. Don't initialize with README (you already have one)
5. Click "Create repository"

Then push your code:
```bash
# Add remote (replace YOUR_USERNAME with your GitHub username)
git remote add origin https://github.com/YOUR_USERNAME/easytrade-demo.git

# Push code
git branch -M main
git push -u origin main
```

## Verification

After pushing, verify that sensitive files are protected:

1. Check your GitHub repository - `secrets.yaml` should NOT be visible
2. Verify `.gitignore` is working: `git status` should not show ignored files
3. Confirm repository is private in GitHub settings

## Important Security Notes

- **Never commit secrets.yaml** - contains Dynatrace credentials
- **Never commit *.pem files** - contains SSH private keys
- **Always verify .gitignore** before first commit
- **Keep repository private** for security

## Future Updates

To update the repository:
```bash
git add .
git commit -m "Description of changes"
git push
```

The .gitignore will continue protecting sensitive files automatically.
