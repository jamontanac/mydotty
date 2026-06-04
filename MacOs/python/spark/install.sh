#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SPARK_VERSION="3.5.5"
SPARK_ARCHIVE="spark-${SPARK_VERSION}-bin-hadoop3"
SPARK_TGZ="$HOME/spark-${SPARK_VERSION}.tgz"
SPARK_HOME_DIR="$HOME/spark-${SPARK_VERSION}"
SPARK_DEFAULTS_SOURCE="$SCRIPT_DIR/spark-defaults.conf"
SPARK_DEFAULTS_TARGET="$SPARK_HOME_DIR/conf/spark-defaults.conf"

append_block_once() {
	local target_file="$1"
	local marker="$2"
	local block="$3"

	if ! grep -Fq "$marker" "$target_file" 2>/dev/null; then
		printf '\n%s\n' "$block" >> "$target_file"
	fi
}

echo "Installing java..."
brew install openjdk@17
sudo ln -sfn /opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-17.jdk

JAVA_BLOCK='# mydotty-java
export JAVA_HOME=/opt/homebrew/opt/openjdk@17
export PATH=/opt/homebrew/opt/openjdk@17:$PATH

# Locale
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8'

append_block_once "$HOME/.zshrc" "# mydotty-java" "$JAVA_BLOCK"
append_block_once "$HOME/.bash_profile" "# mydotty-java" "$JAVA_BLOCK"

echo "Java installed successfully."
java --version
echo "Downloading and installing Spark..."

curl -fL -o "$SPARK_TGZ" "https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/${SPARK_ARCHIVE}.tgz"
tar -xzf "$SPARK_TGZ" -C "$HOME"
rm -rf "$SPARK_HOME_DIR"
mv -f "$HOME/$SPARK_ARCHIVE" "$SPARK_HOME_DIR"
rm -f "$SPARK_TGZ"

SPARK_BLOCK="# mydotty-spark
export SPARK_HOME=$SPARK_HOME_DIR
export PATH=\$SPARK_HOME/bin:\$PATH"

append_block_once "$HOME/.zshrc" "# mydotty-spark" "$SPARK_BLOCK"
append_block_once "$HOME/.bash_profile" "# mydotty-spark" "$SPARK_BLOCK"

echo "Spark installed successfully."
spark-shell --version

echo "Moving the configuration files..."
cp -f "$SPARK_DEFAULTS_SOURCE" "$SPARK_DEFAULTS_TARGET"

echo "Configuration files moved successfully."
pyspark --version
echo "Reload your shell or run: source ~/.zshrc"