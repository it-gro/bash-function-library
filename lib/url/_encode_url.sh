#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
#
# Library of functions related to the internet
#
# @author
#
# @file
# Defines function: bfl::urlencode().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Synonim bfl::urlencode().
#
# @param String $str
#   The string to be encoded.
#
# @return String $Rslt
#   The encoded string.
#------------------------------------------------------------------------------
bfl::encode_url() {
  local Rslt
  Rslt=$(bfl::urlencode "$@") || return $?
  printf "%s\\n" "$Rslt"
  }