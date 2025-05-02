```
███╗   ███╗ █████╗  ██████╗ ██████╗ ███████╗
████╗ ████║██╔══██╗██╔════╝██╔═══██╗██╔════╝
██╔████╔██║███████║██║     ██║   ██║███████╗
██║╚██╔╝██║██╔══██║██║     ██║   ██║╚════██║
██║ ╚═╝ ██║██║  ██║╚██████╗╚██████╔╝███████║
╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚══════╝
                                            
```

# Install tooling
## Xcode
Install Xcode commandline tools:

```bash
xcode-select --install
sudo xcodebuild -license accept
```
## Homebrew
Install [Homebrew](https://brew.sh/):

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

<details>
  <summary>🍺Things to consider in Homebrew.</summary>
Remember that not all the MAC have the arm architecture, some of them could have x86 architecture such as those based on Intel. This was already solved by the team of Homebrew but it is quite nice to take a look and learn a bit more how to make a difference of them both.
[here](https://github.com/orgs/Homebrew/discussions/3223) there is some information related with this issue.
</details>

## Oh-my-zsh
Install [oh-my-zsh](https://ohmyz.sh) this is personally one of my favourite frameworks to manage zsh configuration, it comes with bunch of helpers, functions, plugins and themes to customize the reminal as much as you want.

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```
# Install conf files
## Fonts:

 When you search for fonts you could probably find over $10^8$ different options, some of them have [ligatures](https://en.wikipedia.org/wiki/Ligature_(writing)#:~:text=In%20writing%20and%20typography%2C%20a,joined%20for%20the%20second%20ligature.) and allows us to display some parts of the code with more style. At the end it does not really matter what font you use but how flexible it is to diplay different things in across programs. After some research i found that one of the best option to go with is a font that supports [glyphs](https://en.wikipedia.org/wiki/Glyph#:~:text=In%20typography%2C%20a%20glyph%20is,an%20element%20of%20written%20language.) and one of the best options is to go to a [NerdFont](https://www.nerdfonts.com/).
* __Setup__: [Download](https://www.nerdfonts.com/font-downloads) the '0xProto' Nerd Font, and then set it for the rest of the project. 
* Run the script to download the fonts
```bash
bash fonts/fonts.sh
```
## Lazygit
Install lazy git, this is a program i came upon some time ago and since then i have been motivated to perform more complicated operations over my git projects. This is something i personally like.
```
brew install lazygit
```
## Ghostty
When using a terminal i am always keen on using something that i could tweak as much as i would like. The main reason is because i spend almost all day in the terminal and the fact that i know it is fast and looks great produce me some kind of pleasure when working.
That is the case of [Ghostty](https://ghostty.org/) this terminal was developed by someone who is quite an interesting developper and has many properties that is suppose to replace many multiplexers that you can find out there.
To Download the Ghostty terminal go [here](https://ghostty.org/download)


