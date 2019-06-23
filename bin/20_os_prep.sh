#!/usr/bin/env bash
# Install the OS requirements
echo "* Checking OS requirements..."

PACKAGING_REQUIRES="curl build-essential devscripts debhelper"
MESOS_REQUIRES="tar wget git openjdk-8-jdk build-essential python-dev"
MESOS_REQUIRES="${MESOS_REQUIRES} python-six python-virtualenv"
MESOS_REQUIRES="${MESOS_REQUIRES} libcurl4-nss-dev libsasl2-dev"
MESOS_REQUIRES="${MESOS_REQUIRES} libsasl2-modules maven libapr1-dev"
MESOS_REQUIRES="${MESOS_REQUIRES} libsvn-dev zlib1g-dev iputils-ping"
REQUIRED_PKGS="${PACKAGING_PKGS} ${MESOS_REQUIRES}"
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
    sudo apt-get --quiet --yes install ${MISSING_PKGS}
fi

echo "* Finished installing OS requirements."

