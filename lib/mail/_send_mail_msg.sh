#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ /bash_functions_library ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ----------- https://github.com/jmooring/bash-function-library.git -----------
#
# Library of email functions
#
# @author  Joe Mooring
#
# @file
# Defines function: bfl::send_mail_msg().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
# Sends an email message via sendmail.
#
# @param string $to
#   Message recipient or recipients.
#   Examples:
#   - foo@example.com
#   - foo@example.com, bar@example.com
#   - Foo <foo@example.com>
#   - Foo <foo@example.com>, Bar <bar@example.com>
# @param string $from
#   Message sender.
#   Examples:
#   - foo@example.
#   - Foo <foo@example.com>
# @param string $envelope_from
#   Envelope sender address.
#   Example: foo@example.com
# @param string $subject
#   Message subject.
# @param string $body
#   Message body.
#   Example: "This is line one.\\nThis is line two.\\n"
#
# @example
#   bfl::send_mail_msg "a@b.com" "x@y.com" "x@y.com" "Test" "Line 1.\\nLine 2."
#------------------------------------------------------------------------------
bfl::send_mail_msg() {
  # Verify arguments count.
  [[ $# -eq 5 ]] || bfl::die "arguments count $# ≠ 5" ${BFL_ErrCode_Not_verified_args_count}

  # Verify arguments
  bfl::is_blank "$1" && bfl::die "The message recipient is required."
  bfl::is_blank "$2" && bfl::die "The message sender is required."
  bfl::is_blank "$3" && bfl::die "The envelope sender address is required."
  bfl::is_blank "$4" && bfl::die "The message subject is required."
  bfl::is_blank "$5" && bfl::die "The message body is required."

  # Verify dependencies.
  [[ ${_BFL_HAS_SENDMAIL} -eq 1 ]] || bfl::die "dependency 'sendmail' not found." ${BFL_ErrCode_Not_verified_dependency}

  local message # Format the message.                       to  from subject body
  message=$(printf "To: %s\\nFrom: %s\\nSubject: %s\\n\\n%b" "$1" "$2"   "$4"  "$5") \
    || bfl::die "printf mail body" $?

  # Send the message   envelope_from  to
  echo "$message" | sendmail -f "$3" "$1" || bfl::die "cannot send mail from '$3' to '$1'." $?
  }