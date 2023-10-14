#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ /bash_functions_library ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ----------- https://github.com/jmooring/bash-function-library.git -----------
#
# Library of functions related to Apache
#
# @author  Joe Mooring
#
# @file
# Defines function: bfl::is_apache_vhost().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
# Checks if the given path is the root of an Apache virtual host.
#
# @param string $path
#   A relative path, absolute path, or symbolic link.
# @param string $sites_enabled [optional]
#   Absolute path to Apache's "sites-enabled" directory.
#   Defaults value is /etc/apache2/sites-enabled.
#
# @example
#   bfl::is_apache_vhost "./foo"
# @example
#   bfl::is_apache_vhost "./foo" "/etc/apache2/sites-enabled"
#------------------------------------------------------------------------------
bfl::is_apache_vhost() {
  # Verify arguments count.
  (( $#>= 1 && $#<= 2 )) || bfl::die "arguments count $# ∉ [1..2]." ${BFL_ErrCode_Not_verified_args_count}

  # Verify arguments' values.
  bfl::is_blank "$1" && bfl::die "path argument is empty." ${BFL_ErrCode_Not_verified_arg_values}
  [[ $# -eq 2 ]] && bfl::is_blank "$2" && bfl::die "path_sites_enabled argument is empty." ${BFL_ErrCode_Not_verified_arg_values}

  # Verify dependencies.
  [[ ${_BFL_HAS_GREP} -eq 1 ]] || bfl::die "dependency 'grep' not found" ${BFL_ErrCode_Not_verified_dependency}

  # Declare positional arguments (readonly, sorted by position).
  local -r sites_enabled="${2:-"/etc/apache2/sites-enabled"}"

  # Declare all other variables (sorted by name).
  local canonical_sites_enabled

  # Get canonical paths.
  canonical_path=$(bfl::get_directory_path "$1") || bfl::die "Unable to determine canonical path to '$1'."
  canonical_sites_enabled=$(bfl::get_directory_path "${sites_enabled}") || bfl::die "Unable to determine canonical path to ${sites_enabled}."

  grep -q -P -R -m1 \
    "DocumentRoot\\s+${canonical_path}$" \
    "${canonical_sites_enabled}"
  }