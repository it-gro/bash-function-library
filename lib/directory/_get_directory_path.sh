#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ----------- https://github.com/jmooring/bash-function-library.git -----------
#
# Library of directory functions
#
# @author  Joe Mooring
#
# @file
# Defines function: bfl::get_directory_path().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
# Gets the canonical path to a directory.
#
# @param string $path
#   A relative path, absolute path, or symbolic link.
#
# @return string $canonical_directory_path
#   The canonical path to the directory.
#
# @example
#   bfl::get_directory_path "./foo"
#------------------------------------------------------------------------------
bfl::get_directory_path() {
  # Verify arguments count.
  [[ $# -eq 1 ]] || bfl::die "arguments count $# ≠ 1." ${BFL_ErrCode_Not_verified_args_count}

  # Verify arguments' values.
  bfl::is_blank "$1" && bfl::die "The path is required." ${BFL_ErrCode_Not_verified_arg_values}

  local canonical_directory_path  # Verify that the path exists.
  if [[ ${BFL_HAS_READLINK} -eq 1 ]]; then
      canonical_directory_path=$(readlink -e "$1") || bfl::die "readlink -e '$1'" ${BFL_ErrCode_Not_verified_arg_values}
  else
      [[ -e "$1" ]] || bfl::die "path '$1' does not exist." ${BFL_ErrCode_Not_verified_arg_values}
      canonical_directory_path="$1"
  fi

  # Verify that the path points to a directory, not a file.
  [[ -d "${canonical_directory_path}" ]] || bfl::die "Canonical directory path '$canonical_directory_path' is not a directory."

  printf "%s" "${canonical_directory_path}"
  }
