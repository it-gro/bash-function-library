#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ /bash_functions_library ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ----------- https://github.com/jmooring/bash-function-library.git -----------
#
# Library of functions related to manipulations with files
#
# @author  Joe Mooring
#
# @file
# Defines function: bfl::get_file_name_without_extension().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
# Gets the file name, excluding extension.
#
# @param string $path
#   A relative path, absolute path, or symbolic link.
#
# @return string $file_name_without_extension
#   The file name, excluding extension.
#
# @example
#   bfl::get_file_name_without_extension "./foo/bar.txt"
#------------------------------------------------------------------------------
bfl::get_file_name_without_extension() {
  # Verify arguments count.
  [[ $# -eq 1 ]] || bfl::die "arguments count $# ≠ 1" ${BFL_ErrCode_Not_verified_args_count}

  # Verify arguments' values.
  bfl::is_blank "$1" && bfl::die "The path is required." ${BFL_ErrCode_Not_verified_arg_values}

  local file_name
  file_name="$(bfl::get_file_name "$1")" || bfl::die "bfl::get_file_name '$1'" $?
  local file_name_without_extension
  file_name_without_extension="${file_name%.*}"

  printf "%s" "${file_name_without_extension}"
  }