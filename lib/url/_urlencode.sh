#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
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
      local -i i=0
      local -i k=${#1}
      local {str,s}="$1"
      while ((i < k)); do
          if ((k==i+1)); then
              s="${1: -1}"
              [[ "$s" =~ ^[a-zA-Z0-9\.\~_-]$ ]] && printf "%s" "$s" || printf '%%%02X' "$s"
              i+=1
          else
              s=${s%[^a-zA-Z0-9\.\~_-]*}
              if [[ -n "$s" ]]; then
                  printf "%s" "$s"
                  i+=${#s}
              else  # per 1 symbol. слева одинарная кавычка очень важна
                  printf '%%%02X' "'${str:i:1}"
                  i+=1
              fi
              s="${str:i}"
          fi
      done  
# ---------- https://github.com/natelandau/shell-scripting-templates ----------
#      More compact, but per 1 symbol
#      for ((i = 0; i < ${#1}; i++)); do
#          str="${1:i:1}"
#          if [[ $str =~ ^[a-zA-Z0-9\.\~_-]$ ]]; then
#              printf "%s" "$str"
#          else               # слева одинарная кавычка очень важна
#              printf '%%%02X' "'$str"
#          fi
#      done
# ----------------- https://github.com/ariver/bash_functions ------------------
#      I have doubt about result
#      local {h,tab,str,old}=
#      printf -v tab "\t"
#      #declare LC_ALL="${LC_ALL:-C}"
#
#      old="${*}"  # printf "\n: old : %5d : %s\n" "${#old}" "${old}" 1>&2
#
#      local -i k=${#old}
#      for ((i=0; i < k; i++)); do
#          str="${old:$i:1}"
#          case "$str" in
#              " " )                         printf -v h "+" ;;
#              [-=\+\&_.~a-zA-Z0-9:/\?\#] )  printf -v h %s "$str" ;;
#              * )                           printf -v h "%%%02X" "'$str" ;;
#          esac
#          Rslt+="$h"
#      done
  fi

  # Print the return value.
#  printf "%s\\n" "${Rslt}"
  printf "\\n"  # для удобства в терминале, результирующую строку не увеличивает
  }

bfl::encode_url() { bfl::urlencode "$@"; return $?; }
