#!/bin/bash
################################################################################
# command       : addon:create
# author        :
# date          : 2020-09-23T00:21:20+03:00
# bash_version  : 5.0.17(1)-release
################################################################################

# add (addon:create) shared methods and VARS here
# this file is sourced also by subcommands of (addon:create)
rs_init_help() {
  rs_log_bold " INIT NEW REPO"
  rs_log_line
  rs_log_line "    Initialize new repository"
  rs_log_line
}
