#!/bin/bash

#
# create_location - creates a Yorc orchestrator location
#

a4cURL="http://localhost:8088"
userName="admin"
password="admin"
infraType="Kubernetes"
locationName="K8's"
usage() {
    echo ""
    echo "Usage:"
    echo "create_location [--a4c-url <Alien4Cloud URL>]"
    echo "                [--user <Alien4Cloud administrator user name>]"
    echo "                [--password <Alien4Cloud administrator password>]"
    echo "                [--type <Infrastructure Type>]"
    echo "                [--name <Location Name>]"
    echo "   - default A4C URL             : $a4cURL"
    echo "   - default user                : $userName"
    echo "   - default password            : $password"
    echo "   - default Infrastructure Type : $infraType"
    echo "   - default Location Name       : $locationName"
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
    -t|--type)
    infraType="$2"
    shift # past argument
    shift # past value
    ;;
    -n|--name)
    locationName="$2"
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

# Create the location
response=`curl --request POST \
               --url $a4cURL/rest/latest/orchestrators/$yorcID/locations  \
               --header 'Content-Type: application/json' \
               --cookie cookies.a4c \
               --silent \
               --data "{\"infrastructureType\": \"$infraType\", \"name\": \"$locationName\"}"`

res=$?
if [ $res -ne 0 ]
then
    echo "Exiting on error creating location $locationName of type '$infraType': $response"
    exit 1
else
    echo "Location $locationName of type '$infraType' created"
fi

# Get the location ID
res=`curl --request GET \
          --url $a4cURL/rest/latest/orchestrators/$yorcID/locations?query=$locationName \
          --header 'Accept: application/json' \
          --silent \
          --cookie cookies.a4c`
locationID=`getJsonval id $res`

if [ -z "$locationID" ]
then
    echo "Exiting on error getting the ID for location $locationName"
    exit 1
fi

declare -A ressources=( ["K8'S Deployment"]="org.alien4cloud.kubernetes.api.types.Deployment" 
                        ["K8'S Service"]="org.alien4cloud.kubernetes.api.types.Service"
                        ["K8'S Container"]="org.alien4cloud.kubernetes.api.types.Container"
                        ["K8'S Job"]="org.alien4cloud.kubernetes.api.types.Job" 
                        ["K8'S EmptyDir"]="org.alien4cloud.kubernetes.api.types.volume.EmptyDirVolumeSource" )

# Create a K8S Deployement on-demand resource
for K in "${!ressources[@]}"; do 
    
    response=`curl --request POST \
                --url $a4cURL/rest/latest/orchestrators/$yorcID/locations/$locationID/resources  \
                --header 'Content-Type: application/json' \
                --cookie cookies.a4c \
                --silent \
                --data "{\"archiveName\": \"org.alien4cloud.kubernetes.api\", \"archiveVersion\": \"2.1.0-SM7\", \"resourceName\": \"$K\", \"resourceType\": \"${ressources[$K]}\"}"`
    res=$?
    if [ $res -ne 0 ]
    then
        echo "Exiting on error creating an on-demand resource on location $locationName: $response"
        exit 1
    fi
done