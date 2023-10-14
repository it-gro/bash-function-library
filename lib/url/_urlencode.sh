#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ /bash_functions_library ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
# ------------- https://github.com/jmooring/bash-function-library -------------
# ----------------- https://github.com/ariver/bash_functions ------------------
#
# Library of functions related to the internet
#
# @author  Joe Mooring, Nathaniel Landau, A. River
#
# @file
# Defines function: bfl::urlencode().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
# Percent-encodes a URL.
#
# See <https://tools.ietf.org/html/rfc3986#section-2.1>.
#
# @param string $str
#   The string to be encoded.
#
# @return string $Rslt
#   The encoded string.
#
# @example
#   bfl::urlencode "foo bar"
#------------------------------------------------------------------------------
bfl::urlencode() {
  # Verify argument count.
  [[ $# -eq 1 ]] || bfl::die "arguments count $# ≠ 1" ${BFL_ErrCode_Not_verified_args_count}

  # Verify argument values.
  bfl::is_blank "$1" && bfl::die "String is empty or blank!"

  local Rslt
  if [[ ${_BFL_HAS_JQ} -eq 1 ]]; then
      Rslt=$(jq -Rr @uri <<< "$1") || bfl::die "jq -Rr @uri <<< '$1'"
  else
# ----------------- https://github.com/ariver/bash_functions ------------------
      local {h,tab,str,old}=
      printf -v tab "\t"
      #declare LC_ALL="${LC_ALL:-C}"

      old="${*}"  # printf "\n: old : %5d : %s\n" "${#old}" "${old}" 1>&2

      local -i i=0
      local -i k=${#old}
      for ((i=0; i < k; i++)); do
          str="${old:$i:1}"
          case "$str" in
              " " )                         printf -v h "+" ;;
              [-=\+\&_.~a-zA-Z0-9:/\?\#] )  printf -v h %s "$str" ;;
              * )                           printf -v h "%%%02X" "'$str" ;;
          esac
          Rslt+="$h"
      done
# ---------- https://github.com/natelandau/shell-scripting-templates ----------
#    for ((i = 0; i < ${#1}; i++)); do
#        if [[ ${1:i:1} =~ ^[a-zA-Z0-9\.\~_-]$ ]]; then
#            printf "%s" "${1:i:1}"
#        else
#            printf '%%%02X' "'${1:i:1}"
#        fi
#    done
  fi

  # Print the return value.
  printf "%s\\n" "${Rslt}"
  }

bfl::encode_url() { bfl::urlencode "$@"; return $?; }