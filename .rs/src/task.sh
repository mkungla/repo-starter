#!/bin/bash
rs_taskstart=""
rs_taskname=""

rs_task_start() {
  rs_log_info $(printf "\033[1mstarting task:\033[0m %s\n" "$1")
  rs_taskname=$1
  rs_taskstart=$(date +%s.%N)
}

rs_task_done() {
  cd $RS_PATH
  local timer=$(date +%s.%N)

  local dt=$(echo "$timer - $rs_taskstart" | bc)
  local dd=$(echo "$dt/86400" | bc)
  local dt2=$(echo "$dt-86400*$dd" | bc)
  local dh=$(echo "$dt2/3600" | bc)
  local dt3=$(echo "$dt2-3600*$dh" | bc)
  local dm=$(echo "$dt3/60" | bc)
  local ds=$(echo "$dt3-60*$dm" | bc)

  local msg="${1-""}"

  if [ ! -z "$msg" ]; then rs_log_info $msg; fi
  rs_log_info $(printf "\033[1m$rs_taskname finished\033[0m")
  rs_log_ok $(printf "task done \033[1mexecution time: \033[0m %dd %02dh %02dm %02.4fs" $dd $dh $dm $ds )
  exit 0
}

rs_task_failed() {
  local timer=$(date +%s.%N)

  local dt=$(echo "$timer - $rs_taskstart" | bc)
  local dd=$(echo "$dt/86400" | bc)
  local dt2=$(echo "$dt-86400*$dd" | bc)
  local dh=$(echo "$dt2/3600" | bc)
  local dt3=$(echo "$dt2-3600*$dh" | bc)
  local dm=$(echo "$dt3/60" | bc)
  local ds=$(echo "$dt3-60*$dm" | bc)

  rs_log_err $(printf "\033[1mtask %s failed:\033[0m %s" "$rs_taskname" "$1")
  rs_log_err $(printf "\033[1mexecution time: \033[0m %dd %02dh %02dm %02.4fs" $dd $dh $dm $ds )
  exit 1
}
