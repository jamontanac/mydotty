PWSH ?= pwsh

.PHONY: all editors terminal nvim vim lazygit nvim-extras dev-links dev-links-status dev-links-unlink

all:
	@$(PWSH) -NoProfile -ExecutionPolicy Bypass -File ./install.ps1 -Target all

editors:
	@$(PWSH) -NoProfile -ExecutionPolicy Bypass -File ./install.ps1 -Target editors

terminal:
	@$(PWSH) -NoProfile -ExecutionPolicy Bypass -File ./install.ps1 -Target terminal

nvim:
	@$(PWSH) -NoProfile -ExecutionPolicy Bypass -File ./install.ps1 -Target nvim

vim:
	@$(PWSH) -NoProfile -ExecutionPolicy Bypass -File ./install.ps1 -Target vim

lazygit:
	@$(PWSH) -NoProfile -ExecutionPolicy Bypass -File ./install.ps1 -Target lazygit

nvim-extras:
	@$(PWSH) -NoProfile -ExecutionPolicy Bypass -File ./install.ps1 -Target nvim-extras

dev-links:
	@$(PWSH) -NoProfile -ExecutionPolicy Bypass -File ./install.ps1 -Target dev-links

dev-links-status:
	@$(PWSH) -NoProfile -ExecutionPolicy Bypass -File ./install.ps1 -Target dev-links-status

dev-links-unlink:
	@$(PWSH) -NoProfile -ExecutionPolicy Bypass -File ./install.ps1 -Target dev-links-unlink