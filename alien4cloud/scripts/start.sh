#!/bin/sh

if [ -z "${YORC_HOST}" -o -z "${YORC_PORT}" ]; then
    echo "INFO  Script:Undef YORC_HOST or YORC_PORT, launching alien4cloud only."
    cd alien4cloud && ./alien4cloud.sh
else


if [ -z "${NB_RETRY}" ]; then
    NB_RETRY=25 ;
fi
if [ -z "${PERIOD_SECOND}" ]; then
    PERIOD_SECOND=5 ;
fi

cd alien4cloud && nohup ./alien4cloud.sh &
a4c_pid=$! ;

orch_created=false ;
orch_configured=false ;
orch_enabled=false ;

for i in $(seq 1 $NB_RETRY); do
    if  [ "$orch_created" = true ] && [ "$orch_configured" = true ] && [ "$orch_enabled" = true ]; then
        "$(date -u +"%Y-%m-%d %H:%M:%S") INFO  Script:Success ! Orchestrator is enabled."
        break;
    fi

    echo "$(date -u +"%Y-%m-%d %H:%M:%S") INFO  Script:Trying to connect to orchestrator, attempt $i." ;
    
    if [ "$orch_created" = false ]; then
        bash ./create_orchestrator.bash
        if [ $? -eq 0 ]; then echo "$(date -u +"%Y-%m-%d %H:%M:%S") INFO  Script:Orchestrator created.";
            orch_created=true ;
        else echo "$(date -u +"%Y-%m-%d %H:%M:%S") WARN  Script:Not able to create orchestrator." ;
        fi
    fi

    if [ "$orch_configured" = false ] && [ "$orch_created" = true ]; then
        bash ./configure_orchestrator.bash --yorc-url "http://${YORC_HOST}:${YORC_PORT}"
        if [ $? -eq 0 ]; then echo "$(date -u +"%Y-%m-%d %H:%M:%S") INFO  Script:Orchestrator configured.";
            orch_configured=true ;
        else echo "$(date -u +"%Y-%m-%d %H:%M:%S") WARN  Script:Not able to configure orchestrator." ;
        fi
    fi
    
    if [ "$orch_enabled" = false ] && [ "$orch_configured" = true ]; then
        bash ./enable_orchestrator.bash
        if [ $? -eq 0 ]; then echo "$(date -u +"%Y-%m-%d %H:%M:%S") INFO  Script:Orchestrator enabled.";
            orch_enabled=true ;
        else echo "$(date -u +"%Y-%m-%d %H:%M:%S") WARN  Script:Not able to enable orchestrator." ;
        fi
    fi
    

    sleep $PERIOD_SECOND ;
done
fi

wait $a4c_pid