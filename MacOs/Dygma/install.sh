#!/usr/bin/env bash
set -euo pipefail

REPOSITORY="Dygmalab/Bazecor"
API_URL="https://api.github.com/repos/$REPOSITORY/releases/latest"
APPLICATION_PATH="/Applications/Bazecor.app"

case "$(uname -m)" in
    arm64)
        asset_suffix="arm64.dmg"
        ;;
    x86_64)
        asset_suffix="x64.dmg"
        ;;
    *)
        echo "Unsupported macOS architecture: $(uname -m)" >&2
        exit 1
        ;;
esac

release_json="$(curl -fsSL "$API_URL")"
release_tag="$(jq -r '.tag_name' <<<"$release_json")"
release_version="${release_tag#v}"
download_url="$(jq -r --arg suffix "$asset_suffix" '
    .assets[] | select(.name | endswith($suffix)) | .browser_download_url
' <<<"$release_json" | head -n 1)"

if [[ -z "$download_url" || "$download_url" == "null" ]]; then
    echo "No Bazecor macOS installer found for $asset_suffix in release $release_tag" >&2
    exit 1
fi

if [[ -d "$APPLICATION_PATH" ]]; then
    installed_version="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$APPLICATION_PATH/Contents/Info.plist" 2>/dev/null || true)"
    if [[ "$installed_version" == "$release_version" ]]; then
        echo "Bazecor $release_version is already installed."
        exit 0
    fi

    echo "Updating Bazecor from ${installed_version:-unknown} to $release_version..."
fi

temp_dir="$(mktemp -d)"
dmg_path="$temp_dir/Bazecor.dmg"
mount_dir="$temp_dir/mount"

cleanup() {
    if [[ -d "$mount_dir" ]]; then
        hdiutil detach "$mount_dir" -quiet || true
    fi
    rm -rf "$temp_dir"
}
trap cleanup EXIT

echo "Downloading Bazecor $release_tag..."
curl -fL "$download_url" -o "$dmg_path"
mkdir -p "$mount_dir"
hdiutil attach "$dmg_path" -nobrowse -readonly -mountpoint "$mount_dir" -quiet

app_path="$(find "$mount_dir" -maxdepth 2 -type d -name 'Bazecor.app' -print -quit)"
if [[ -z "$app_path" ]]; then
    echo "Bazecor.app was not found in the downloaded installer." >&2
    exit 1
fi

echo "Installing Bazecor $release_tag..."
rm -rf "$APPLICATION_PATH"
ditto "$app_path" "$APPLICATION_PATH"
echo "Bazecor $release_tag installed at $APPLICATION_PATH"