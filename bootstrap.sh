#!/usr/bin/env bash


#########################################################
# Source https://mailinabox.email/ https://github.com/mail-in-a-box/mailinabox
# Updated by Afiniel for Yiimpool use...
# This script is intended to be run like this:
#
#   curl https://raw.githubusercontent.com/Afiniel-tech/Yiimpool-Installer/master/bootstrap.sh | bash

#
#########################################################
if [ -z "${TAG}" ]; then
	TAG=v2.1
fi


# Clone the yiimpool repository if it doesn't exist.
if [ ! -d $HOME/yiimpool ]; then
	if [ ! -f /usr/bin/git ]; then
		echo Installing git . . .
		apt-get -q -q update
		DEBIAN_FRONTEND=noninteractive apt-get -q -q install -y git < /dev/null
		echo DONE...
		echo

	fi
	
	echo Downloading Yiimpool Installer ${TAG}. . .
	git clone \
		-b ${TAG} --depth 1 \
		https://github.com/Afiniel-tech/yiimpool_setup \
		"$HOME"/yiimpool/install \
		< /dev/null 2> /dev/null

	echo
fi

# Set permission and change directory to it.
cd $HOME/yiimpool/install

# Update it.
sudo chown -R $USER $HOME/yiimpool/install/.git/
if [ "${TAG}" != `git describe --tags` ]; then
	echo Updating Yiimpool Installer to ${TAG} . . .
	git fetch --depth 1 --force --prune origin tag ${TAG}
	if ! git checkout -q ${TAG}; then
		echo "Update failed. Did you modify something in `pwd`?"
		exit
	fi
	echo
fi

# Start setup script.
bash $HOME/yiimpool/install/start.sh
