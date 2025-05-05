
all: terminal-utils python-utils
# This Makefile is used to install the necessary dependencies for the Ghostty project on MacOS.
homebrew:
	@bash homebrew/install.sh
# Terminal utilities section
ghostty fonts lazygit: homebrew
	@bash $@/install.sh
oh-my-zsh:
	@bash oh-my-zsh/install.sh
# Group target for terminal utilities
terminal-utils: ghostty fonts oh-my-zsh lazygit
	@echo "All terminal utilities have been installed."
# Python utilities section
pyenv spark: homebrew
	@bash python/$@/install.sh

python-utils: pyenv spark
	@echo "All Python utilities have been installed."
.PHONY: ghostty fonts oh-my-zsh lazygit terminal-utils pyenv spark homebrew python-utils