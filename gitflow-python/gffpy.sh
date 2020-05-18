#!/bin/bash

# git-flow for python

MASTER_BRANCH='master'
DEVELOP_BRANCH='develop'
PREFIX_HOTFIX='hotfix'
PREFIX_FEATURE='feature'
PREFIX_RELEASE='release'

PATCH_VERSION='patch'
MINOR_VERSION='minor'
MAJOR_VERSION='major'

COMMAND_COMMIT='-c'
COMMAND_INIT='-i'
COMMAND_HELP='-h'
COMMAND_TESTING='-t'
COMMAND_START_FEATURE='-fs'
COMMAND_FINISH_FEATURE='-ff'
COMMAND_START_RELEASE='-rs'
COMMAND_FINISH_RELEASE='-rf'
COMMAND_START_HOTFIX='-hs'
COMMAND_FINISH_HOTFIX='-hf'
COMMAND_ABORT_BRANCH='-a'

setup_color() {
	if [ -t 1 ]; then
		RESET=$(printf '\033[0m')
		BOLD=$(printf '\033[1m')
    UNDERLINE=$(printf '\033[4m')
    REVERSED=$(printf '\033[7m')
    BLACK=$(printf '\033[30m')
		RED=$(printf '\033[31m')
		GREEN=$(printf '\033[32m')
		YELLOW=$(printf '\033[33m')
		BLUE=$(printf '\033[34m')
    MAGENTA=$(printf '\033[35m')
    CYAN=$(printf '\033[36m')
    WHITE=$(printf '\033[37m')
    BACKGROUND_BLACK=$(printf '\033[37;40m')
    BACKGROUND_RED=$(printf '\033[30;41m')
    BACKGROUND_GREEN=$(printf '\033[30;42m')
    BACKGROUND_YELLOW=$(printf '\033[30;43m')
    BACKGROUND_BLUE=$(printf '\033[30;44m')
    BACKGROUND_MAGENTA=$(printf '\033[30;45m')
    BACKGROUND_CYAN=$(printf '\033[30;46m')
    BACKGROUND_WHITE=$(printf '\033[30;47m')
	else
		RESET=""
		BOLD=""
    UNDERLINE=""
    REVERSED=""
    BLACK=""
		RED=""
		GREEN=""
		YELLOW=""
		BLUE=""
    MAGENTA=""
    CYAN=""
    WHITE=""
    BACKGROUND_BLACK=""
    BACKGROUND_RED=""
    BACKGROUND_GREEN=""
    BACKGROUND_YELLOW=""
    BACKGROUND_BLUE=""
    BACKGROUND_MAGENTA=""
    BACKGROUND_CYAN=""
    BACKGROUND_WHITE=""
	fi
}

command_exists() {
	command -v "$@" >/dev/null 2>&1
}

error() {
	echo ${RED}"Error: $@"${RESET} >&2
}

get_current_hash() {
  echo $(git rev-parse HEAD)
}

get_current_hash_short() {
  echo $(git rev-parse --short HEAD)
}

get_current_tag() {
  echo $(git describe)
}

get_current_branch() {
  echo $(git symbolic-ref --short HEAD)
}

get_current_version() {
  current_version=$(head -n 1 __version__.py | cut -d '=' -f 2 | xargs)
  echo "current version is: $current_version"
}

get_commit_parent() {
  local PARENT_BRANCH=$1
  local CHILDREN_BRANCH=$2
  echo $(git merge-base $PARENT_BRANCH $CHILDREN_BRANCH)
}

delete_tag() {
  local TAG=$1
  echo " ${BACKGROUND_YELLOW} DELETE TAG DISABLE: '${TAG}' ${RESET} "
  git tag --delete $TAG
  git push --delete origin $TAG
}

delete_branch() {
  local BRANCH=$1
  echo " ${BACKGROUND_YELLOW} DELETE BRANCH DISABLE: '${BRANCH}' ${RESET} "
  git branch --delete $BRANCH
  git push origin --delete $BRANCH
}

publish_branch() {
  local BRANCH=$1
  echo " ${BACKGROUND_YELLOW} PUBLIC BRANCH DISABLE: '${BRANCH}' ${RESET} "
  git push origin $BRANCH
}

publish_tags() {
  echo " ${BACKGROUND_YELLOW} PUBLIC TAGS DISABLE ${RESET} "
  git push origin --tags
}

create_tag() {
  local TAGNAME=$1
  git tag --sign $TAGNAME --message "v${TAGNAME}"
}

go() {
  local BRANCH=$1
  git checkout $BRANCH
}

create_branch() {
  local NEW_BRANCH=$1
  git checkout -b $NEW_BRANCH
}

clone_branch() {
  local ORIGIN_BRANCH=$1
  local NEW_BRANCH=$2
  go $ORIGIN_BRANCH
  create_branch $NEW_BRANCH
}

fast_commit() {
  git add --all && git commit  --no-edit
}

commit() {
  local MESSAGE=$1
  if [ -z "$MESSAGE" ]; then
    git add --all && git commit 
  else
    git add --all && git commit --message "$MESSAGE"
  fi
}

merge() {
  local ORIGIN=$1
  local DESTINATION=$2
  git checkout $DESTINATION && git merge --no-ff --no-edit --no-commit -m "Automatic merge from $ORIGIN to $DESTINATION" $ORIGIN
}

update_pkg_version() {
  local NEW_VERSION=$1
  bumpversion $NEW_VERSION
}

init_git() {
  git init
}

init_project() {
  local CURRENT_VERSION=$(get_current_version)
  init_git
  commit "Init commit"
  create_tag $CURRENT_VERSION
  create_branch $DEVELOP_BRANCH
}

ask_branch_name() {
  local INPUT=$1
  if [ -z "$INPUT" ]; then
    echo -n "${BLUE}What name will the branch have?: ${RESET}"; read INPUT
    if [[ "$INPUT" == "" ]]; then
      echo "${YELLOW}Invalid input${RESET}"; exit 1
    fi
  fi
  BRANCH_NAME=${INPUT// /_}
}

ask_version() {
  echo -n "${BLUE}What is the release level? [major or minor]: ${RESET}"; read INPUT
  case $INPUT in
      [mM][aA][jJ][oO][rR] ) VERSION=$MAJOR_VERSION ;;
      [mM][iI][nN][oO][rR] ) VERSION=$MINOR_VERSION ;;
      *) echo "Invalid input"; exit 1 ;;
  esac
}

control_branch() {
  local BRANCH=$1
  if [[ "$BRANCH" == "$MASTER_BRANCH" || "$BRANCH" == "$DEVELOP_BRANCH" ]]; then
    echo "${YELLOW}Aborted process since you are in '${BRANCH}'${RESET}"; exit 1
  fi
}

validate_branch() {
  local CURRENT_BRANCH=$1
  control_branch $CURRENT_BRANCH
  echo -n "${BLUE}Current branch '${CURRENT_BRANCH}', do you wish to continue? [yes or no]: ${RESET}"; read INPUT
  case $INPUT in
    [yY] | [yY][eE][sS] ) ;;
    [nN] | [nN][oO] ) echo "Aborted process"; exit 1 ;;
    *) echo "${YELLOW}Invalid input${RESET}"; exit 1 ;;
  esac
}

testing() {
  echo "${BACKGROUND_MAGENTA} TESTING ${RESET}"
  local CURRENT_HASH_SHORT=$(get_current_hash_short)
  local TAG="t-${CURRENT_HASH_SHORT}"
  echo "${GREEN}TAG: ${TAG}${RESET}"
  create_tag $TAG
}

start_new_feature() {
  echo "${BACKGROUND_BLUE} START FEATURE ${RESET}"
  ask_branch_name "$1"
  clone_branch $DEVELOP_BRANCH "$PREFIX_FEATURE/$BRANCH_NAME"
  get_current_version && update_pkg_version $PATCH_VERSION
}

finish_feature() {
  echo "${BACKGROUND_BLUE} FINISH FEATURE ${RESET}"
  local CURRENT_BRANCH=$(get_current_branch) && validate_branch $CURRENT_BRANCH && merge $CURRENT_BRANCH $DEVELOP_BRANCH && fast_commit
  publish_branch $DEVELOP_BRANCH
  delete_branch $CURRENT_BRANCH
}

start_new_release() {
  echo "${BACKGROUND_GREEN} START RELEASE ${RESET}"
  ask_branch_name "$1"
  clone_branch $DEVELOP_BRANCH "$PREFIX_RELEASE/$BRANCH_NAME"
  testing
  get_current_version && ask_version && update_pkg_version $VERSION
}

finish_release() {
  echo "${BACKGROUND_GREEN} FINISH RELEASE ${RESET}"
  local CURRENT_BRANCH=$(get_current_branch) && validate_branch $CURRENT_BRANCH && merge $CURRENT_BRANCH $MASTER_BRANCH && fast_commit
  local CURRENT_VERSION=$(get_current_version) && fast_commit && create_tag $CURRENT_VERSION
  local CURRENT_TAG=$(get_current_tag) && merge $CURRENT_TAG $DEVELOP_BRANCH && fast_commit
  publish_branch $MASTER_BRANCH
  publish_branch $DEVELOP_BRANCH
  delete_branch $CURRENT_BRANCH
}

start_new_hotfix() {
  echo "${BACKGROUND_YELLOW} START HOTFIX ${RESET}"
  ask_branch_name "$1"
  clone_branch $MASTER_BRANCH "$PREFIX_HOTFIX/$BRANCH_NAME"
  testing
  get_current_version && ask_version && update_pkg_version $VERSION
}

finish_hotfix() {
  echo "${BACKGROUND_YELLOW} FINISH HOTFIX ${RESET}"
  local CURRENT_BRANCH=$(get_current_branch) && validate_branch $CURRENT_BRANCH && merge $CURRENT_BRANCH $MASTER_BRANCH && fast_commit
  local CURRENT_VERSION=$(get_current_version) && fast_commit && create_tag $CURRENT_VERSION
  local CURRENT_TAG=$(get_current_tag) && merge $CURRENT_TAG $DEVELOP_BRANCH && fast_commit
  publish_branch $MASTER_BRANCH
  publish_branch $DEVELOP_BRANCH
  delete_branch $CURRENT_BRANCH
}

abort_branch() {
  echo "${BACKGROUND_YELLOW} ABORT BRANCH ${RESET}"
  local CURRENT_BRANCH=$(get_current_branch)
  local CURRENT_HASH=$(get_current_hash)
  get_commit_parent $DEVELOP_BRANCH $CURRENT_BRANCH
  echo $CURRENT_HASH
}

show_help() {
  echo -e "usage: ${0} <option>\n"
  printf "$MAGENTA"
  echo -e "Tag Testing options"
  printf "$RESET"
  echo -e "  ${COMMAND_TESTING}\t create a tag to test"
  printf "$BLUE"
  echo -e "Tag Feature options"
  printf "$RESET"
  echo -e "  ${COMMAND_START_FEATURE}\t start a feature"
  echo -e "  ${COMMAND_FINISH_FEATURE}\t finish a feature"
  printf "$GREEN"
  echo -e "Tag Release options"
  printf "$RESET"
  echo -e "  ${COMMAND_START_RELEASE}\t start a release"
  echo -e "  ${COMMAND_ABORT_RELEASE}\t abort a release"
  echo -e "  ${COMMAND_FINISH_RELEASE}\t finish a release"
  printf "$YELLOW"
  echo -e "Tag Hotfix options"
  printf "$RESET"
  echo -e "  ${COMMAND_START_HOTFIX}\t start a hotfix"
  echo -e "  ${COMMAND_FINISH_HOTFIX}\t finish a hotfix"
}

main () {
  setup_color
  command_exists bumpversion || {
    error "bumpversion is not installed, please install with command 'pip/pip3 install --upgrade bumpversion'"
    exit 1
	}
  case "$1" in
    $COMMAND_COMMIT ) commit "$2";;
    $COMMAND_INIT ) init_project ;;
    $COMMAND_HELP ) show_help ;;
    $COMMAND_TESTING ) testing ;;
    $COMMAND_START_FEATURE ) start_new_feature "$2";;
    $COMMAND_FINISH_FEATURE ) finish_feature ;;
    $COMMAND_START_RELEASE ) start_new_release "$2";;
    $COMMAND_FINISH_RELEASE ) finish_release ;;
    $COMMAND_START_HOTFIX ) start_new_hotfix "$2";;
    $COMMAND_FINISH_HOTFIX ) finish_hotfix ;;
    $COMMAND_ABORT_BRANCH ) abort_branch ;;
    *) show_help ;;
  esac
}

main "$@"