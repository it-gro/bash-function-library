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
# Defines function: bfl::find_nearest_integer().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
# Finds the nearest integer to a target integer from a list of integers.
#
# @param string $target
#   The target integer.
# @param string $list
#   A list of integers.
#
# @return string $nearest
#   Integer in list that is nearest to the target.
#
# @example
#   bfl::find_nearest_integer "4" "0 3 6 9 12"
#------------------------------------------------------------------------------
bfl::find_nearest_integer() {
  # Verify arguments count.
  [[ $# -eq 2 ]] || bfl::die "arguments count $# ≠ 2" ${BFL_ErrCode_Not_verified_args_count}

  # Verify arguments' values.
  bfl::is_integer "$1" || bfl::die "'$1' expected to be an integer." ${BFL_ErrCode_Not_verified_arg_values}

  local -ar list="($2)"
  local -r regex="^(-{0,1}[0-9]+\s*)+$"
  [[ "${list[*]}" =~ ${regex} ]] \
    || bfl::die "Second argument '${list[*]}' expected to be a list of integers." ${BFL_ErrCode_Not_verified_arg_values}

  # Declare positional argument (readonly).
  local -r target="$1"

  # Declare all other variables (sorted by name).
  local abs_diff
  local diff
  local item
  local nearest
  local table

  for item in "${list[@]}"; do
      diff=$((target-item)) || bfl::die "diff = '$target'-'$item'." $?
      abs_diff="${diff/-/}"
      table+="${item} ${abs_diff}\\n"
  done

  # Remove final line feed from $table.
  table=${table::-2}

  nearest=$(echo -e "${table}" | sort -n -k2 | head -n1 | cut -f1 -d " ") \
    || bfl::die "nearest = \$(echo -e '$table' | sort -n -k2 | head -n1 | cut -f1 -d ' ')" $?
  
  printf "%s" "${nearest}"
  }