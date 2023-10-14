#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ /bash_functions_library ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ----------- https://github.com/jmooring/bash-function-library.git -----------
#
# Library of date/time functions
#
# @author  Joe Mooring
#
# @file
# Defines function: bfl::time_convert_s_to_hhmmss().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
# Converts seconds to the hh:mm:ss format.
#
# @param int $seconds
#   The number of seconds to convert.
#
# @return string $hhmmss
#   The number of seconds in hh:mm:ss format.
#
# @example
#   bfl::time_convert_s_to_hhmmss "3661"
#------------------------------------------------------------------------------
bfl::time_convert_s_to_hhmmss() {
  # Verify arguments count.
  [[ $# -eq 1 ]] || bfl::die "arguments count $# ≠ 1" ${BFL_ErrCode_Not_verified_args_count}

  # Verify arguments' values.
  bfl::is_positive_integer "$1" \
      || bfl::die "'$1' expected to be a positive integer." ${BFL_ErrCode_Not_verified_arg_values}

  local -r seconds="$1"
  local hhmmss
  hhmmss=$(printf '%02d:%02d:%02d\n' \
      $((seconds/3600)) $((seconds%3600/60)) $((seconds%60))) \
      || bfl::die "Unable to convert '${seconds}' to hh:mm:ss format."

  printf "%s" "${hhmmss}"
  }