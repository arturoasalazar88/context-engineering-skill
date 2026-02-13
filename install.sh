#!/bin/bash
# Context Engineering Skill - Installation Script
# Installs all context engineering commands to your project
# Supports: Claude Code (more tools coming soon)

set -e

echo "=========================================="
echo "  Context Engineering Skill Installer"
echo "=========================================="
echo ""

# Determine skill location
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_NAME="context-engineering-skill"

if [ "$(basename "$SCRIPT_DIR")" != "$SKILL_NAME" ]; then
    echo "❌ Error: This script must be run from the context-engineering-skill/ directory"
    echo ""
    echo "Usage:"
    echo "  cd context-engineering-skill"
    echo "  ./install.sh"
    exit 1
fi

SKILL_PATH="$SCRIPT_DIR"

echo "Skill location: $SKILL_PATH"
echo ""

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
echo "=========================================="
echo ""

# Ask for target project path
read -p "Enter target project path (absolute or relative): " TARGET_PATH

# Expand ~ and resolve path
TARGET_PATH="${TARGET_PATH/#\~/$HOME}"
TARGET_PATH="$(cd "$TARGET_PATH" 2>/dev/null && pwd)" || {
    echo "❌ Error: Invalid path or directory does not exist: $TARGET_PATH"
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
# Future support - uncomment when ready
# elif [ -d "$TARGET_PATH/.cursor" ]; then
#     AGENT_TOOL="Cursor"
#     COMMANDS_DIR="$TARGET_PATH/.cursor/commands"
#     echo "✓ Detected: Cursor"
# elif [ -d "$TARGET_PATH/.aider" ]; then
#     AGENT_TOOL="Aider"
#     COMMANDS_DIR="$TARGET_PATH/.aider/commands"
#     echo "✓ Detected: Aider"
else
    echo "⚠️  No agent tool detected in target project"
    echo ""
    echo "Supported tools:"
    echo "  - Claude Code (.claude/commands/)"
    echo "  - More coming soon..."
    echo ""
    read -p "Install for Claude Code? (y/n) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Installation cancelled."
        exit 0
    fi
    AGENT_TOOL="Claude Code"
    COMMANDS_DIR="$TARGET_PATH/.claude/commands"
fi

echo "Install location: $COMMANDS_DIR"
echo ""

# Verify this is not the skill's own directory
if [ "$TARGET_PATH" = "$SKILL_PATH" ]; then
    echo "❌ Error: Cannot install into the skill's own directory"
    echo "Please specify a different project path."
    exit 1
fi

# Create commands directory if needed
if [ ! -d "$COMMANDS_DIR" ]; then
    echo "Creating $COMMANDS_DIR..."
    mkdir -p "$COMMANDS_DIR"
    echo "✓ Directory created"
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
    echo "⚠️  Warning: Found ${#EXISTING[@]} existing command(s):"
    for cmd in "${EXISTING[@]}"; do
        echo "  - $cmd"
    done
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

# Copy skill directory to target if not already there
SKILL_TARGET="$TARGET_PATH/$SKILL_NAME"

if [ "$SKILL_PATH" != "$SKILL_TARGET" ]; then
    if [ ! -d "$SKILL_TARGET" ]; then
        echo "Copying skill files to project..."
        if cp -r "$SKILL_PATH" "$TARGET_PATH/"; then
            echo "✓ Skill files copied to: $SKILL_TARGET"
        else
            echo "⚠️  Warning: Could not copy skill files"
            echo "   Commands will work, but templates may not be accessible"
        fi
        echo ""
    else
        echo "✓ Skill files already present in project"
        echo ""
    fi
fi

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
    echo "Installed to: $TARGET_PATH"
    echo "Agent tool:   $AGENT_TOOL"
    echo "Commands:     $INSTALLED installed"
    echo ""
    echo "Available commands:"
    echo "  /context-init      - Initialize project structure"
    echo "  /context-ingest    - Add new context intelligently"
    echo "  /context-start     - Start session with context loading"
    echo "  /context-refactor  - Audit and refactor implementation"
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
    echo "  4. Every session:"
    echo "     /context-start"
    echo ""
    echo "Documentation: $SKILL_TARGET/README.md"
    echo ""
fi
