#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ------------- https://github.com/jmooring/bash-function-library -------------
#
# Library of internal library functions
#
# @author  Joe Mooring
#
# @file
# Defines function: bfl::verify_dependencies().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Verifies that dependencies are installed.
#
# @param array $apps
#   One dimensional array of applications, executables, or commands.
#
# @example
#   bfl::verify_dependencies "curl" "wget" "git"
#------------------------------------------------------------------------------
bfl::verify_dependencies() {
  # Verify arguments count.
  (( $# > 0 && $# < 1000 )) || { bfl::error "arguments count $# ∉ [1..999]."; return ${BFL_ErrCode_Not_verified_args_count}; }

  local -ar apps=("$@")
  local app
  local -i iErr

  for app in "${apps[@]}"; do
      hash "${app}" 2> /dev/null || { iErr=$?; bfl::error "${app} is not installed."; return ${iErr}; }
  done
  }