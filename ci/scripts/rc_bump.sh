#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail

SEMVER_REGEX="^(0|[1-9][0-9]*)\\.(0|[1-9][0-9]*)\\.(0|[1-9][0-9]*)(\\-[0-9A-Za-z-]+(\\.[0-9A-Za-z-]+)*)?(\\+[0-9A-Za-z-]+(\\.[0-9A-Za-z-]+)*)?$"

PROG=rc_bump
PROG_VERSION=1.0.0

USAGE="\
This will bump the rc (release canidate) version. aka 1.0.0-rc.0 becomes 1.0.0-rc.1

Usage:
  $PROG <version>

Arguments:
  <version>  A version must match the following regex pattern:
             \"${SEMVER_REGEX}\".
             In english, the version must match X.Y.Z(-PRERELEASE)(+BUILD)
             where X, Y and Z are positive integers, PRERELEASE is an optionnal
             string composed of alphanumeric characters and hyphens and
             BUILD is also an optional string composed of alphanumeric
             characters and hyphens.
"

function error {
  echo -e "$1" >&2
  exit 1
}

function usage-help {
  error "$USAGE"
}

function usage-version {
  echo -e "${PROG}: $PROG_VERSION"
  exit 0
}

function validate-version {
  local version=$1
  if [[ "$version" =~ $SEMVER_REGEX ]]; then
    # if a second argument is passed, store the result in var named by $2
    if [ "$#" -eq "2" ]; then
      local major=${BASH_REMATCH[1]}
      local minor=${BASH_REMATCH[2]}
      local patch=${BASH_REMATCH[3]}
      local prere=${BASH_REMATCH[4]}
      local build=${BASH_REMATCH[6]}
      eval "$2=(\"$major\" \"$minor\" \"$patch\" \"$prere\" \"$build\")"
    else
      echo "$version"
    fi
  else
    error "version $version does not match the semver scheme 'X.Y.Z(-PRERELEASE)(+BUILD)'. See help for more information."
  fi
}

function command-bump {
  local new; local version; local sub_version; local command;

  version=$1

  validate-version "$version" parts
  # shellcheck disable=SC2154
  local major="${parts[0]}"
  local minor="${parts[1]}"
  local patch="${parts[2]}"
  local prere="${parts[3]}"
  local build="${parts[4]}"

  if [[ "$prere" =~ \-rc\.(0|[1-9][0-9]*)$ ]]; then
    if [[ "$#" -eq "1" ]]; then
      local update=$((BASH_REMATCH[1]+1))
      new=$(validate-version "${major}.${minor}.${patch}-rc.${update}")
    else
      echo "$version"
    fi
  elif [[ !(-z $prere) || !(-z $build) ]]; then
    error "don't know how to upgrade ($prere) or ($build)"
  else
    new=$(validate-version "${major}.${minor}.${patch}-rc.0")
  fi

  echo "$new"
  exit 0
}

case $# in
  0) echo "Unknown command: $*"; usage-help;;
esac

case $1 in
  --help|-h) echo -e "$USAGE"; exit 0;;
  --version|-v) usage-version ;;
  *) command-bump $*;;
esac
