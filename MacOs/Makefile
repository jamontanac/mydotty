
all: terminal-utils python-utils
# This Makefile is used to install the necessary dependencies for the Ghostty project on MacOS.
homebrew:
	@bash homebrew/install.sh
# Terminal utilities section
ghostty lazygit docker: homebrew
	@bash $@/install.sh
# Extra terminal utilities section
fonts navigation-tools btop: homebrew
	@bash extras/$@/install.sh 
oh-my-zsh:
	@bash oh-my-zsh/install.sh
# Group target for terminal utilities
terminal-utils: ghostty oh-my-zsh lazygit
	@echo "All terminal utilities have been installed."
extra-terminal-utils fonts navigation-tools:
	@echo "All extra terminal utilities have been installed."
# Python utilities section
pyenv spark uv: homebrew
	@bash python/$@/install.sh

python-utils: pyenv spark
	@echo "All Python utilities have been installed."
.PHONY: ghostty fonts oh-my-zsh lazygit docker terminal-utils pyenv spark uv homebrew python-utils