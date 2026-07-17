
# This Makefile installs the tools and configuration managed by this repository.
all: terminal editors development python

# Package manager
homebrew:
	@bash homebrew/install.sh

# Terminal tools
ghostty lazygit: homebrew
	@bash $@/install.sh

fonts navigation-tools btop: homebrew
	@bash extras/$@/install.sh

oh-my-zsh: homebrew navigation-tools
	@bash oh-my-zsh/install.sh

terminal: ghostty oh-my-zsh lazygit navigation-tools btop fonts
	@echo "Terminal tools installed."

# Editors
nvim vscode: homebrew
	@bash $@/install.sh

vim: homebrew fonts navigation-tools dev-links
	@bash vim/install.sh

editors: vim nvim vscode
	@echo "Editors installed."

# Development toolchains
development: homebrew
	@bash development/install.sh

# Languages and data
pyenv spark uv pixi: homebrew
	@bash python/$@/install.sh

python: pyenv uv pixi
	@echo "Python tools installed."

data: spark
	@echo "Data tools installed."

# Development and desktop applications
docker: homebrew
	@bash docker/install.sh

containers: docker
	@echo "Container tools installed."

spotify: homebrew
	@bash spotify/install.sh

obsidian: homebrew
	@bash obsidian/install.sh

caffeine: homebrew
	@bash caffeine/install.sh

desktop: spotify obsidian caffeine
	@echo "Desktop applications installed."

# Hardware utilities
dygma: homebrew navigation-tools
	@bash Dygma/install.sh

hardware: dygma
	@echo "Hardware utilities installed."

# Backward-compatible group aliases
terminal-utils: terminal
extra-terminal-utils: fonts navigation-tools btop
python-utils: python

# Configuration links
dev-links:
	@bash dev-links/install.sh install

dev-links-status:
	@bash dev-links/install.sh status

dev-links-unlink:
	@bash dev-links/install.sh unlink

.PHONY: all homebrew \
	ghostty lazygit fonts navigation-tools btop oh-my-zsh terminal terminal-utils extra-terminal-utils \
	vim nvim vscode editors development \
	pyenv uv pixi spark python python-utils data \
	docker containers spotify obsidian caffeine desktop dygma hardware \
	dev-links dev-links-status dev-links-unlink
