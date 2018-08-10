FROM nodered/node-red-docker

# User configuration directory volume
VOLUME ["/data"]

COPY startup /startup

ENTRYPOINT ["/startup/startup.sh"]

