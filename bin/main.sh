#!/usr/bin/env bash
BIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

bash ${BIN_DIR}/10_get.sh
bash ${BIN_DIR}/20_os_prep.sh
