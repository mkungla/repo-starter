#!/bin/bash

rs_exit() {
  exit $1
}

rs_file_exists() {
  if [[ -f $1 ]] && [[ -n $1 ]] ; then
    return 0
  else
    return 1
  fi
}

rs_is_dir() {
  if [[ -d $1 ]] && [[ -n $1 ]] ; then
    return 0
  else
    return 1
  fi
}

rs_has_env_with_val() {
 local varname="${1:=""}"
 local varval="${2:=""}"
 if [[ ! -v "${varname}" ]]; then
   rs_log_warn "no" $varname
   return 1
 else
   if [[ "${!varname}" == "$varval" ]]; then
     return 0
   else
     return 1
   fi
 fi
}
