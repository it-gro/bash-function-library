#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
#----------- https://github.com/natelandau/shell-scripting-templates ----------
#
# Library of internal library functions
#
# @author  Nathaniel Landau
#
# @file
# Defines function: bfl::command_exists().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Checks if a binary exists in the search PATH.
#
# @param String $cmd_name
#   Name of the binary to check for existence.
#
# @return boolean $result
#     0 / 1   ( true / false )
#
# @example
#   (bfl::command_exists ffmpeg ) && [SUCCESS] || [FAILURE]
#------------------------------------------------------------------------------
bfl::command_exists() {
  # Verify arguments count.
  [[ $# -eq 1 ]] || bfl::die "arguments count $# ≠ 1." ${BFL_ErrCode_Not_verified_args_count}

  if command -v "$1" >/dev/null 2>&1; then
      return 0
  fi

  #bfl::writelog_debug "Did not find command: '$1'"
  return 1
  }
