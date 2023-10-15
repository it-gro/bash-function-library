#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ----------- https://github.com/jmooring/bash-function-library.git -----------
#
# Library of functions related to Lorem
#
# @author  Joe Mooring
#
# @file
# Defines function: bfl::lorem().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
# Randomly extracts one or more sequential paragraphs from a given resource.
#
# The resources are located in the resources/lorem directory. Each resource
# contains one paragraph per line. The resources were created from books
# downloaded from Project Gutenberg (https://www.gutenberg.org), and then
# edited to remove:
#
#   1) Front matter
#   2) Back matter
#   3) Footnotes
#   4) Cross references
#   5) Captions
#   6) Any paragraph less than or equal to 200 characters.
#
# @param int $paragraphs (optional)
#   The number of paragraphs to extract (default: 1).
# @param string $resource (optional)
#   The resource from which to extract the paragraphs (default: muir).
#   Valid resources:
#   - burroughs (The Breath of Life by John Burroughs)
#   - darwin (The Origin of Species by Charles Darwin)
#   - hugo (Les Miserables by Victor Hugo)
#   - mills (The Rocky Mountain Wonderland by Enos Mills)
#   - muir (Our National Parks by John Muir)
#   - virgil (The Aeneid by Virgil)
#
# @return string $text
#   The extracted paragraphs.
#
# @example
#   bfl::lorem
# @example
#   bfl::lorem 2
# @example
#   bfl::lorem 3 burroughs
# @example
#   bfl::lorem 3 darwin
# @example
#   bfl::lorem 3 mills
# @example
#   bfl::lorem 3 muir
# @example
#   bfl::lorem 3 virgil
#------------------------------------------------------------------------------
bfl::lorem() {
  # Verify arguments count.
  (( $#>=0 && $#<= 2 )) || bfl::die "arguments count $# ∉ [0..2]." ${BFL_ErrCode_Not_verified_args_count}

  # Verify argument values.
  local -r paragraphs="${1:-1}"
  bfl::is_positive_integer "${paragraphs}" || bfl::die "'$1' expected to be a positive integer."

  local -r resource="${2:-muir}"

  # Verify dependencies.
  [[ ${_BFL_HAS_SED}  -eq 1 ]] || bfl::die "dependency 'sed' not found"  ${BFL_ErrCode_Not_verified_dependency}
  [[ ${_BFL_HAS_AWK}  -eq 1 ]] || bfl::die "dependency 'awk' not found"  ${BFL_ErrCode_Not_verified_dependency}
  [[ ${_BFL_HAS_SHUF} -eq 1 ]] || bfl::die "dependency 'shuf' not found" ${BFL_ErrCode_Not_verified_dependency}

  # Declare positional arguments (readonly, sorted by position).

  # Declare all other variables (sorted by name).
  local first_paragraph_number
  local last_paragraph_number
  local maximum_first_paragraph_number
  local msg
  local resource_directory
  local resource_file
  local resource_paragraph_count

  # Set the resource directory path.
  resource_directory=$(dirname "${BASH_FUNCTION_LIBRARY}")/resources/lorem ||
    bfl::die "Unable to determine resource directory." $?

  # Select the resource file from which to extract paragraphs.
  case "${resource}" in
    "burroughs" )
      resource_file=${resource_directory}/the-breath-of-life-by-john-burroughs.txt
      ;;
    "darwin" )
      resource_file=${resource_directory}/the-origin-of-species-by-charles-darwin.txt
      ;;
    "hugo" )
      resource_file=${resource_directory}/les-miserables-by-victor-hugo.txt
      ;;
    "mills" )
      resource_file=${resource_directory}/the-rocky-mountain-wonderland-by-enos-mills.txt
      ;;
    "muir" )
      resource_file=${resource_directory}/our-national-parks-by-john-muir.txt
      ;;
    "virgil" )
      resource_file=${resource_directory}/the-aeneid-by-virgil.txt
      ;;
    * )
      bfl::die "Unknown resource."
      ;;
  esac

  # Determine number of paragraphs in the resource file (assumes one per line).
  resource_paragraph_count=$(wc -l < "${resource_file}") ||
    bfl::die "Unable to determine number of paragraphs in source file." $?

  # Make sure number of requested paragraphs does not exceed maximum.
  if [[ "${paragraphs}" -gt "${resource_paragraph_count}" ]]; then
    msg=$(cat <<EOT
The number of paragraphs requested (${paragraphs}) exceeds
the number of paragraphs available (${resource_paragraph_count}) in the specified
resource (${resource}).
EOT
    )
    bfl::die "${msg}"
  fi

  # Determine the highest paragraph number from which we can begin extraction.
  maximum_first_paragraph_number=$((resource_paragraph_count - paragraphs + 1))

  # Determine the range of paragraphs to extract.
  first_paragraph_number=$(shuf -i 1-"${maximum_first_paragraph_number}" -n 1) ||
    bfl::die "Unable to generate random paragraph number." $?
  last_paragraph_number=$((first_paragraph_number + paragraphs - 1))

  # Declare return value.
  local text

  # Extract sequential paragraphs.
  text=$(sed -n "${first_paragraph_number}","${last_paragraph_number}"p "${resource_file}") ||
    bfl::die "Unable to extract paragraphs." $?
  # Add a blank line between each paragraph to create proper markdown.
  text=$(awk '{print $0"\n"}' <<< "${text}") ||
    bfl::die "Unable to add additional newline to each paragraph." $?

  # Print the return value.
  printf "%s" "${text}"
  }
