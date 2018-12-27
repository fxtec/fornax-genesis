#https://github.com/yeasy/docker-hyperledger-fabric/blob/master/Dockerfile
FROM hyperledger/fabric-tools:1.2.0

#Docker
RUN apt-get update && \
    apt-get install -y apt-transport-https && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - && \
    add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable" && \
    apt-get update && \
    apt-get install -y docker-ce-cli && \
    apt-get purge -y apt-transport-https && \
    rm -rf /var/cache/apt

# Watchdog
LABEL maintainer="davimesquita@gmail.com"
ENV ETCD_ENDPOINT http://etcd:2379
ENV DEF_NETWORK fornax-genesis

COPY et.sh /bin/et
COPY etset.sh /bin/etset
COPY etdel.sh /bin/etdel
COPY etfile.sh /bin/etfile
COPY etoutput.sh /bin/etoutput
COPY configtx.yaml /etc/hyperledger/fabric/
COPY crypto-config.yaml /etc/hyperledger/fabric/
RUN chmod +x /bin/et
RUN chmod +x /bin/etset
RUN chmod +x /bin/etdel
RUN chmod +x /bin/etfile
RUN chmod +x /bin/etoutput
COPY fornax-watchdog.sh /bin/fornax-watchdog
RUN chmod +x /bin/fornax-watchdog
WORKDIR /etc/hyperledger/fabric/
ENTRYPOINT ["/bin/fornax-watchdog"]
