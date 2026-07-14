
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
oh-my-zsh: homebrew navigation-tools
	@bash oh-my-zsh/install.sh
vim: homebrew fonts navigation-tools dev-links
	@bash vim/install.sh
# Group target for terminal utilities
terminal-utils: ghostty oh-my-zsh lazygit navigation-tools
	@echo "All terminal utilities have been installed."
extra-terminal-utils: fonts navigation-tools
	@echo "All extra terminal utilities have been installed."
# Python utilities section
pyenv spark uv: homebrew
	@bash python/$@/install.sh

python-utils: pyenv spark uv
	@echo "All Python utilities have been installed."
dev-links:
	@bash dev-links/install.sh install

dev-links-status:
	@bash dev-links/install.sh status

dev-links-unlink:
	@bash dev-links/install.sh unlink

.PHONY: ghostty fonts oh-my-zsh lazygit docker terminal-utils pyenv spark uv homebrew python-utils vim dev-links dev-links-status dev-links-unlink
