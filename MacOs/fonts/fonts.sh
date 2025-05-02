#!/bin/bash
fonts_list=(
	font-0xproto-nerd-font
	font-caskaydia-cove-nerd-font
	font-caskaydia-mono-nerd-font
)
for font in "${fonts_list[@]}"
do
	echo "Installing" $font
	brew install --cask "$font"
	echo "--------------"
done
exit
