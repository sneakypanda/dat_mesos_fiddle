#!/usr/bin/env bash
# Based on this:
# https://wiki.debian.org/Packaging/Intro?action=show&redirect=IntroDebianPackaging
BIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$(dirname ${BIN_DIR})/wrk"

APPLICATION="mesos"
VERSION="1.8.0"
PKG_VERSION="1"
export DEBFULLNAME="$(git config --get user.name)"
export DEBEMAIL="$(git config --get user.email)"

APP_DIR="${BASE_DIR}/${APPLICATION}-${VERSION}"

SRC_TARBALL="${APPLICATION}-${VERSION}.tar.gz"
SRC_PATH="${APP_DIR}/${SRC_TARBALL}"

DST_TARBALL="${APPLICATION}_${VERSION}.orig.tar.gz"
DST_PATH="${APP_DIR}/${DST_TARBALL}"

EXTRACT_PATH="${APP_DIR}/${APPLICATION}-${VERSION}"
DEBIAN_FOLDER="${EXTRACT_PATH}/debian"
DEBIAN_CHANGELONG="${DEBIAN_FOLDER}/changelog"
DEBIAN_COMPAT="${DEBIAN_FOLDER}/compat"
DEBIAN_CONTROL="${DEBIAN_FOLDER}/control"
DEBIAN_COPYRIGHT="${DEBIAN_FOLDER}/copyright"
DEBIAN_RULES="${DEBIAN_FOLDER}/rules"
DEBIAN_SRC_FMT="${DEBIAN_FOLDER}/source/format,"

echo "* General info"
echo "APPLICATION:        ${APPLICATION}"
echo "VERSION:            ${VERSION}"
echo "PKG_VERSION:        ${PKG_VERSION}"
echo "DEBFULLNAME:        ${DEBFULLNAME}"
echo "DEBEMAIL:           ${DEBEMAIL}"
echo ""
echo "* Base directories"
echo "BIN_DIR:            ${BIN_DIR}"
echo "BASE_DIR:           ${BASE_DIR}"
echo "APP_DIR:            ${APP_DIR}"
echo ""
echo "* Tarballs"
echo "SRC_TARBALL:        ${SRC_TARBALL}"
echo "SRC_PATH:           ${SRC_PATH}"
echo "DST_TARBALL:        ${DST_TARBALL}"
echo "DST_PATH:           ${DST_PATH}"
echo ""
echo "* Packaging files"
echo "EXTRACT_PATH:       ${EXTRACT_PATH}"
echo "DEBIAN_FOLDER:      ${DEBIAN_FOLDER}"
echo "DEBIAN_CHANGELOG:   ${DEBIAN_CHANGELOG}"
echo "DEBIAN_COMPAT:      ${DEBIAN_COMPAT}"
echo "DEBIAN_CONTROL:     ${DEBIAN_CONTROL}"
echo ""

cd ${APP_DIR}
echo "* Changed to ${APP_DIR}"

echo "* Step 1: Rename the upstream tarball"
# NOTE(coenie): We copy instead of move so we don't have to re-download.
if [[ -e ${DST_PATH} ]]; then
    rm --recursive ${DST_PATH}
    echo "- Removed existing destination tarball: ${DST_PATH}"
else
    echo "- No existing destination tarball: ${DST_PATH}"
fi
cp ${SRC_PATH} ${DST_PATH}
echo "- Copied source tarball to destination:"
ls -lah ${SRC_PATH}
ls -lah ${DST_PATH}

echo "* Step 2: Unpack the upstream tarball"
if [[ -e ${EXTRACT_PATH} ]]; then
    rm --recursive ${EXTRACT_PATH}
    echo "- Removing previous extract: ${EXTRACT_PATH}"
else
    echo "- No existing extract: ${EXTRACT_PATH}"
fi
tar --extract --gzip --file=${DST_TARBALL}
echo "- Extracted tarball to ${EXTRACT_PATH}"

echo "* Step 3: Add the Debian packaging files"
cd ${EXTRACT_PATH}
if [[ ${PWD} != ${EXTRACT_PATH} ]]; then
    echo "- WARNING: CWD is ${PWD}, expected ${EXTRACT_PATH}"
fi
echo "- Changed to ${PWD}"

mkdir -p ${DEBIAN_FOLDER}
echo "- Created ${DEBIAN_FOLDER}"
ls -lah ${DEBIAN_FOLDER}

echo "- Creating ${DEBIAN_CHANGELOG}"
dch \
    --create \
    --newversion ${VERSION}-${PKG_VERSION} \
    --package ${APPLICATION}
ls -lah ${DEBIAN_CHANGELOG}

echo "- Creating ${DEBIAN_COMPAT}"
echo "10" >> ${DEBIAN_COMPAT}
ls -lah ${DEBIAN_COMPAT}

echo "- Creating ${DEBIAN_CONTROL}"
cat > ${DEBIAN_CONTROL} <<EOF
Source: ${APPLICATION}
Maintainer: ${DEBFULLNAME} <${DEBEMAIL}>
Section: misc
Priority: extra
Standards-Version: ${VERSION}
Build-Depends: debhelper (>= 9):
Package: ${APPLICATION}
Architecture: any
Depends: ${shlibs:Depends}, ${misc:Depends}
Description: A distributed systems kernel.
    Apache Mesos abstracts CPU, memory, storage, and other compute resources away from machines (physical or virtual), enabling fault-tolerant and elastic distributed systems to easily be built and run effectively.
EOF

echo "- Creating ${DEBIAN_COPYRIGHT}"
cp ${EXTRACT_PATH}/LICENSE ${DEBIAN_COPYRIGHT}

echo "- Creating ${DEBIAN_RULES}"
cat <<EOF | sed 's/ \+ /\t/g' > ${DEBIAN_RULES} 
#!/usr/bin/make -f
%:
    dh \$\@
override_dh_auto_install:
    $(MAKE) DESTDIR=$$(pwd)/debian/${APPLICATION} prefix=/usr install
EOF

echo "- Creating ${DEBIAN_SRC_FMT}"
echo "3.0 (quilt)" > ${DEBIAN_SRC_FMT}

echo "* Step 4: Build the package"
debuild -us -uc
