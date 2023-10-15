#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ----------- https://github.com/jmooring/bash-function-library.git -----------
#
# Library of internal library functions
#
# @author  Joe Mooring
#
# @file
# Defines function: bfl::die().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
# Prints a fatal error message to stderr, then exits with status code 1.
#
# The message provided will be prepended with "Fatal error. "
#
# @param string $msg (optional)
#   The message.
#
# @example
#   bfl::error "The foo is bar."
#
# shellcheck disable=SC2154
#------------------------------------------------------------------------------
bfl::die() {
  # Verify arguments count.
  (( $#>= 0 && $#<= 2 )) || bfl::die "arguments count $# ∉ [0..2]." ${BFL_ErrCode_Not_verified_args_count}

  # Build a string showing the "stack" of functions that got us here.
  local stack="${FUNCNAME[*]}"
  stack="${stack// / <- }"

  # Declare positional argument (readonly).
  declare -r msg="${1:-"Unspecified fatal error."}"

  # Print the message.
  printf "%b\\n" "${bfl_aes_red}Fatal error. ${msg}${bfl_aes_reset}" 1>&2

  # Print the stack.
  printf "%b\\n" "${bfl_aes_yellow}[${stack}]${bfl_aes_reset}" 1>&2

  local -i iErr=${2:-1}
  exit $iErr
  }
