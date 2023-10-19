#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# --------- https://github.com/AlexeiKharchev/bash_functions_library ----------
#
# Library of internal library functions
#
# @author  Alexei Kharchev
#
# @file
# Defines function: bfl::debug_msg().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Prints a debug message to stderr.
#
# The message provided will be prepended with "Debug message. "
#
# @param String $msg (optional)
#   The message.
#
# @example
#   bfl::debug_msg "The foo is bar."
#------------------------------------------------------------------------------
bfl::debug_msg() {
  local writelog=false
  if ! [[ ${BASH_LOG_LEVEL} -lt ${_BFL_LOG_LEVEL_DEBUG} ]]; then
      [[ -n "$BASH_FUNCTIONS_LOG" ]] && [[ -f "$BASH_FUNCTIONS_LOG" ]] && writelog=true
  fi

  # Сама функция возвращает 0 - смысла нет оперировать кодом ошибки, из-за замены  exit 1 => return 1
  [[ $BASH_INTERACTIVE == true ]] || [[ $writelog == true ]] || return 0

  # Verify arguments count.
  (( $#>= 0 && $#<= 1 )) || { bfl::error "arguments count $# ∉ [0..1]."; return ${BFL_ErrCode_Not_verified_args_count}; }

  # Build a string showing the "stack" of functions that got us here.
  local stack="${FUNCNAME[*]}"
  stack="${stack// / <- }"

  # Declare positional argument (readonly).
  local msg="$1"
  [[ -z "$1" ]] && msg="Debug message."

  # shellcheck disable=SC2154
  if [[ $writelog == true ]]; then # writes message and stack.
      bfl::write_log_debug "Debug message: ${msg}"
      bfl::write_log_debug "[${stack}]"
      (( $#>= 0 && $#<= 1 )) || bfl::write_log_error "arguments count $# ∉ [0..1]."
  elif [[ $BASH_INTERACTIVE == true ]]; then # prints message and stack.
      printf "%b\\n" "${CLR_DEBUG}Debug message. ${msg}${NC}" 1>&2
      printf "%b\\n" "${CLR_DEBUG}[${stack}]${NC}" 1>&2
      (( $#>= 0 && $#<= 1 )) || printf "%b\\n" "${CLR_BAD}arguments count $# ∉ [0..1].${NC}" 1>&2
  fi
  }