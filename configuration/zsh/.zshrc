#
# .zshrc - Zsh Run Commands Configuration File
#
# This file is sourced by Zsh when it starts as an interactive shell. It is used
# to configure the behavior and appearance of the Zsh shell environment for each
# interactive shell session.
#
# The .zshrc file is a suitable place for configurations that are specific to
# interactive shell sessions, including:
# - Setting shell options and settings that affect the behavior of the shell.
# - Defining aliases and custom functions for use in interactive shell sessions.
# - Configuring the prompt settings to customize the appearance of the shell prompt.
# - Running initialization scripts or commands that need to be executed at shell startup.
#
# Note: Avoid adding configurations that are specific to non-interactive shell sessions
#       or login shell sessions to this file. Those should be added to .zshenv or
#       .zprofile files, respectively.
#

# Set CLICOLOR to enable colorized output for ls command
export CLICOLOR=1

# Set LSCOLORS to define the colors used by ls command for different file types
# and attributes. This represets the default configuration.
export LSCOLORS=GxFxCxDxBxegedabagaced

# Set EDITOR to specify the default text editor
export EDITOR=vim

# Configure the Zsh prompt (PS1) to display user@host:current_directory#
# - Username and hostname in bold green
# - Colon separator in bold
# - Current working directory in bold blue
# - Prompt symbol (# or $) in bold
# - Reset all colors and formatting at the end
declare -- PS1=$'%{\033[32;1m%}%n@%m%{\033[0;1m%}:%{\033[34;1m%}%/%{\033[0;1m%} %#%{\033[0m%} '

# Set the size of the command history (number of entries to keep)
declare -- HISTSIZE=10000

# Set the maximum number of history entries saved in the history file
declare -- SAVEHIST=10000

# Unbind the escape-/ binding to prevent interference with history search. This
# binding is added by compinit and can cause issues when performing history
# search with "/"
bindkey -r "^[/"

# Set vi as the keymap style for command line editing
set -o vi
