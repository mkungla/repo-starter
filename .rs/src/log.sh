#!/bin/bash

################################################################################
# LOG
################################################################################
set -a
rs_log_info() { printf "\033[94m%s\033[0m %s\n" "[$RS_PROJECT_NS]:" "$*"; }
rs_log_err() { printf "\033[91m%s\033[0m %s\n" "[$RS_PROJECT_NS]:" "$*" >&2; }
rs_log_warn() { printf "\033[33m%s\033[0m %s\n" "[$RS_PROJECT_NS]:" "$*"; }
rs_log_ok() { printf "\033[32m%s\033[0m %s\n" "[$RS_PROJECT_NS]:" "$*"; }
rs_log_line() { printf "%s\n" "$*"; }
rs_log_mute() { printf "\033[39m%s\033[0m\n" "$*"; }
rs_log_bold() { printf "\033[1m%s\033[0m\n" "$*"; }
set +a
