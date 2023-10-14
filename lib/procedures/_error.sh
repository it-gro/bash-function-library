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
# Defines function: bfl::error().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
# Prints an error message to stderr.
#
# The message provided will be prepended with "Error. "
#
# @param string $msg (optional)
#   The message.
#
# @example
#   bfl::error "The foo is bar."
#
# shellcheck disable=SC2154
#------------------------------------------------------------------------------
bfl::error() {
  # Verify arguments count.
  (( $#>= 0 && $#<= 1 )) || bfl::die "arguments count $# ∉ [0..1]." ${BFL_ErrCode_Not_verified_args_count}

  # Declare positional argument (readonly).
  declare msg="${1:-"Unspecified error."}"

  # Print the message.
  printf "%b\\n" "${bfl_aes_red}Error. ${msg}${bfl_aes_reset}" 1>&2
  }