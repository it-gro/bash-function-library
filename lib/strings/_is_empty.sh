#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ /bash_functions_library ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ------------- https://github.com/jmooring/bash-function-library -------------
#
# Library of functions related to Bash Strings
#
# @author  Joe Mooring
#
# @file
# Defines function: bfl::is_empty().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
# Checks if a string is empty ("") or null.
#
# @param string $str
#   The string to check.
#
# @example
#   bfl::is_empty "foo"
#------------------------------------------------------------------------------
bfl::is_empty() {
  # Verify argument count.
  [[ $# -eq 1 ]] || bfl::die "arguments count $# ≠ 1" ${BFL_ErrCode_Not_verified_args_count}

  [[ -z "$1" ]] # || return 1
  }