FROM nodered/node-red-docker

USER root

# User configuration directory volume
VOLUME ["/data"]

# Configure Python environment
RUN apt-get update \
    && apt-get install -y python-pip \
    && pip install virtualenv

COPY startup /startup

USER node-red

ENTRYPOINT ["/startup/startup.sh"]

