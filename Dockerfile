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
apt-get install -y --no-install-recommends \
build-essential \
git \
pkg-config \
libssl-dev \
bzip2 \
gettext \
python \
wget \
xmltv \
libav-tools \
libavahi-client-dev \
zlib1g-dev && \
#libavcodec-dev \
#libavutil-dev \
#libavfilter-dev \
#libavformat-dev \
#libswscale-dev \
#libavresample-dev && \


echo "**** compile tvheadend ****" && \
git clone https://github.com/tvheadend/tvheadend.git /tmp/tvheadend && \
cd /tmp/tvheadend && \
 ./configure \
	--disable-avahi \
	--disable-bintray_cache \
	--disable-dbus_1 \
	--disable-ffmpeg_static \
	--disable-hdhomerun_static \
	--disable-libfdkaac_static \
	--disable-libmfx_static \
	--disable-libtheora_static \
	--disable-libvorbis_static \
	--disable-libvpx_static \
	--disable-libx264_static \
	--disable-libx265_static \
	--disable-hdhomerun_client \
	--disable-libav \
	--enable-pngquant \
	--infodir=/usr/share/info \
	--localstatedir=/var \
	--mandir=/usr/share/man \
	--prefix=/usr \
	--sysconfdir=/config && \
 make && \
 make install && \
	

#apt-get install -y software-properties-common && \
#apt-get install -y apt-transport-https && \

# echo "**** add tvheadendrepository ****" && \
# apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 379CE192D401AB61 && \
# echo "deb https://dl.bintray.com/tvheadend/deb xenial stable-4.2" >> /etc/apt/sources.list && \
 
# echo "**** install tvheadend and wget****" && \
# apt-add-repository ppa:mamarley/tvheadend-git-stable && \
# apt-get update && \
# apt-get install -y --no-install-recommends \
#	tvheadend \
#	wget && \
	
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
EXPOSE 9981 9982
VOLUME /config /recordings /picons
