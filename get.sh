#!/usr/bin/env bash
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="${REPO_ROOT}/wrk"

APPLICATION="mesos"
DEFAULT_VERSION="1.8.0"
VERSION=${1:-${DEFAULT_VERSION}}

APP_DIR="${BASE_DIR}/${APPLICATION}-${VERSION}"

BASE_URL="https://archive.apache.org/dist"
APP_URL="${BASE_URL}/${APPLICATION}/${VERSION}"

ARCHIVE="${APPLICATION}-${VERSION}.tar.gz"
SIGNATURE="${ARCHIVE}.asc"
DIGESTS="${ARCHIVE}.sha512"

echo "APPLICATION: ${APPLICATION}"
echo "VERSION:     ${VERSION}"

echo "REPO_ROOT:   ${REPO_ROOT}"
echo "BASE_DIR:    ${BASE_DIR}"
echo "APP_DIR:     ${BASE_DIR}"
echo "BASE_URL:    ${BASE_URL}"
echo "APP_URL:     ${APP_URL}"

echo "ARCHIVE:     ${ARCHIVE}"
echo "SIGNATURE:   ${SIGNATURE}"
echo "DIGESTS:     ${DIGESTS}"

#mkdir -p ${APP_DIR}
#cd ${APP_DIR}
#[[ -e ${APP_DIR}/${ARCHIVE} ]] || curl -O ${APP_URL}/${ARCHIVE}
#[[ -e ${APP_DIR}/${SIGNATURE} ]] || curl -O ${APP_URL}/${SIGNATURE}
#[[ -e ${APP_DIR}/${DIGESTS} ]] || curl -O ${APP_URL}/${DIGESTS}
#
#CHECKSUM=$(cat ${APP_DIR}/${DIGESTS} | awk '{print $1}')
#echo "CHECKSUM:    ${CHECKSUM}"
#sha512sum -c ${APP_DIR}/${DIGESTS}
