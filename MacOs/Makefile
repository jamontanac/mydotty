
all: ghostty fonts oh-my-zsh
# This Makefile is used to install the necessary dependencies for the Ghostty project on MacOS.
ghostty:
	@bash ghostty/install.sh
fonts: ghostty
	@bash fonts/install.sh
oh-my-zsh: ghostty
	@bash oh-my-zsh/install.sh
.PHONY: ghostty fonts oh-my-zsh