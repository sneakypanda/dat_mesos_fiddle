#!/usr/bin/env bash
# Install the OS requirements
echo "* Checking OS requirements..."

REQUIRED_PKGS="curl build-essential devscripts debhelper"
MISSING_PKGS=""

echo "* Checking for missing packages..."
for PKG in ${REQUIRED_PKGS}; do
    CHECK="$(dpkg-query --show --showformat='${Status}\n' ${PKG})"
    if [[ ${CHECK} == "install ok installed" ]]; then
        echo "- Checking: ${PKG}... OK."
    else
        echo "- Checking: ${PKG}... MISSING."
        MISSING_PKGS="${MISSING_PKGS} ${PKG}"
    fi
done

if [[ -z ${MISSING_PKGS} ]]; then
    echo "* All required packages are installed."
else
    echo "* Missing packages: ${MISSING_PKGS}"
    echo "- Updating apt..."
    sudo apt-get --quiet update
fi

for PKG in ${MISSING_PKGS}; do
    echo "- Installing ${PKG}"
    sudo apt-get --quiet --yes install ${PKG}
done


#sudo apt-get -q update && sudo apt-get install ${BUILD_REQUIRES}
#echo "* Finished installing OS requirements."

