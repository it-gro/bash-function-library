#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ /bash_functions_library ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ----------- https://github.com/jmooring/bash-function-library.git -----------
#
# Library of number operating functions
#
# @author  Joe Mooring
#
# @file
# Defines function: bfl::is_integer().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
# Determines if the argument is an integer.
#
# @param string $value_to_test
#   The value to be tested.
#
# @example
#   bfl::is_integer "8675309"
#------------------------------------------------------------------------------
#
bfl::is_integer() {
  # Verify arguments count.
  [[ $# -eq 1 ]] || bfl::die "arguments count $# ≠ 1." ${BFL_ErrCode_Not_verified_args_count}

  [[ "$1" =~ ^-{0,1}[0-9]+$ ]] # || return 1
  }