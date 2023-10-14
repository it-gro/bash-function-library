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
# Defines function: bfl::trim().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
# Removes leading and trailing whitespace, including blank lines, from string.
#
# The string can either be single or multi-line. In a multi-line string,
# leading and trailing whitespace is removed from every line.
#
# @param string $str
#   The string to be trimmed.
#
# @return string $Rslt
#   The trimmed string.
#
# @example
#   bfl::trim " foo "
#------------------------------------------------------------------------------
bfl::trim() {
  # Verify arguments count.
  [[ $# -eq 1 ]] || bfl::die "arguments count $# ≠ 1." ${BFL_ErrCode_Not_verified_args_count}

  # Explanation of sed commands:
  # - Remove leading whitespace from every line: s/^[[:space:]]+//
  # - Remove trailing whitespace from every line: s/[[:space:]]+$//
  # - Remove leading and trailing blank lines: /./,$ !d
  #
  # See https://tinyurl.com/yav7zw9k and https://tinyurl.com/3z8eh

  local Rslt
  Rslt=$(printf "%b" "$1" | sed -E 's/^[[:space:]]+// ; s/[[:space:]]+$// ; /./,$ !d') \
      || bfl::die "Unable to trim whitespace."

  printf "%s" "${Rslt}"
  }