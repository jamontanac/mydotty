```
███╗   ███╗ █████╗  ██████╗ ██████╗ ███████╗
████╗ ████║██╔══██╗██╔════╝██╔═══██╗██╔════╝
██╔████╔██║███████║██║     ██║   ██║███████╗
██║╚██╔╝██║██╔══██║██║     ██║   ██║╚════██║
██║ ╚═╝ ██║██║  ██║╚██████╗╚██████╔╝███████║
╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚══════╝
                                            
```

### Install tooling

Install Xcode commandline tools:

```bash
xcode-select --install
sudo xcodebuild -license accept
```

Install [Homebrew](https://brew.sh/):

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

<details>
  <summary>🍺Things to consider in Homebrew.</summary>
Remember that not all the MAC have the arm architecture, some of them could have x86 architecture such as those based on Intel. This was already solved by the team of Homebrew but it is quite nice to take a look and learn a bit more how to make a difference of them both.
[here](https://github.com/orgs/Homebrew/discussions/3223) there is some information related with this issue.
</details>

### Installing conf files
#### Fonts:

 When you search for fonts you could probably find over $10^8$ different options, some of them have [ligatures](https://en.wikipedia.org/wiki/Ligature_(writing)#:~:text=In%20writing%20and%20typography%2C%20a,joined%20for%20the%20second%20ligature.) and allows us to display some parts of the code with more style. At the end it does not really matter what font you use but how flexible it is to diplay different things in across programs. After some research i found that one of the best option to go with is a font that supports [glyphs](https://en.wikipedia.org/wiki/Glyph#:~:text=In%20typography%2C%20a%20glyph%20is,an%20element%20of%20written%20language.) and one of the best options is to go to a [NerdFont](https://www.nerdfonts.com/).
* __Setup__:[Download](https://www.nerdfonts.com/font-downloads) the '0xProto' Nerd Font, and then set it for the rest of the project. 
* Run the script to download the fonts
```bash
bash fonts/fonts.sh
```
Install lazy git, this is a program i came upon some time ago and since then i have been motivated to perform more complicated operations over my git projects. This is something i personally like.
```
brew install lazygit  
```
Download the Ghostty terminal, this emulator helps with performance, easy configuration and supports many other interesting features. https://ghostty.org/download
