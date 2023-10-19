#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ------------- https://github.com/jmooring/bash-function-library -------------
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
#   Prints an error message to stderr.
#
# The message provided will be prepended with "Error. "
#
# @param String $msg (optional)
#   The message.
#
# @example
#   bfl::error "The foo is bar."
#------------------------------------------------------------------------------
bfl::error() {
  local writelog=false
  if ! [[ ${BASH_LOG_LEVEL} -lt ${_BFL_LOG_LEVEL_ERROR} ]]; then
      [[ -n "$BASH_FUNCTIONS_LOG" ]] && [[ -f "$BASH_FUNCTIONS_LOG" ]] && writelog=true
  fi

  # Сама функция возвращает 0 - смысла нет оперировать кодом ошибки, из-за замены  exit 1 => return 1
  [[ $BASH_INTERACTIVE == true ]] || [[ $writelog == true ]] || return 0

  # Verify arguments count.
  [[ $# -eq 1 ]] || { bfl::error "arguments count $# ≠ 1."; return ${BFL_ErrCode_Not_verified_args_count}; }

  # Build a string showing the "stack" of functions that got us here.
  local stack="${FUNCNAME[*]}"
  stack="${stack// / <- }"

  # Declare positional argument (readonly).
  local msg="$1"
  [[ -z "$1" ]] && msg="Unspecified error."

  # shellcheck disable=SC2154
  if [[ $writelog == true ]]; then # writes message and stack.
      bfl::write_log_error "Error. ${msg}"
      bfl::write_log_error "[${stack}]"
      (( $#>= 0 && $#<= 1 )) || bfl::write_log_error "arguments count $# ∉ [0..1]."
  elif [[ $BASH_INTERACTIVE == true ]]; then # prints message and stack.
      printf "%b\\n" "${CLR_BAD}Error. ${msg}${NC}" 1>&2
      printf "%b\\n" "${Yellow}[${stack}]${NC}" 1>&2
      (( $#>= 0 && $#<= 1 )) || printf "%b\\n" "${CLR_BAD}arguments count $# ∉ [0..1].${NC}" 1>&2
  fi
  }