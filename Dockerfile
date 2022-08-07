FROM debian:stable-slim
WORKDIR /app
RUN apt-get update && apt-get install -y wget tar
RUN wget https://github.com/cloudreve/Cloudreve/releases/download/3.5.3/cloudreve_3.5.3_linux_amd64.tar.gz
RUN tar zxvf cloudreve_3.5.3_linux_amd64.tar.gz
RUN chmod +x ./cloudreve
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD /app/cloudreve
