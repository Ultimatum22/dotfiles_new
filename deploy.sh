#!/usr/bin/env zsh

set -e

# Get the current path
SCRIPT_DIR="${0:A:h}"
cd "${SCRIPT_DIR}"

# Default XDG paths
XDG_CACHE_HOME="${HOME}/.cache"
XDG_CONFIG_HOME="${HOME}/.config"
XDG_DATA_HOME="${HOME}/.local/share"
XDG_STATE_HOME="${HOME}/.local/state"

# Create required directories
print "Creating required directories..."
mkdir -p "${XDG_CONFIG_HOME}"/{git/local,mc,htop,tig,gnupg,nvim}
mkdir -p "${XDG_CACHE_HOME}"/{vim/{backup,swap,undo},zsh,tig}
mkdir -p "${XDG_DATA_HOME}"/{{goenv,jenv,luaenv,nodenv,phpenv,plenv,pyenv,rbenv}/plugins,zsh,man/man1,vim/spell,nvim/site/pack/plugins}
mkdir -p "${XDG_STATE_HOME}"
mkdir -p "${HOME}"/.local/{bin,etc}
chmod 700 "${XDG_CONFIG_HOME}/gnupg"
print "  ...done"

# Link zshenv if needed
print "Checking for ZDOTDIR env variable..."
if [[ "${ZDOTDIR}" = "${SCRIPT_DIR}/zsh" ]]; then
    print "  ...present and valid, skipping .zshenv symlink"
else
    ln -sf "${SCRIPT_DIR}/zsh/.zshenv" "${ZDOTDIR:-${HOME}}/.zshenv"
    print "  ...failed to match this script dir, symlinking .zshenv"
fi

# Make sure submodules are installed
print "Syncing submodules..."
git submodule sync > /dev/null
git submodule update --init --recursive > /dev/null
git clean -ffd
print "  ...done"

# Make install git-extras
print "Installing git-extras..."
pushd tools/git-extras
PREFIX="${HOME}/.local" make install > /dev/null
popd
print "  ...done"

print "Installing git-quick-stats..."
pushd tools/git-quick-stats
PREFIX="${HOME}/.local" make install > /dev/null
popd
print "  ...done"

print "Installing fzf..."
pushd tools/fzf
if ./install --bin > /dev/null; then
    ln -sf "${SCRIPT_DIR}/tools/fzf/bin/fzf" "${HOME}/.local/bin/fzf"
    ln -sf "${SCRIPT_DIR}/tools/fzf/bin/fzf-tmux" "${HOME}/.local/bin/fzf-tmux"
    ln -sf "${SCRIPT_DIR}/tools/fzf/man/man1/fzf.1" "${XDG_DATA_HOME}/man/man1/fzf.1"
    ln -sf "${SCRIPT_DIR}/tools/fzf/man/man1/fzf-tmux.1" "${XDG_DATA_HOME}/man/man1/fzf-tmux.1"
    print "  ...done"
else
    print "  ...failed. Probably unsupported architecture, please check fzf installation guide"
fi
popd

# Download/refresh TLDR pages
print "Downloading TLDR pages..."
${SCRIPT_DIR}/tools/tldr-bash-client/tldr -u > /dev/null
print "  ...done"
