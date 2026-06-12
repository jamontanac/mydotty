#!/usr/bin/env bash
set -euo pipefail

# check if nvim is installed
if brew list onefetch &>/dev/null; then
    echo "onefetch already installed"
else
    echo "Installing onefetch..."
    brew install onefetch
fi
if brew list neovim &>/dev/null; then
    echo "neovim already installed"
else
    echo "Installing neovim..."
    brew install neovim
fi

if brew list node &>/dev/null; then
    echo "node already installed"
else
    echo "Installing node (includes npm)..."
    brew install node
fi

if brew list imagemagick &>/dev/null; then
    echo "imagemagick already installed"
else
    echo "Installing imagemagick..."
    brew install imagemagick
fi

if brew list librsvg &>/dev/null; then
    echo "librsvg already installed"
else
    echo "Installing librsvg (provides rsvg-convert)..."
    brew install librsvg
fi

if brew list utftex &>/dev/null; then
    echo "utftex already installed"
else
    echo "Installing utftex..."
    brew install utftex
fi

if command -v latex2text &>/dev/null; then
    echo "latex2text already installed"
else
    if ! command -v python3 &>/dev/null; then
        echo "python3 is required to install latex2text (pylatexenc)" >&2
        exit 1
    fi

    echo "Installing pylatexenc (provides latex2text)..."
    python3 -m pip install --user --upgrade pylatexenc

    if ! command -v latex2text &>/dev/null; then
        user_bin="$(python3 -m site --user-base)/bin"
        user_latex2text="${user_bin}/latex2text"

        if [[ -x "${user_latex2text}" ]]; then
            brew_bin="$(brew --prefix)/bin"
            if [[ -w "${brew_bin}" ]]; then
                ln -sf "${user_latex2text}" "${brew_bin}/latex2text"
                echo "Linked latex2text into ${brew_bin}"
            else
                echo "latex2text installed at ${user_latex2text}"
                echo "Add ${user_bin} to PATH if the command is not available in new shells"
            fi
        else
            echo "latex2text install failed: command not found" >&2
            exit 1
        fi
    fi
fi
