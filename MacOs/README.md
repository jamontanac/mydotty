```
███╗   ███╗ █████╗  ██████╗ ██████╗ ███████╗
████╗ ████║██╔══██╗██╔════╝██╔═══██╗██╔════╝
██╔████╔██║███████║██║     ██║   ██║███████╗
██║╚██╔╝██║██╔══██║██║     ██║   ██║╚════██║
██║ ╚═╝ ██║██║  ██║╚██████╗╚██████╔╝███████║
╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚══════╝
                                            
```

# Install terminal tooling
For installing the all the tooling you can simply run
```bash
make terminal-utils
```

this will install all the tools mentioned below.
## Specific details
### Xcode
Install Xcode commandline tools:

```bash
xcode-select --install
sudo xcodebuild -license accept
```

### Homebrew
Install [Homebrew](https://brew.sh/):

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

<details>
  <summary>🍺Things to consider in Homebrew.</summary>
Remember that not all the MAC have the arm architecture, some of them could have x86 architecture such as those based on Intel. This was already solved by the team of Homebrew but it is quite nice to take a look and learn a bit more how to make a difference of them both.
[here](https://github.com/orgs/Homebrew/discussions/3223) there is some information related with this issue.
</details>

### Oh-my-zsh
Install [oh-my-zsh](https://ohmyz.sh) this is personally one of my favourite frameworks to manage zsh configuration, it comes with bunch of helpers, functions, plugins and themes to customize the reminal as much as you want.

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Once installed it is time to take a look at the plugings that are available, I like to use the following ones:
```bash
plugins=(git dotenv ssh aws docker)
```
However I am a person who gets too into the terminal and i often lose track of time, how much time some command takes to run or if i am running out of battery. For taht reason i modified the `~/.zshrc` file to add some extra features that i like to have in my terminal.
First, i like to have a clock that shows me the time in the terminal, for that i added the following line to the `~/.zshrc` file and i developed 2 [plugins](./oh-my-zsh/plugins/) that i use to show the time of excecution and the battery level. You could take a look at them and configure them as you like.
At the end of the file you should have something like this:
```bash
plugins=(git dotenv ssh aws docker clock battery-pcr)
```

### Ghostty
When using a terminal i am always keen on using something that i could tweak as much as i would like. The main reason is because i spend almost all day in the terminal and the fact that i know it is fast and looks great produce me some kind of pleasure when working.
That is the case of [Ghostty](https://ghostty.org/) this terminal was developed by someone who is quite an interesting developper and has many properties that is suppose to replace many multiplexers that you can find out there.
To Download the Ghostty terminal go [here](https://ghostty.org/download) or run

```bash
brew install --cask ghostty
```

### Lazygit
Install lazy git, this is a program i came upon some time ago and since then i have been motivated to perform more complicated operations over my git projects. This is something i personally like.

```bash
brew install lazygit
```


## Fonts:
 When you search for fonts you could probably find over $10^8$ different options, some of them have [ligatures](https://en.wikipedia.org/wiki/Ligature_(writing)#:~:text=In%20writing%20and%20typography%2C%20a,joined%20for%20the%20second%20ligature.) and allows us to display some parts of the code with more style. At the end it does not really matter what font you use but how flexible it is to diplay different things in across programs. After some research i found that one of the best option to go with is a font that supports [glyphs](https://en.wikipedia.org/wiki/Glyph#:~:text=In%20typography%2C%20a%20glyph%20is,an%20element%20of%20written%20language.) and one of the best options is to go to a [NerdFont](https://www.nerdfonts.com/).
* __Setup__: [Download](https://www.nerdfonts.com/font-downloads) the '0xProto' Nerd Font, and then set it for the rest of the project. 
* Run the script to download the fonts

```bash
make fonts
```
here the script of install contains the name of the fonts to install, feel free to modify it and re run the `make`command.
# Python utils
To install python and spark you can run the following command
```bash
make python-utils
```
This will install the tools mentioned below.
## Details
### Pyenv
Install [pyenv](https://github.com/pyenv/pyenv), this allows to keep different versions of python and also allows to create virtual environments with different versions of python. This is something i personally like since it allows me to keep the system clean and also allows to have different versions of python for different projects.

```bash
brew install pyenv pyenv-virtualenv
```

check if pyenv is installed correctly
```bash
pyenv --version
```

And install a python verision of your choice, in this case i am going to install python 3.11 and set it as the local version of python
```bash
pyenv install 3.11
pyenv local 3.11
```

Also i like to use poetry as a package manager, however, i always encounter the issue of getting environemnts outside of the project folder, so after the installation of poetry i like to set the following configuration

```bash
pip install poetry
poetry config virtualenvs.in-project true
poetry install
```

This will create a `.venv` folder inside the project folder and all the packages will be installed there.

### UV
Recently i got into the package [uv](https://github.com/astral-sh/uv), which is a package manager made in rust that provides speed and flexibility to manage python versions as well as packages and project dependencies. It is like pyenv combined with poetry but with a better performance. 

```bash
### Spark:
In order to install spark to run distributed inference or perhaps managing a large amount of data in a local setup. You can install it using Homebrew or downloding directly java from the source. How ever, i do not suggest you install the latest version since spark does no runs well on every version of spark, in mi experience with the 17 version works fine and it still has a good support, so go for that, but in the future perhaps change to a newer one.

```bash
brew install openjdk@17
sudo ln -sfn /opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-17.jdk
echo -e '
# Java
export JAVA_HOME=/opt/homebrew/opt/openjdk@17
export PATH=/opt/homebrew/opt/openjdk@17:$PATH

# Adding locacl variables
# Locale
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
' >> ~/.zshrc
```

Download and unpack the spark binaries

```bash
curl -o ~/spark-3.5.5.tgz https://archive.apache.org/dist/spark/spark-3.5.5/spark-3.5.5-bin-hadoop3.tgz
tar -xvzf ~/spark-3.5.5.tgz -C ~/ && mv spark-3.5.5-bin-hadoop3 spark-3.5.5 && rm spark-3.5.5.tgz
echo -e "
#Setting Spark Home
export SPARK_HOME=~/spark-3.5.5
export PATH=$SPARK_HOME/bin:$PATH
" >> ~/.zshrc
```
Additionally we need to configure the spark defaults, for that we need to create the `spark-defaults.conf` Here i have an example of this file
<details>
<summary>⚙️ spark-defaults.conf</summary>

```bash
#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Default system properties included when running spark-submit.
# This is useful for setting default environmental settings.

# Example:
spark.master                              local[*]
spark.driver.host                         localhost
spark.driver.extraClassPath               $HOME/spark-3.5.5-bin-hadoop3/jars/*
spark.executor.extraClassPath             $HOME/spark-3.5.5-bin-hadoop3/jars/*
# spark.executor.extraJavaOptions         -Dcom.amazonaws.services.s3.enableV4=true
# spark.driver.extraJavaOptions           -Dcom.amazonaws.services.s3.enableV4=true
# spark.sql.catalogImplementation         hive
# spark.jars                              $HOME/spark-3.4.2-bin-hadoop3/jars/*

# Delta
#spark.jars.packages                       io.delta:delta-core_2.13:2.4.0
#spark.sql.extensions                      io.delta.sql.DeltaSparkSessionExtension
#spark.sql.catalog.spark_catalog           org.apache.spark.sql.delta.catalog.DeltaCatalog```
```

</details>

```bash
mv python/spark/spark-defaults.conf ~/spark-3.5.5/conf/spark-defaults.conf
```
now test if everything is working by running the following command
```bash
pyspark
```

it should display something like this

```bash
Type "help", "copyright", "credits" or "license" for more information.
Setting default log level to "WARN".
To adjust logging level use sc.setLogLevel(newLevel). For SparkR, use setLogLevel(newLevel).
WARN NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
Welcome to
      ____              __
     / __/__  ___ _____/ /__
    _\ \/ _ \/ _ `/ __/  '_/
   /__ / .__/\_,_/_/ /_/\_\   version 3.5.5
      /_/

Spark context Web UI available at http://localhost:4040
Spark context available as 'sc'
SparkSession available as 'spark'.
```

# Editors.

### VScode
This particular IDE supports a sync feature that allows you to sync your settings, extensions and keybindings across different machines by just signing in in your github/microsoft account. But from time to time I have experienced some issues with this feature, so I just simply leave the setting I like in to use in the [vscode folder](./vscode/).
Since i use a lot vim keybindings, take a look at the ``.vimrc`` file which is being used in these settings.


## VIM
I have some feelings about vim, i honestly love it but not the editor itself but everything that is behind it, the motions, the way of custoimise the keybindings. It is all about productivity but more over to know the tools you use daily. here i share my vimrc file with the mappings and plugins i use.

You can find it [here](./vim/.vimrc)

## Nvim
