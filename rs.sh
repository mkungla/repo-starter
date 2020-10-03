#!/bin/bash

# Why bash? Just for fun!
# [-o] prevent errors in a pipeline from being masked.
# [-u] fail if found references to any variable which was not previously defined
set -uo pipefail

################################################################################
# INIT
################################################################################
XXX_SOURCE="${BASH_SOURCE[0]}"
while [ -h "$XXX_SOURCE" ]; do
  XXX_TARGET="$(readlink "$BASH_SOURCE")"
  if [[ $XXX_TARGET == /* ]]; then
    XXX_SOURCE="$XXX_TARGET"
  else
    XXX_DIR="$( dirname "$XXX_SOURCE" )"
  fi
done

RS_PATH=$(readlink -f "${XXX_SOURCE%/*}")

source $RS_PATH/RS_CONFIG.sh

RS_DATE=$(if hash gdate 2>/dev/null; then gdate --rfc-3339=seconds | sed 's/ /T/'; else date --rfc-3339=seconds | sed 's/ /T/'; fi)
RS_DATE_YEAR=$(if hash gdate 2>/dev/null; then gdate +"%Y"; else date +"%Y"; fi)
RS_GIT_USER_NAME=$(git config --global user.name)
RS_GIT_USER_EMAIL=$(git config --global user.email)
RS_GIT_ROMOTE_URL=$(git config --get remote.origin.url)

rs_help_cmd() { printf "\033[1m  %-15s\033[0m %s\n" "$1" "$2"; }

shell="$(ps c -p "$PPID" -o 'ucomm=' 2>/dev/null || true)"
shell="${shell##-}"
shell="${shell%% *}"
shell="$(basename "${shell:-$SHELL}")"

for src in ${RS_PATH}/.rs/src/*; do
  case "$src" in
    *.sh)
      source $src
    ;;
  esac
done

################################################################################
# The command line help
################################################################################
rs_help_menu() {
  rs_log_bold "REPO STARTER"
  rs_log_line
  rs_log_line "Usage: ./rs.sh [option...] command [arg...]" >&2
  rs_log_line
  rs_log_line "Why bash? Just because :-)"
  rs_log_line
  rs_log_bold " COMMANDS"
  rs_log_line
  howidev_help_cmd "init" "initialize the repo"
  rs_log_line
  rs_log_bold " GLOBAL FLAGS"
  rs_log_line
  rs_log_line "   -h, --help                  show this help menu"
  rs_log_line "   -v, --verbose               log verbose"
  rs_log_line
}

################################################################################
# RUN
################################################################################
rs_run() {
  local int_cmd="$RS_PATH/.rs/src/commands/$1.sh"
  # get common
  # IFS=':' read -ra cb <<< "$1"
  for common_path in $RS_PATH/.rs/src/commands/**/common.sh; do
    source $common_path
  done

  if rs_file_exists $int_cmd; then
    source $int_cmd
  else
    local cmd="$RS_PATH/.rs/src/commands/$1/index.sh"
    local subbase="${2-""}"
    local scmd=""
    [[ -z "$subbase" ]] || scmd="$RS_PATH/.rs/src/commands/$1/$subbase.sh";
    # show help if needed
    if [[ $subbase == "help" ]]; then
      rs_${1}_help
    elif [[ ! -z "$subbase" ]] && rs_file_exists $scmd; then
      source $scmd
      args="${@:3}"
      rs_${1}_${subbase} $args
    elif rs_file_exists $cmd; then
      source $cmd
      args="${@:2}"
      rs_${1}_index $args
    else
      if [[ $1 == "help" ]]; then
        rs_help_menu
        rs_exit 1
      fi
      rs_log_err "command ($1) not found"
      rs_log_info "use: howi.sh --help"
      rs_exit 1
    fi
    rs_exit 1
  fi
}

################################################################################
# Parse arguments and flags
################################################################################
ARGS=()
while [ "$#" -gt 0 ]; do
  case "$1" in
    -h | --help)
      rs_help_menu
      rs_exit 0;;
    -*)
      rs_log_err "unknown option: $1";
      rs_exit 1;;
    *)
    ARGS+=("$1")
    shift 1;;
  esac
done

# run command
if [ ${#ARGS[@]} -eq 0 ]; then
  ARGS+=("help")
  ARGS+=("-")
fi

rs_run "${ARGS[@]}"
