#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ /bash_functions_library ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ----------- https://github.com/jmooring/bash-function-library.git -----------
#
# Library of internal library functions
#
# @author  Joe Mooring
#
# @file
# Defines function: bfl::verify_arg_count().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
# Verifies the number of arguments received against expected values.
#
# Other functions in this library call this function to verify the number of
# arguments received. To prevent infinite loops, this function must not call
# any other function in this library, other than bfl::die.
#
# That is why we are essentially recreating:
# - bfl::verify_arg_count()
# - bfl::is_integer()
#
# @param int $actual_arg_count
#   Actual number of arguments received.
# @param int $expected_arg_count_min
#   Minimum number of arguments expected.
# @param int $expected_arg_count_max
#   Maximum number of arguments expected.
#
# @example
#   bfl::verify_arg_count "$#" 2 3
#------------------------------------------------------------------------------
bfl::verify_arg_count() {
  # Verify argument count.
  [[ "$#" -ne "3" ]] && bfl::die "arguments count $# ≠ 3." ${BFL_ErrCode_Not_verified_args_count}

  # Verify arguments' values. Make sure all of the arguments are integers.
  bfl::is_positive_integer "$1" || bfl::die "'$1' expected to be an integer." ${BFL_ErrCode_Not_verified_arg_values}
  bfl::is_positive_integer "$2" || bfl::die "'$2' expected to be an integer." ${BFL_ErrCode_Not_verified_arg_values}
  bfl::is_positive_integer "$3" || bfl::die "'$3' expected to be an integer." ${BFL_ErrCode_Not_verified_arg_values}

  local -r arg_count="$1"
  local -r expected_min="$2"
  local -r expected_max="$3"

  # Test.
  if [[ "${arg_count}" -lt "${expected_min}" || \
        "${arg_count}" -gt "${expected_max}" ]]; then
      if [[ ${BASH_INTERACTIVE} == true ]]; then
          local error_msg
          if [[ "${expected_min}" -eq "${expected_max}" ]]; then
              error_msg=" Expected ${expected_min}, received ${arg_count}."
          else
              error_msg="Expected between ${expected_min} and ${expected_max}, received ${arg_count}."
          fi
          printf "%b\\n" "${bfl_aes_red}Invalid number of arguments. ${error_msg}${bfl_aes_reset}" 1>&2
      fi
      return 1
  fi
  }