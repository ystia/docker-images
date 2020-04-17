FROM alien4cloud/alien4cloud:2.2.0

ENV ALIEN_VERSION 2.2.0

COPY --chown=a4c:a4c scripts /var/a4c/
RUN chown -R a4c:a4c /var/a4c

ENTRYPOINT cd /var/a4c/ && ./start.sh
