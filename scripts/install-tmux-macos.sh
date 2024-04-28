#!/bin/bash

# This script installs tmux on macOS with all possible features by installing dependencies,
# configuring, compiling, and installing tmux from the latest source.
# Usage:
#   ./install_tmux.sh [--help]

set -euo pipefail  # Enable strict mode for better error handling

# Function to display help information
help_message() {
    echo "Usage: ./install_tmux.sh [--help]"
    echo "Options:"
    echo "  --help    Display this help message and exit"
    echo "Description:"
    echo "  This script installs tmux on macOS with all possible features."
    echo "  It handles the installation of necessary dependencies via Homebrew,"
    echo "  clones the tmux repository, compiles tmux from source, and installs it."
}

# Check for help option
if [[ "${1:-}" == "--help" ]]; then
    help_message
    exit 0
fi

# Function to check if a command exists
command_exists() {
    command -v "$@" >/dev/null 2>&1
}

# Create a temporary directory
TMUX_DIR=$(mktemp -d)

# Print the path of the temporary directory
echo "Temporary directory created at: $TMUX_DIR"

# Set a trap to remove the temporary directory when the script exits
trap 'echo "Cleaning up..."; rm -rf $TMUX_DIR' EXIT

# Install Homebrew if not already installed
if ! command_exists /opt/homebrew/bin/brew; then
    echo "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Update Homebrew and install dependencies
echo "Updating Homebrew and installing dependencies..."
/opt/homebrew/bin/brew update
/opt/homebrew/bin/brew install libevent ncurses utf8proc autoconf automake pkg-config

# Check if git is installed
if ! command_exists git; then
    echo "Git is not installed. Installing Git..."
    /opt/homebrew/bin/brew install git
fi

# Clone the tmux repository
git -C "$TMUX_DIR" clone https://github.com/tmux/tmux.git "tmux"

# Set environment variables to use Homebrew paths
export PATH="/opt/homebrew/bin:$PATH"
export PKG_CONFIG_PATH="/usr/local/opt/libevent/lib/pkgconfig:/usr/local/opt/ncurses/lib/pkgconfig"
export LDFLAGS="-L/usr/local/opt/libevent/lib -L/usr/local/opt/ncurses/lib"
export CPPFLAGS="-I/usr/local/opt/libevent/include -I/usr/local/opt/ncurses/include"

# Generate configuration scripts and configure
echo "Configuring tmux build..."
( cd "$TMUX_DIR/tmux" && ./autogen.sh )
( cd "$TMUX_DIR/tmux" && ./configure --enable-utf8proc )

# Compile and install tmux
echo "Compiling and installing tmux..."
if make -C "$TMUX_DIR/tmux"; then
    echo "Compilation successful, installing tmux..."
    sudo make -C "$TMUX_DIR/tmux" install
    echo "tmux has been installed successfully!"
    tmux -V  # Display the installed version of tmux
else
    echo "Compilation failed."
    exit 1
fi
