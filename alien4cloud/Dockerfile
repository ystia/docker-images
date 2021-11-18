FROM alien4cloud/alien4cloud:3.3.0

ENV ALIEN_VERSION 3.3.0

COPY --chown=a4c:a4c scripts /opt/a4c/
RUN chown -R a4c:a4c /opt/a4c

ENTRYPOINT cd /opt/a4c/ && ./start.sh
