```
███╗   ███╗██╗   ██╗    ██████╗  ██████╗ ████████╗    ███████╗██╗██╗     ███████╗███████╗
████╗ ████║╚██╗ ██╔╝    ██╔══██╗██╔═══██╗╚══██╔══╝    ██╔════╝██║██║     ██╔════╝██╔════╝
██╔████╔██║ ╚████╔╝     ██║  ██║██║   ██║   ██║       █████╗  ██║██║     █████╗  ███████╗
██║╚██╔╝██║  ╚██╔╝      ██║  ██║██║   ██║   ██║       ██╔══╝  ██║██║     ██╔══╝  ╚════██║
██║ ╚═╝ ██║   ██║       ██████╔╝╚██████╔╝   ██║       ██║     ██║███████╗███████╗███████║
╚═╝     ╚═╝   ╚═╝       ╚═════╝  ╚═════╝    ╚═╝       ╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝
                                                                                         
```
                                                                                         
This project repository was created with the end of replicate my own environemnt across servers and other machines. I constantly strugglued with the fact that either from work or from my personal laptops i did not have the same setup and everytime i was changing something in one machine it did not replicated across my other setups.
## Setting up my own environment

The purpose of this documentation is to document every step needed to recreate the whole environment for development.

### For Mac OS

1. __Fonts__: When you search for fonts you could probably find over $10^8$ different options, some of them have [ligatures](https://en.wikipedia.org/wiki/Ligature_(writing)#:~:text=In%20writing%20and%20typography%2C%20a,joined%20for%20the%20second%20ligature.) and allows us to display some parts of the code with more styleat the end it does not really matter what font you use but how flexible it is to diplay different things in different programs. After some research i found that one of the best option to go with is a font that supports [glyphs](https://en.wikipedia.org/wiki/Glyph#:~:text=In%20typography%2C%20a%20glyph%20is,an%20element%20of%20written%20language.) and one of the best options is to go to a [NerdFont](https://www.nerdfonts.com/).
__Setup__:
*  [Download](https://www.nerdfonts.com/font-downloads) the '0xProto' Nerd Font, and then set it for the rest of the project. 
* Run the script to download the fonts
```bash
bash fonts/fonts.sh
```
2. Install Xcode in the Mac if it is new, you can simply install it by trying to run “git” command and the suggestion of installing it will pop up. Alternatively you can  run
xcode-select --install
sudo xcodebuild -license accept 
3. Install home brew  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" 
4. Install lazy git.    brew install lazygit  
5. Download home brew 
6. Download the Ghostty terminal, this emulator helps with performance, easy configuration and supports many other interesting features. https://ghostty.org/download

```
	     _________
	    / ======= \
	   / __________\
	  | ___________ |
	  | | -       | |
	  | |         | |
	  | |_________| |________________________
	  \=____________/   Jose A. Montana C.   )
	  / """"""""""" \                       /
	 / ::::::::::::: \                  =D-'
	(_________________)
```
