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

## Ghostty
When using a terminal i am always keen on using something that i could tweak as much as i would like. The main reason is because i spend almost all day in the terminal and the fact that i know it is fast and looks great produce me some kind of pleasure when working.
That is the case of [Ghostty](https://ghostty.org/) this terminal was developed by someone who is quite an interesting developper and has many properties that is suppose to replace many multiplexers that you can find out there.
To Download the Ghostty terminal go [here](https://ghostty.org/download) or run

```bash
brew install --cask ghostty
```

## Lazygit
Install lazy git, this is a program i came upon some time ago and since then i have been motivated to perform more complicated operations over my git projects. This is something i personally like.

```bash
brew install lazygit
```
# Python & Spark
## Spark:
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


# Styling with conf files
## Fonts:
 When you search for fonts you could probably find over $10^8$ different options, some of them have [ligatures](https://en.wikipedia.org/wiki/Ligature_(writing)#:~:text=In%20writing%20and%20typography%2C%20a,joined%20for%20the%20second%20ligature.) and allows us to display some parts of the code with more style. At the end it does not really matter what font you use but how flexible it is to diplay different things in across programs. After some research i found that one of the best option to go with is a font that supports [glyphs](https://en.wikipedia.org/wiki/Glyph#:~:text=In%20typography%2C%20a%20glyph%20is,an%20element%20of%20written%20language.) and one of the best options is to go to a [NerdFont](https://www.nerdfonts.com/).
* __Setup__: [Download](https://www.nerdfonts.com/font-downloads) the '0xProto' Nerd Font, and then set it for the rest of the project. 
* Run the script to download the fonts
```bash
bash fonts/fonts.sh
```



