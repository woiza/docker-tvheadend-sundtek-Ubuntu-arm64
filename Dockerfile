FROM lsiobase/xenial.arm64

LABEL maintainer="woiza"

# environment settings
ARG DEBIAN_FRONTEND="noninteractive"

# adding qemu for crossbuilding on DockerHub
#COPY --from=resin/aarch64-alpine:latest /usr/bin/qemu* /usr/bin/
#COPY --from=resin/aarch64-alpine:latest /usr/bin/resin-xbuild* /usr/bin/
#COPY --from=resin/aarch64-alpine:latest /usr/bin/cross-build* /usr/bin/

COPY --from=resin/aarch64-alpine:latest ["/usr/bin/qemu*", "/usr/bin/resin-xbuild*", "/usr/bin/cross-build*",  "/usr/bin/"]

RUN [ "cross-build-start" ]

RUN \
echo "**** install prerequisite packages ****" && \
apt-get update && \
#apt-get install -y software-properties-common && \
apt-get install -y apt-transport-https && \

# echo "**** add tvheadendrepository ****" && \
 apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 379CE192D401AB61 && \
 echo "deb https://dl.bintray.com/tvheadend/deb xenial stable-4.2" >> /etc/apt/sources.list && \
 
 echo "**** install tvheadend and wget****" && \
 #apt-add-repository ppa:mamarley/tvheadend-git-stable && \
 apt-get update && \
 apt-get install -y \
	tvheadend \
	wget && \
	
 echo "**** install Sundtek****" && \
 wget http://www.sundtek.de/media/sundtek_netinst.sh -O /tmp/sundtek_netinst.sh && \
 chmod 777 /tmp/sundtek_netinst.sh && \
 /tmp/sundtek_netinst.sh -easyvdr && \
 
 echo "**** cleanup ****" && \
 apt-get clean && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

RUN [ "cross-build-end" ]

# add local files
COPY root/ /

# Volumes and Ports
VOLUME /config /recordings /picons
