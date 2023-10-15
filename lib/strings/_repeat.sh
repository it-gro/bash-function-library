#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ------------- https://github.com/jmooring/bash-function-library -------------
#
# Library of functions related to Bash Strings
#
# @author  Joe Mooring
#
# @file
# Defines function: bfl::repeat().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
# Repeats a string.
#
# @param string $str
#   The string to be repeated.
# @param int $n
#   Number of times the string will be repeated.
#
# @return string $Rslt
#   The repeated string.
#
# @example
#   bfl::repeat "=" "10"
#------------------------------------------------------------------------------
bfl::repeat() {
  # Verify arguments count.
  [[ $# -eq 2 ]] || bfl::die "arguments count $# ≠ 2." ${BFL_ErrCode_Not_verified_args_count}

  # Verify arguments' values.
  [[ -z "$1" ]] && bfl::die "First argument is empty!" ${BFL_ErrCode_Not_verified_arg_values}
  bfl::is_positive_integer "$2" || bfl::die "'$2' expected to be a positive integer." ${BFL_ErrCode_Not_verified_arg_values}

  local -r str="$1"
  local -r n="$2"
  local Rslt

  # Create a string of spaces that is $i long.
  Rslt=$(printf "%${n}s") || bfl::die "printf '%${n}s'"
  # Replace each space with the $str.
  Rslt=${Rslt// /"${str}"}

  printf "%s" "${Rslt}"
  }
