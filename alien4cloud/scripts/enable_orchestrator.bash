#!/bin/bash

#
# enable_orchestrator - enables a Yorc orchestrator in Alien4Cloud
#

a4cURL="http://localhost:8088"
userName="admin"
password="admin"
usage() {
    echo ""
    echo "Usage:"
    echo "enable_orchestrator [--a4c-url <Alien4Cloud URL>]"
    echo "                    [--user <Alien4Cloud administrator user name>]"
    echo "                    [--password <Alien4Cloud administrator password>]"
    echo "   - default A4C URL : $a4cURL"
    echo "   - default user    : $userName"
    echo "   - default password: $password"
}

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -a|--a4c-url)
    a4cURL="$2"
    shift # past argument
    shift # past value
    ;;
    -u|--user)
    userName="$2"
    shift # past argument
    shift # past value
    ;;
    -p|--password)
    password="$2"
    shift # past argument
    shift # past value
    ;;
    -h|--help)
    usage
    exit 0
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

# Load utilities
declare -r DIR=$(cd "$(dirname "$0")" && pwd)
source $DIR/utils.bash

# First, login and store the cookies
a4c_login "$a4cURL" "$userName" "$password" "cookies.a4c"

# Get Orchestratror ID
res=`curl --request GET \
          --url $a4cURL/rest/latest/orchestrators?query=Yorc \
          --header 'Accept: application/json' \
          --silent \
          --cookie cookies.a4c`
yorcID=`getJsonval id $res`

if [ -z "$yorcID" ]
then
    echo "Exiting on error getting the Orchestrator ID"
    exit 1
fi

# Enable the orchestrator
response=`curl --request POST \
               --url $a4cURL/rest/latest/orchestrators/$yorcID/instance  \
               --header 'Content-Type: application/json' \
               --cookie cookies.a4c \
               --silent \
               --data "{}"`

res=$?
if [ $res -ne 0 ]
then
    echo "Exiting on error enabling the orchestrator in Alien4Cloud: $response"
    exit 1
else
    echo "Orchestrator enabled in Alien4Cloud"
fi