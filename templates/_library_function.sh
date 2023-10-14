#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ /bash_functions_library ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# -------------------------- https://github.com/.... --------------------------
#
# Library of functions ......
#
# @author  ...........
#
# @file
# Defines function: bfl::library_function(). # TODO
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
# Does something. # TODO
#
# Detailed description. Use multiple lines if needed. # TODO
#
# @param type $foo # TODO
#   Description. # TODO
# @param type $bar # TODO
#   Description. # TODO
#
# @return type $baz # TODO
#   Description. # TODO
#
# @example
#   bfl::library_function "Fred" "George" # TODO
#------------------------------------------------------------------------------
bfl::library_function() {
  # Verify arguments count.
  (( $#>= 1 && $#<= 2 )) || bfl::die "arguments count $# ∉ [1..2]." ${BFL_ErrCode_Not_verified_args_count}

  # Verify dependencies.
  bfl::verify_dependencies "printf" # TODO

  # Declare positional arguments (readonly, sorted by position).
  declare -r foo="$1" # TODO
  declare -r bar="$2" # TODO

  # Declare return value.
  declare baz # TODO

  # Declare readonly variables (sorted by name).
  declare -r wibble="Harry" # TODO
  declare -r wobble="Ron" # TODO

  # Declare all other variables (sorted by name).
  declare eggs="Dean" # TODO
  declare ham="Seamus" # TODO

  # Verify argument values.
  bfl::is_blank "${foo}" && bfl::die "Foo is required." # TODO
  bfl::is_blank "${bar}" && bfl::die "Bar is required." # TODO

  # Build the return value.
  baz="${foo}, ${bar}, ${wibble}, ${wobble}, ${eggs}, and ${ham}." # TODO

  # Print the return value.
  printf "%s\\n" "${baz}" # TODO
}
