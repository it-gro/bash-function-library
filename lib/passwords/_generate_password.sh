#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ----------- https://github.com/jmooring/bash-function-library.git -----------
#
# Library of functions related to password abd cache generating, files encrypting
#
# @author  Joe Mooring
#
# @file
# Defines function: bfl::generate_password().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
# Generates a random password.
#
# Password characteristics:
# - At least one lowercase letter
# - At least one uppercase letter
# - At least one digit
# - One underscore placed randomly in the middle.
# - Minimum length of 8
#
# The underscore placed randomly in the middle ensures that the password will
# have at least one special character. The underscore is probably the most
# benign special character (i.e., it won't break quoted strings, doesn't
# contain escape sequences, etc.).
#
# @param int $pswd_length
#   The length of the desired password.
#
# @return string $password
#   A random password
#
# @example
#   bfl::generate_password "16"
#------------------------------------------------------------------------------
bfl::generate_password() {
  # Verify arguments count.
  [[ $# -eq 1 ]] || bfl::die "arguments count $# ≠ 1." ${BFL_ErrCode_Not_verified_args_count}

  local -r min_pswd_length=8

  # Verify argument values.
  bfl::is_positive_integer "$1" \
      || bfl::die "'${pswd_length}' expected to be positive integer." ${BFL_ErrCode_Not_verified_arg_values}

  [[ "$1" -lt "${min_pswd_length}" ]] \
    && bfl::die "'${pswd_length}' expected >= '${min_pswd_length}'." ${BFL_ErrCode_Not_verified_arg_values}

  # Verify dependencies.
  [[ ${_BFL_HAS_PWGEN} -eq 1 ]] || bfl::die "dependency 'pwgen' not found" ${BFL_ErrCode_Not_verified_dependency}
  [[ ${_BFL_HAS_SHUF} -eq 1 ]]  || bfl::die "dependency 'shuf' not found"  ${BFL_ErrCode_Not_verified_dependency}

  # Declare positional argument (readonly).
  local -r pswd_length="$1"

  # Declare all other variables (sorted by name).
  local length_one
  local length_two
  local password

  length_one=$(shuf -i 1-$((pswd_length-2)) -n 1) || bfl::die "shuf -i 1-\$((pswd_length-2)) -n 1"
  length_two=$((pswd_length-length_one-1)) || bfl::die "((pswd_length-length_one-1))"
  password=$(pwgen -cns "$length_one" 1)_$(pwgen -cns "$length_two" 1) \
      || bfl::die "pwgen -cns '\$length_one' 1)_\$(pwgen -cns '$length_two' 1"

  printf "%s" "${password}"
  }
