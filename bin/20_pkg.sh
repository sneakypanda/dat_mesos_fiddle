#!/usr/bin/env bash
# Install the OS requirements
BUILD_REQUIRES="curl build-essential devscripts debhelper"
echo "* Installing OS requirements..."
sudo apt-get -q update && sudo apt-get install ${BUILD_REQUIRES}
echo "* Finished installing OS requirements."

