@echo "Installing java..."
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
' | tee -a ~/.zshrc ~/.bash_profile > /dev/null
echo "Java installed successfully."
echo $(java --version)
echo "Downloading and installing Spark..."

curl -o ~/spark-3.5.5.tgz https://archive.apache.org/dist/spark/spark-3.5.5/spark-3.5.5-bin-hadoop3.tgz
tar -xvzf ~/spark-3.5.5.tgz -C ~/ && mv spark-3.5.5-bin-hadoop3 spark-3.5.5 && rm spark-3.5.5.tgz
echo -e "
#Setting Spark Home
export SPARK_HOME=~/spark-3.5.5
export PATH=$SPARK_HOME/bin:$PATH
" | tee -a ~/.zshrc ~/.bash_profile > /dev/null
echo "Spark installed successfully."
echo $(spark-shell --version)

echo "Moving the configuration files..."
mv ./python/spark/spark.default.conf ~/spark-3.5.5/conf/spark-defaults.conf

echo "Configuration files moved successfully."
echo $(pyspark --version)