#!/bin/bash
################################################################################
# command       : addon:create
# sub command   : index
# description   : Create new addon
# author        :
# date          : 2020-09-23T00:21:20+03:00
# bash_version  : 5.0.17(1)-release
################################################################################

local dest=${RS_PATH}/${RS_DEST}
rs_init_index() {
  rs_task_start "init"
  shopt -s dotglob
  rm -f ${RS_PATH}/LICENSE
  rm -f ${RS_PATH}/README.md
  rm -f ${RS_PATH}/rs.sh
  for tmpl in $(find ${RS_PATH}/.rs/tmpl/ -type f); do
    # Directory
    local src_dir=$(dirname "${tmpl}")
    local dir=${src_dir#"$RS_PATH/.rs/tmpl"}
    if [ -z "$dir" ]; then
      dir="/"
    fi
    mkdir -p $dest$dir
    local name="$(basename "${tmpl}")"
    eval "echo \"$(cat "${tmpl}")\"" > $dest$dir/$name
  done
  rm -rf ${RS_PATH}/.rs
  git add -A
  git commit --amend --no-edit
  git push -f
  rs_task_done
}
