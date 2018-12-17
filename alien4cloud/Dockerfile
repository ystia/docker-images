FROM alien4cloud/alien4cloud:2.1.0-SM7

ENV ALIEN_VERSION 2.1.0-SM7
ARG YORC_PLUGIN_VERSION
ENV YORC_PLUGIN_VERSION ${YORC_PLUGIN_VERSION:-3.1.0-M6}

COPY --chown=a4c:a4c scripts /var/a4c/
RUN cd /var/a4c/alien4cloud/init/plugins/ && \
    rm alien4cloud-yorc-plugin-* && \
    curl -L -X GET -o alien4cloud-yorc-plugin-${YORC_PLUGIN_VERSION}.zip https://github.com/ystia/yorc-a4c-plugin/releases/download/v${YORC_PLUGIN_VERSION}/alien4cloud-yorc-plugin-${YORC_PLUGIN_VERSION}.zip && \
    chown -R a4c:a4c /var/a4c
    
ENTRYPOINT cd /var/a4c/ && ./start.sh