#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ------------- https://github.com/jmooring/bash-function-library -------------
#
# Library of functions related to sms
#
# @author  Joe Mooring
#
# @file
# Defines function: bfl::send_sms_msg().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
# Sends an SMS message via Amazon Simple Notification Service (SNS).
#
# @param string $phone_number
#   Recipient's phone number, including country code.
# @param string $message
#   Example: "This is line one.\\nThis is line two.\\n"
#
# @example
#   bfl::send_sms_msg "+12065550100" "Line 1.\\nLine 2."
#------------------------------------------------------------------------------
bfl::send_sms_msg() {
  # Verify arguments count.
  [[ $# -eq 2 ]] || bfl::die "arguments count $# ≠ 2." ${BFL_ErrCode_Not_verified_args_count}

  # Verify arguments' values.
  bfl::is_blank "$1" && bfl::die "The recipient's phone number is required." ${BFL_ErrCode_Not_verified_arg_values}
  bfl::is_blank "$2" && bfl::die "The message is required." ${BFL_ErrCode_Not_verified_arg_values}

  # Verify dependencies.
  [[ ${_BFL_HAS_AWS} -eq 1 ]] || bfl::die "dependency 'aws' not found" ${BFL_ErrCode_Not_verified_dependency}

  declare -r phone_number="$1"
  declare -r message="$2"
  declare -r phone_number_regex="^\\+[0-9]{6,}$"

  # Make sure phone number is properly formatted.
  if ! [[ "${phone_number}" =~ ${phone_number_regex} ]]; then
      local error_msg
      error_msg="The recipient's phone number is improperly formatted.\\n"
      error_msg+="Expected a plus sign followed by six or more digits, received ${phone_number}."
      bfl::die "${error_msg}"
  fi

  # Backslash escapes such as \n (newline) in the message string must be
  # interpreted before sending the message.
  interpreted_message=$(printf "%b" "${message}") || bfl::die "printf '%b' ${message}"

  # Send the message.
  aws sns publish --phone-number "${phone_number}" --message "${interpreted_message}" \
      || bfl::die "aws sns publish --phone-number '${phone_number}' --message '${interpreted_message}'"
  }
