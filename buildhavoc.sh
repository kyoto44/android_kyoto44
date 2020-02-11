#!/bin/bash

DEVICE="$1"

mkdir -p /home/$USER/Android/tools
mkdir -p /home/$USER/Android/havoc
mkdir -p /home/$USER/Android/tools/google

ANDROID_TOOLS="/home/$USER/Android/tools"
HAVOC="/home/$USER/Android/havoc"
GOOGLE_API="/home/$USER/Android/tools/google"

# download sdk tools
wget -c https://dl.google.com/android/repository/platform-tools-latest-linux.zip
unzip platform-tools-latest-linux.zip -d $ANDROID_TOOLS

# add Android SDK platform tools to path
if [ -d "$ANDROID_TOOLS/platform-tools" ] ; then
    PATH="$ANDROID_TOOLS/platform-tools:$PATH"
fi

sudo apt update
sudo apt upgrade -y
sudo apt install -y openjdk-8-jdk unzip python bc bison build-essential ccache curl flex g++-multilib gcc-multilib git git-core gnupg gperf imagemagick lib32ncurses5-dev lib32readline-dev lib32z1-dev liblz4-tool libncurses5-dev libsdl1.2-dev libssl-dev libwxgtk3.0-dev libxml2 libxml2-utils lzop pngcrush rsync schedtool squashfs-tools xsltproc zip zlib1g-dev
sudo apt clean all

echo "Donwload script from Google: "
curl https://storage.googleapis.com/git-repo-downloads/repo > $GOOGLE_API/repo
chmod a+x $GOOGLE_API/repo

# set PATH so it includes user's private bin if it exists
if [ -d "$GOOGLE_API" ] ; then
    PATH="$GOOGLE_API:$PATH"
fi

#echo 'export USE_CCACHE=1' >> ~/.bashrc 
#echo 'export CCACHE_COMPRESS=1' >> ~/.bashrc 
#echo 'export CCACHE=/usr/bin/ccache' >> ~/.bashrc 
#echo 'export WITHOUT_API_CHECK=1' >> ~/.bashrc 
#echo 'export LC_ALL=C' >> ~/.bashrc 
#echo 'export SKIP_ABI_CHECKS=true' >> ~/.bashrc 

cd $HAVOC
repo init -u https://github.com/Havoc-OS/android_manifest.git -b ten --depth=1
curl --create-dirs -L -o .repo/local_manifests/local_manifest.xml -O -L https://raw.githubusercontent.com/kyoto44/android_kyoto44/master/aio/havoc.xml
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags

source build/envsetup.sh
export LC_ALL=C
export USE_CCACHE=true
export CCACHE_COMPRESS=1
export SKIP_ABI_CHECKS=true
export WITHOUT_API_CHECK=1
export CCACHE=/usr/bin/ccache
brunch $DEVICE

#WIP
BUILDNAME="Havoc-OS-v3.2-"$(date -d "$D" '+%Y')$(date -d "$D" '+%m')$(date -d "$D" '+%d')"-"$DEVICE"-Official.zip"