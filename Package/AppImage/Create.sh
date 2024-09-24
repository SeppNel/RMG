#!/usr/bin/env bash
set -ex

script_dir="$(dirname "$0")"
toplvl_dir="$(realpath "$script_dir/../../")"
bin_dir="$toplvl_dir/Bin/AppImage" # RMG should be installed here

export QMAKE="$(which qmake6)"
export EXTRA_QT_PLUGINS="imageformats;iconengines;"
export VERSION="$(git describe --tags --always)"
export OUTPUT="$bin_dir/../RMG-Portable-Linux64-$VERSION.AppImage"
export LD_LIBRARY_PATH="$toplvl_dir/Build/AppImage/Source/RMG-Core" # hack
export NO_STRIP=true

if [ ! -f "$script_dir/linuxdeploy-x86_64.AppImage" ]
then
    curl -L https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage \
        -o "$script_dir/linuxdeploy-x86_64.AppImage"
    chmod +x "$script_dir/linuxdeploy-x86_64.AppImage"
fi

if [ ! -f "$script_dir/linuxdeploy-plugin-qt-x86_64.AppImage" ]
then
    curl -L https://github.com/linuxdeploy/linuxdeploy-plugin-qt/releases/download/continuous/linuxdeploy-plugin-qt-x86_64.AppImage \
        -o "$script_dir/linuxdeploy-plugin-qt-x86_64.AppImage"
    chmod +x "$script_dir/linuxdeploy-plugin-qt-x86_64.AppImage"
fi

cp "$toplvl_dir/Package/AppImage/AppRun" "$bin_dir"

"$script_dir/linuxdeploy-x86_64.AppImage" --appdir "$bin_dir" --plugin qt --output appimage


rm "$script_dir/linuxdeploy-x86_64.AppImage" \
    "$script_dir/linuxdeploy-plugin-qt-x86_64.AppImage"