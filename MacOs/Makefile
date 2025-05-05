
all: terminal-utils
# This Makefile is used to install the necessary dependencies for the Ghostty project on MacOS.
ghostty:
	@bash ghostty/install.sh
fonts:
	@bash fonts/install.sh
oh-my-zsh:
	@bash oh-my-zsh/install.sh
lazygit:
	@bash lazygit/install.sh
# Group target for terminal utilities
terminal-utils: ghostty fonts oh-my-zsh lazygit
	@echo "All terminal utilities have been installed."
pyenv:
	@bash python/pyenv/install.sh
spark:
	@bash python/spark/install.sh
.PHONY: ghostty fonts oh-my-zsh lazygit terminal-utils pyenv spark