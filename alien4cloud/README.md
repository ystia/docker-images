Docker image of alien4cloud http://alien4cloud.github.io/

## How to use it 
Simply run this command to start an alien4cloud container exposing port 8088 on the host 
```
docker run -d --name A4C -p 8088:8088 ystia/alien4cloud
```
Connect to http://localhost:8088, default user and password are 'admin'

This container has the capability to connect to a running Yorc server through environment variables. 
For example, if your Yorc server IP adress is *11.22.33.44* and is configured to listen on port *8888*, you have to start container like this 
```
docker run -d --name A4C -p 8088:8088 -e YORC_HOST=11.22.33.44 -e YORC_PORT=8888 ystia/alien4cloud
```
The default number of retry (25) and delay (5 sec) is habitually adequate but you are encountering issues, you can set them manualy through environment variables **NB_RETRY** and **PERIOD_SECOND**
