#!/usr/bin/env bash
set -euo pipefail

packages=(llvm node rustup)

for package in "${packages[@]}"; do
    if brew list "$package" &>/dev/null; then
        echo "$package already installed"
    else
        echo "Installing $package..."
        brew install "$package"
    fi
done

llvm_bin="$(brew --prefix llvm)/bin"
rustup_bin="$(brew --prefix rustup)/bin"
local_bin="$HOME/.local/bin"
mkdir -p "$local_bin"
ln -sfn "$llvm_bin/clang" "$local_bin/clang"
ln -sfn "$llvm_bin/clang++" "$local_bin/clang++"

if [[ ! -x "$rustup_bin/rustup" ]]; then
    echo "rustup was not installed correctly" >&2
    exit 1
fi

export PATH="$local_bin:$rustup_bin:$HOME/.cargo/bin:$PATH"

if ! rustup toolchain list | grep -q '^stable'; then
    echo "Installing the stable Rust toolchain..."
    rustup toolchain install stable
fi

rustup default stable

clang --version
npm --version
cargo --version
rustc --version

echo "Development tools installed. Ensure $local_bin, $rustup_bin, and $HOME/.cargo/bin are on PATH in new shells."