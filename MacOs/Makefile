
all: terminal-utils python-utils
# This Makefile is used to install the necessary dependencies for the Ghostty project on MacOS.
homebrew:
	@bash homebrew/install.sh
ghostty: homebrew
	@bash ghostty/install.sh
fonts: homebrew
	@bash fonts/install.sh
oh-my-zsh:
	@bash oh-my-zsh/install.sh
lazygit: homebrew
	@bash lazygit/install.sh
# Group target for terminal utilities
terminal-utils: ghostty fonts oh-my-zsh lazygit
	@echo "All terminal utilities have been installed."
pyenv: homebrew
	@bash python/pyenv/install.sh
spark: homebrew
	@bash python/spark/install.sh
python-utils: pyenv spark
	@echo "All Python utilities have been installed."
.PHONY: ghostty fonts oh-my-zsh lazygit terminal-utils pyenv spark homebrew python-utils