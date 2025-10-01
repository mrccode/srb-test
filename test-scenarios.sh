#!/bin/bash

# Test Scenarios for Semantic Release
# This script helps you test different semantic-release scenarios

set -e

echo "==================================="
echo "Semantic Release Test Scenarios"
echo "==================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print section headers
print_header() {
    echo ""
    echo -e "${BLUE}===================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}===================================${NC}"
    echo ""
}

# Function to print instructions
print_instruction() {
    echo -e "${YELLOW}$1${NC}"
}

# Function to print success
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "Error: Not in a git repository. Please run 'git init' first."
    exit 1
fi

# Menu
echo "Choose a test scenario:"
echo ""
echo "1) Patch Release (fix) - Main branch"
echo "2) Minor Release (feat) - Main branch"
echo "3) Major Release (BREAKING CHANGE) - Main branch"
echo "4) Alpha Pre-release - Alpha branch"
echo "5) Next Pre-release - Next branch"
echo "6) Reset to initial state"
echo ""
read -p "Enter your choice (1-6): " choice

# Strip escape sequences and whitespace
choice=$(echo "$choice" | tr -d '[:space:]' | sed 's/\x1b\[[0-9;]*[a-zA-Z]//g' | grep -o '[0-9]' | head -1)

case $choice in
    1)
        print_header "Scenario 1: Patch Release (fix)"
        print_instruction "This will create a fix commit for a patch release (e.g., 1.0.0 -> 1.0.1)"
        echo ""
        git checkout -B main 2>/dev/null || git checkout main
        echo "// Bug fix" >> src/index.ts
        git add .
        git commit -m "fix: resolve division precision issue"
        print_success "Created fix commit"
        echo ""
        print_instruction "Pushing to remote..."
        git push origin main
        print_success "Pushed to remote"
        ;;

    2)
        print_header "Scenario 2: Minor Release (feat)"
        print_instruction "This will create a feature commit for a minor release (e.g., 1.0.0 -> 1.1.0)"
        echo ""
        git checkout -B main 2>/dev/null || git checkout main
        echo "// New feature" >> src/index.ts
        git add .
        git commit -m "feat: add modulo operation to calculator"
        print_success "Created feature commit"
        echo ""
        print_instruction "Pushing to remote..."
        git push origin main
        print_success "Pushed to remote"
        ;;

    3)
        print_header "Scenario 3: Major Release (BREAKING CHANGE)"
        print_instruction "This will create a breaking change commit for a major release (e.g., 1.0.0 -> 2.0.0)"
        echo ""
        git checkout -B main 2>/dev/null || git checkout main
        echo "// Breaking change" >> src/index.ts
        git add .
        git commit -m "feat: redesign calculator API

BREAKING CHANGE: Calculator methods now return objects instead of numbers"
        print_success "Created breaking change commit"
        echo ""
        print_instruction "Pushing to remote..."
        git push origin main
        print_success "Pushed to remote"
        ;;

    4)
        print_header "Scenario 4: Alpha Pre-release"
        print_instruction "This will create an alpha branch commit for a pre-release (e.g., 1.1.0-alpha.1)"
        echo ""
        git checkout -B alpha
        echo "// Alpha feature" >> src/index.ts
        git add .
        git commit -m "feat: add experimental power function"
        print_success "Created alpha feature commit"
        echo ""
        print_instruction "Pushing to remote..."
        git push origin alpha
        print_success "Pushed to remote"
        ;;

    5)
        print_header "Scenario 5: Next Pre-release"
        print_instruction "This will create a next branch commit for a pre-release (e.g., 1.1.0-next.1)"
        echo ""
        git checkout -B next
        echo "// Next feature" >> src/index.ts
        git add .
        git commit -m "feat: add square root function"
        print_success "Created next feature commit"
        echo ""
        print_instruction "Pushing to remote..."
        git push origin next
        print_success "Pushed to remote"
        ;;

    6)
        print_header "Scenario 6: Reset to Initial State"
        print_instruction "This will reset the repository to a clean initial commit"
        echo ""
        read -p "Are you sure you want to reset? This will remove all test commits. (y/N): " confirm
        # Strip escape sequences and whitespace
        confirm=$(echo "$confirm" | tr -d '[:space:]' | sed 's/\x1b\[[0-9;]*[a-zA-Z]//g')
        if [[ $confirm == [yY] ]]; then
            git checkout -B main
            git reset --hard HEAD~10 2>/dev/null || true
            # Create initial commit if needed
            if ! git rev-parse HEAD >/dev/null 2>&1; then
                git add .
                git commit -m "chore: initial commit" --allow-empty
            fi
            print_success "Repository reset to initial state"
        else
            echo "Reset cancelled"
        fi
        ;;

    *)
        echo "Invalid choice. Please run the script again and choose 1-6."
        exit 1
        ;;
esac

echo ""
print_success "Test scenario prepared!"
echo ""
print_instruction "Commit has been pushed to remote. GitHub Actions will automatically run semantic-release."
print_instruction "To see what commits were created, run: git log --oneline"
print_instruction "To monitor the GitHub Action: https://github.com/mrccode/srb-test/actions"
print_instruction "To see releases after completion: https://github.com/mrccode/srb-test/releases"
echo ""
