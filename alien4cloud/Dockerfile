FROM alien4cloud/alien4cloud:2.1.0

ENV ALIEN_VERSION 2.1.0
ARG YORC_PLUGIN_VERSION
ENV YORC_PLUGIN_VERSION ${YORC_PLUGIN_VERSION:-3.1.2}

COPY --chown=a4c:a4c scripts /var/a4c/
RUN cd /var/a4c/alien4cloud/init/plugins/ && \
    curl -L -X GET -o alien4cloud-yorc-plugin-${YORC_PLUGIN_VERSION}.zip http://dl.bintray.com/ystia/yorc-a4c-plugin/${YORC_PLUGIN_VERSION}/alien4cloud-yorc-plugin-${YORC_PLUGIN_VERSION}.zip && \
    chown -R a4c:a4c /var/a4c
    
ENTRYPOINT cd /var/a4c/ && ./start.sh