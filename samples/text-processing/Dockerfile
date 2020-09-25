FROM python:3-buster

RUN pip install 'summarizer==0.0.7' 'googletrans==3.0.0'

RUN cd /tmp && \
    wget https://github.com/GoogleCloudPlatform/gcsfuse/releases/download/v0.30.0/gcsfuse_0.30.0_amd64.deb && \
    apt-get update && \
    apt-get install -y ./gcsfuse_0.30.0_amd64.deb && \
    apt-get clean && apt-get autoclean && \
    rm ./gcsfuse_0.30.0_amd64.deb

ADD rootfs /

CMD [ "/usr/local/bin/entrypoint.sh" ]
