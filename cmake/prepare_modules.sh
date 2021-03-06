#!/bin/bash

###############################################################################
# Configuration

# Github repo URLs for each module, by name
# Either https://github.com/ or git@github.com: will be prefixed
REPO_LOCATIONS=$(cat<<EOF
  annlib            dials/annlib.git
  annlib_adaptbx    dials/annlib_adaptbx.git
  cbflib            yayahjb/cbflib.git
  ccp4io            dials/ccp4io.git
  ccp4io_adaptbx    dials/ccp4io_adaptbx.git
  cctbx_project     cctbx/cctbx_project.git
  clipper 	        dials/clipper.git
  cmake             ndevenish/tbxcmake.git
  dials             dials/dials.git
  gui_resources     dials/gui_resources.git
  tntbx             dials/tntbx.git
  xia2              xia2/xia2.git
EOF
)

###############################################################################

set -e

# Later, we will allow setting to the SSH version via command argument
GITHUB_PREFIX="https://github.com/"

# Check for git
if [[ -z "$(command -v git)" ]]; then
  echo "Error: No git command found. Make sure git is accessible on your PATH"
  exit 1
fi

# # Check for Python
# if [[ -z "$(command -v python)" ]]; then
#   echo "Error: No python interpreter found"
# fi


# Finds the checkout repository URL given a module name
# Usage: get_repo <module_name>
# Prints the URL of the module, if there is any. Exits if more than one
# result is found for a particular module name.
get_repo() {
  if [[ -z "$1" ]]; then
    return 1
  fi
  lookup=$(echo "$REPO_LOCATIONS" | grep -E "^\\s+$1\\s" | awk '{ print $2; }')
  if [[ $(echo "$lookup" | wc -l) -gt 1 ]]; then
    echo "Error: More than one repository found for \"$1\": $lookup"
    exit 1
  fi
  echo $lookup
}

all_repo_names() {
  echo "$REPO_LOCATIONS" | awk '{ print $1; }'
}

get_longest_len() {
  length=0
  for string in $*; do
    if [[ ${#string} -gt $length ]]; then
      length=${#string}
    fi
  done
  echo $length
}

get_commit_id() {
  ( cd $1
    git rev-parse HEAD )
}

# Only enable coloured output when we aren't a terminal
if tty -s; then
  BOLD=$(tput bold)
  DIM="\e[90m"
  GREEN="\e[32m"
  NC=$(tput sgr0)
fi

# Work out the longest name for nice formatting
longest_mod_name=$(get_longest_len $(all_repo_names))

echo "Fetching distribution modules:"
for repo_name in $(all_repo_names); do
  if [[ -d $repo_name ]]; then
    COMMIT_ID=$(get_commit_id $repo_name)
    printf "$BOLD%-${longest_mod_name}s$NC at ${COMMIT_ID}, skipping.\n" "$repo_name"
    # printf "$BOLD%-${longest_mod_name}s$NC already exists, skipping.\n" "$repo_name"
  else
    printf "== Cloning $BOLD$repo_name$NC ========\n$DIM"
    git clone $GITHUB_PREFIX$(get_repo $repo_name) $repo_name
    printf "$NC"
    COMMIT_ID=$(get_commit_id $repo_name)
    printf "$BOLD%-${longest_mod_name}s$NC at commit ${COMMIT_ID}.\n" "$repo_name"
  fi
done

if [[ ! -e "CMakeLists.txt" ]]; then
  # printf "== Linking ${BOLD}CMakeLists.txt$NC from ${BOLD}cmake$NC directory ==\n"
  printf "${BOLD}CMakeLists.txt${NC}.. ${GREEN}creating${NC}\n"
  ln -s cmake/CMakeLists.txt
else
  printf "${BOLD}CMakeLists.txt${NC}.. exists\n"
fi
