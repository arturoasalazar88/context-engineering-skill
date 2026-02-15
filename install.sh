#!/bin/bash
# Context Engineering Skill - Installation & Update Script
# Installs or updates context engineering commands in your project
# Supports: Claude Code (more tools coming soon)

set -e

echo "=========================================="
echo "  Context Engineering Skill"
echo "=========================================="
echo ""

# Determine skill location
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ "$(basename "$SCRIPT_DIR")" != "context-engineering-skill" ]; then
    echo "❌ Error: This script must be run from the context-engineering-skill/ directory"
    echo ""
    echo "Usage:"
    echo "  cd context-engineering-skill"
    echo "  ./install.sh"
    exit 1
fi

SKILL_PATH="$SCRIPT_DIR"

# Pull latest if this is a git repo
if [ -d "$SKILL_PATH/.git" ]; then
    echo "Pulling latest changes..."
    if git -C "$SKILL_PATH" pull origin main 2>/dev/null; then
        echo "✓ Updated to latest version"
    else
        echo "⚠️  Could not pull latest (no network?). Using local version."
    fi
    echo ""
fi

# Verify skill structure
if [ ! -d "$SKILL_PATH/commands" ]; then
    echo "❌ Error: commands/ directory not found"
    exit 1
fi

COMMAND_COUNT=$(ls -1 "$SKILL_PATH/commands"/*.md 2>/dev/null | wc -l | tr -d ' ')

if [ "$COMMAND_COUNT" -eq 0 ]; then
    echo "❌ Error: No command files found in commands/"
    exit 1
fi

echo "Found $COMMAND_COUNT command(s):"
for cmd in "$SKILL_PATH/commands"/*.md; do
    echo "  - $(basename "$cmd")"
done
echo ""

# Check for available bug fixes
if [ -d "$SKILL_PATH/docs/bugs" ]; then
    BUG_COUNT=$(ls -1 "$SKILL_PATH/docs/bugs"/*.md 2>/dev/null | wc -l | tr -d ' ')
    if [ "$BUG_COUNT" -gt 0 ]; then
        echo "Bug fixes available: $BUG_COUNT"
        for bug in "$SKILL_PATH/docs/bugs"/*.md; do
            bug_name=$(basename "$bug" .md)
            echo "  - $bug_name"
        done
        echo ""
    fi
fi

echo "=========================================="
echo ""

# Ask what to do
echo "What would you like to do?"
echo ""
echo "  1) Install - Fresh install to a new project"
echo "  2) Update  - Update an existing installation"
echo ""
read -p "Choose (1/2): " CHOICE

case "$CHOICE" in
    1) MODE="install" ;;
    2) MODE="update" ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac

echo ""

# Ask for target project path
read -p "Enter target project path: " TARGET_PATH

# Expand ~ and resolve path
TARGET_PATH="${TARGET_PATH/#\~/$HOME}"
TARGET_PATH="$(cd "$TARGET_PATH" 2>/dev/null && pwd)" || {
    echo "❌ Error: Invalid path or directory does not exist."
    exit 1
}

echo ""
echo "Target project: $TARGET_PATH"
echo ""

# Detect agent tool
AGENT_TOOL=""
COMMANDS_DIR=""

if [ -d "$TARGET_PATH/.claude" ]; then
    AGENT_TOOL="Claude Code"
    COMMANDS_DIR="$TARGET_PATH/.claude/commands"
    echo "✓ Detected: Claude Code"
else
    if [ "$MODE" = "update" ]; then
        echo "❌ Error: No context engineering detected in this project."
        echo "Run again and choose Install instead."
        exit 1
    fi
    echo "No agent tool detected. Setting up for Claude Code."
    AGENT_TOOL="Claude Code"
    COMMANDS_DIR="$TARGET_PATH/.claude/commands"
fi

echo ""

# ============================================================
# UPDATE MODE
# ============================================================
if [ "$MODE" = "update" ]; then
    echo "=========================================="
    echo "  Updating..."
    echo "=========================================="
    echo ""

    # Verify commands directory exists
    if [ ! -d "$COMMANDS_DIR" ]; then
        echo "❌ Error: Commands directory not found at $COMMANDS_DIR"
        echo "Run again and choose Install instead."
        exit 1
    fi

    # Create backup
    BACKUP_DIR="$TARGET_PATH/.claude/backup/$(date +%Y-%m-%d-%H%M%S)"
    echo "Creating backup: $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR/commands"

    # Backup existing commands
    for cmd in "$COMMANDS_DIR"/*.md; do
        if [ -f "$cmd" ]; then
            cp "$cmd" "$BACKUP_DIR/commands/"
        fi
    done

    # Backup rules if they exist
    if [ -d "$TARGET_PATH/.claude/rules" ]; then
        mkdir -p "$BACKUP_DIR/rules"
        for rule in "$TARGET_PATH/.claude/rules"/*.md; do
            if [ -f "$rule" ]; then
                cp "$rule" "$BACKUP_DIR/rules/"
            fi
        done
    fi

    # Backup schema if it exists
    if [ -f "$TARGET_PATH/context/CONTEXT-SCHEMA.yaml" ]; then
        mkdir -p "$BACKUP_DIR/context"
        cp "$TARGET_PATH/context/CONTEXT-SCHEMA.yaml" "$BACKUP_DIR/context/"
    fi

    echo "✓ Backup created"
    echo ""

    # Update commands (always safe - no project-specific content)
    echo "Updating commands..."
    UPDATED=0
    ADDED=0
    UNCHANGED=0

    for cmd in "$SKILL_PATH/commands"/*.md; do
        cmd_name=$(basename "$cmd")
        target_file="$COMMANDS_DIR/$cmd_name"

        if [ ! -f "$target_file" ]; then
            cp "$cmd" "$COMMANDS_DIR/"
            echo "  + $cmd_name (new)"
            ((ADDED++))
        elif ! diff -q "$cmd" "$target_file" > /dev/null 2>&1; then
            cp "$cmd" "$COMMANDS_DIR/"
            echo "  ~ $cmd_name (updated)"
            ((UPDATED++))
        else
            echo "  = $cmd_name (current)"
            ((UNCHANGED++))
        fi
    done

    echo ""

    # Report
    echo "=========================================="
    echo "  ✅ Update Complete!"
    echo "=========================================="
    echo ""
    echo "Commands: $ADDED new, $UPDATED updated, $UNCHANGED unchanged"
    echo "Backup:   $BACKUP_DIR"
    echo ""
    echo "Next steps:"
    echo ""
    echo "  1. Restart $AGENT_TOOL (if running)"
    echo ""
    echo "  2. Apply bug fixes to rules & schema:"
    echo "     /context-update --check"
    echo "     /context-update --apply"
    echo ""
    echo "  3. Reload session:"
    echo "     /context-start"
    echo ""
    exit 0
fi

# ============================================================
# INSTALL MODE
# ============================================================

# Create commands directory if needed
if [ ! -d "$COMMANDS_DIR" ]; then
    mkdir -p "$COMMANDS_DIR"
    echo "✓ Created $COMMANDS_DIR"
    echo ""
fi

# Check for existing installations
EXISTING=()
for cmd in "$SKILL_PATH/commands"/*.md; do
    cmd_name=$(basename "$cmd")
    if [ -f "$COMMANDS_DIR/$cmd_name" ]; then
        EXISTING+=("$cmd_name")
    fi
done

if [ ${#EXISTING[@]} -gt 0 ]; then
    echo "⚠️  Found ${#EXISTING[@]} existing command(s):"
    for cmd in "${EXISTING[@]}"; do
        echo "  - $cmd"
    done
    echo ""
    echo "Tip: Choose Update next time for safer updates with backup."
    echo ""
    read -p "Overwrite? (y/n) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Installation cancelled."
        exit 0
    fi
    echo ""
fi

# Install commands
echo "Installing commands..."
INSTALLED=0
FAILED=0

for cmd in "$SKILL_PATH/commands"/*.md; do
    cmd_name=$(basename "$cmd")
    if cp "$cmd" "$COMMANDS_DIR/"; then
        echo "  ✓ $cmd_name"
        ((INSTALLED++))
    else
        echo "  ✗ $cmd_name (failed)"
        ((FAILED++))
    fi
done

echo ""

# Report results
if [ $FAILED -gt 0 ]; then
    echo "⚠️  Installation completed with errors:"
    echo "  Installed: $INSTALLED"
    echo "  Failed:    $FAILED"
    exit 1
else
    echo "=========================================="
    echo "  ✅ Installation Successful!"
    echo "=========================================="
    echo ""
    echo "Commands: $INSTALLED installed"
    echo ""
    echo "Available commands:"
    echo "  /context-init      - Initialize project structure"
    echo "  /context-ingest    - Add new context intelligently"
    echo "  /context-start     - Start session with context loading"
    echo "  /context-refactor  - Audit and refactor implementation"
    echo "  /context-update    - Apply bug fixes and updates"
    echo "  /context-close     - Close session with compliance checks"
    echo ""
    echo "Next steps:"
    echo ""
    echo "  1. Restart $AGENT_TOOL (if already running)"
    echo ""
    echo "  2. NEW project? Run:"
    echo "     /context-init"
    echo ""
    echo "  3. EXISTING context engineering? Run:"
    echo "     /context-refactor"
    echo ""
    echo "  4. Every session start:"
    echo "     /context-start"
    echo ""
    echo "  5. Every session end:"
    echo "     /context-close"
    echo ""
fi
