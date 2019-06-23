#!/usr/bin/env bash
BIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$(dirname ${BIN_DIR})/wrk"

APPLICATION="mesos"
DEFAULT_VERSION="1.8.0"
VERSION=${1:-${DEFAULT_VERSION}}

APP_DIR="${BASE_DIR}/${APPLICATION}-${VERSION}"

BASE_URL="https://archive.apache.org/dist"
APP_URL="${BASE_URL}/${APPLICATION}/${VERSION}"
KEYS_URL="${BASE_URL}/${APPLICATION}"

ARCHIVE_FILENAME="${APPLICATION}-${VERSION}.tar.gz"
ARCHIVE_PATH="${APP_DIR}/${ARCHIVE_FILENAME}"
ARCHIVE_URL="${APP_URL}/${ARCHIVE_FILENAME}"

SIGNATURE_FILENAME="${ARCHIVE_FILENAME}.asc"
SIGNATURE_PATH="${APP_DIR}/${SIGNATURE_FILENAME}"
SIGNATURE_URL="${APP_URL}/${SIGNATURE_FILENAME}"

DIGESTS_FILENAME="${ARCHIVE_FILENAME}.sha512"
DIGESTS_PATH="${APP_DIR}/${DIGESTS_FILENAME}"
DIGESTS_URL="${APP_URL}/${DIGESTS_FILENAME}"

KEYS_FILENAME="KEYS"
KEYS_PATH="${APP_DIR}/${KEYS_FILENAME}"
KEYS_URL="${KEYS_URL}/${KEYS_FILENAME}"

echo "* General info"
echo "APPLICATION:        ${APPLICATION}"
echo "VERSION:            ${VERSION}"
echo ""

echo "* Base directories"
echo "BIN_DIR:            ${BIN_DIR}"
echo "BASE_DIR:           ${BASE_DIR}"
echo "APP_DIR:            ${APP_DIR}"
echo ""

echo "* Base URLs"
echo "BASE_URL:           ${BASE_URL}"
echo "APP_URL:            ${APP_URL}"
echo "KEYS_URL:           ${KEYS_URL}"
echo ""

echo "* Files"
echo "- Archive"
echo "ARCHIVE_FILENAME:   ${ARCHIVE_FILENAME}"
echo "ARCHIVE_PATH:       ${ARCHIVE_PATH}"
echo "ARCHIVE_URL:        ${ARCHIVE_URL}"

echo "- Signature"
echo "SIGNATURE_FILENAME: ${SIGNATURE_FILENAME}"
echo "SIGNATURE_PATH:     ${SIGNATURE_PATH}"
echo "SIGNATURE_URL:      ${SIGNATURE_URL}"

echo "- Digests"
echo "DIGESTS_FILENAME:   ${DIGESTS_FILENAME}"
echo "DIGESTS_PATH:       ${DIGESTS_PATH}"
echo "DIGESTS_URL:        ${DIGESTS_URL}"

echo "- Keys"
echo "KEYS_FILENAME:      ${KEYS_FILENAME}"
echo "KEYS_PATH:          ${KEYS_PATH}"
echo "KEYS_URL:           ${KEYS_URL}"
echo ""

# Download distribution files
mkdir -p ${APP_DIR}
echo "* Created ${APP_DIR}"

cd ${APP_DIR}
echo "* Changed to ${APP_DIR}"

[[ -e ${ARCHIVE_PATH} ]] || curl -o ${ARCHIVE_PATH} ${ARCHIVE_URL}
[[ -e ${SIGNATURE_PATH} ]] || curl -o ${SIGNATURE_PATH} ${SIGNATURE_URL}
[[ -e ${DIGESTS_PATH} ]] || curl -o ${DIGESTS_PATH} ${DIGESTS_URL}
[[ -e ${KEYS_PATH} ]] || curl -o ${KEYS_PATH} ${KEYS_URL}
echo "* Downloaded files to ${APP_DIR}"

# Verify checksum
echo "* Verifying checksum ${APP_DIR}"
sha512sum -c ${DIGESTS_PATH}

# Import GPG keys and and verify signature
echo "* Importing signing keys"
gpg --import ${KEYS_PATH}
echo "* Verifying signature"
gpg --verify ${SIGNATURE_PATH}

