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
# Defines function: bfl::transliterate().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
# Transliterates a string.
#
# @param string $str
#   The string to transliterate.
#
# @return string $Rslt
#   The transliterated string.
#
# @example
#   bfl::transliterate "_Olé Über! "
#------------------------------------------------------------------------------
bfl::transliterate() {
  # Verify arguments count.
  [[ $# -eq 1 ]] || bfl::die "arguments count $# ≠ 1." ${BFL_ErrCode_Not_verified_args_count}

  # Verify dependencies.
  [[ ${_BFL_HAS_ICONV} -eq 1 ]]   || bfl::die "dependency 'iconv' not found" ${BFL_ErrCode_Not_verified_dependency}

  # Enable extended pattern matching features.
  shopt -s extglob

  # Convert from UTF-8 to ASCII.
  local Rslt
  Rslt=$(iconv -c -f utf8 -t ascii//TRANSLIT <<< "$1") || bfl::die "iconv -c -f utf8 -t ascii//TRANSLIT <<< '$1'"
  
  Rslt=${Rslt//[^[:alnum:]]/-}  # Replace non-alphanumeric characters with a hyphen.
  Rslt=${Rslt//+(-)/-}          # Replace two or more sequential hyphens with a single hyphen.
  Rslt=${Rslt#-}                # Remove leading hyphen, if any.
  Rslt=${Rslt%-}                # Remove trailing hyphen, if any.
  Rslt=${Rslt,,}                # Convert to lower case

  printf "%s" "${Rslt}"
  }
