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
# Defines function: bfl::get_file_path().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
# Gets the canonical path to a file.
#
# @param string $path
#   A relative path, absolute path, or symbolic link.
#
# @return string $canonical_file_path
#   The canonical path to the file.
#
# @example
#   bfl::get_file_path "./foo/bar.text"
#------------------------------------------------------------------------------
bfl::get_file_path() {
  # Verify arguments count.
  [[ $# -eq 1 ]] || bfl::die "arguments count $# ≠ 1" ${BFL_ErrCode_Not_verified_args_count}

  # Verify arguments' values.
  bfl::is_blank "$1" && bfl::die "The path is required." ${BFL_ErrCode_Not_verified_arg_values}

  # Verify that the path exists.
  local canonical_file_path
  canonical_file_path="$(readlink -e "$1")" || bfl::die "readlink -e '$1'" $?

  # Verify that the path points to a file, not a directory.
  [[ -f "${canonical_file_path}" ]] || bfl::die "'${canonical_file_path}' is not a file."

  printf "%s" "${canonical_file_path}"
  }