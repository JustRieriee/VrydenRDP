#!/bin/bash

set -e


SCRIPT_VERSION="v2.1"
GITHUB_BASE_URL="https://github.com/JustRieriee/VrydenRDP"

LOG_PATH="/var/log/RDPXcript.log"
# exit with error status code if user is not root
if [[ $EUID -ne 0 ]]; then
  echo "* This Script Must Be Executed With Root Privileges ( Sudo )." 1>&2
  exit 1
fi

# check for curl
if ! [ -x "$(command -v curl)" ]; then
  echo "* Curl Is Required In Order For This Script To Work."
  echo "* Install Using Apt ( Debian And Derivatives ) Or Yum / Dnf ( CentOS )"
  exit 1
fi

output() {
  echo -e "\033[0;34m[RDPXcript] ${1} \033[0m"
}

error() {
  COLOR_RED='\033[0;31m'
  COLOR_NC='\033[0m'
  

  echo ""
  echo -e "* ${COLOR_RED}ERROR${COLOR_NC}: $1"
  echo ""
}

cat << "EOF" 
  _   __            __         ___  ___  ___ 
 | | / /_____ _____/ /__ ___  / _ \/ _ \/ _ \
 | |/ / __/ // / _  / -_) _ \/ , _/ // / ___/
 |___/_/  \_, /\_,_/\__/_//_/_/|_/____/_/    
         /___/                                       
EOF
                                                       
execute() {
  echo -e "\n\n* VrydenRDP $(date) \n\n" >>$LOG_PATH

  bash <(curl -s "$1") | tee -a $LOG_PATH
  [[ -n $2 ]] && execute "$2"
}

done=false

output "VrydenRDP @ $SCRIPT_VERSION"
output
output "Made By Vryden Development With Love"
output "https://github.com/JustRieriee/VrydenRDP"
output
output "Do Not Use This Remote Desktop For Mining Or DDoSing Or Something Like That!"

output

CRD_LATEST="$GITHUB_BASE_URL/$SCRIPT_VERSION/oscheck.sh"

XRDP_LATEST="$GITHUB_BASE_URL/$SCRIPT_VERSION/xrdp-install.sh"

while [ "$done" == false ]; do
  options=(
    "Install Chrome Remote Desktop"

    "Install XRDP"
  )

  actions=(
    "$CRD_LATEST"

    "$XRDP_LATEST"
  )

  output "What would you like to do?"

  for i in "${!options[@]}"; do
    output "[$i] ${options[$i]}"
  done
  GC='\033[0;32m'
  NC='\033[0m'
  echo -e -n "${GC}- Input 0-$((${#actions[@]} - 1)):${NC} "
  read -r action

  [ -z "$action" ] && error "Input Is Required" && continue

  valid_input=("$(for ((i = 0; i <= ${#actions[@]} - 1; i += 1)); do echo "${i}"; done)")
  [[ ! " ${valid_input[*]} " =~ ${action} ]] && error "Invalid option"
  [[ " ${valid_input[*]} " =~ ${action} ]] && done=true && IFS=";" read -r i1 i2 <<<"${actions[$action]}" && execute "$i1" "$i2"
done
