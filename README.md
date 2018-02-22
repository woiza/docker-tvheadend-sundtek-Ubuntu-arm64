credits: linuxserver, resin

Tvheadend - Sundtek - Xenial_arm64 


    docker run -d \
      --name=tvheadend-sundtek \
      --net=net-tv \
      -v tvheadend-data:/config \
      -v /home/woiza/tvheadend-recordings:/recordings \
      -v /home/woiza/picons:/picons \
      -e PGID=1001 -e PUID=1001  \
      -p 9981:9981 \
      -p 9982:9982 \
      --privileged \
      -v /dev/bus/usb:/dev/bus/usb
      --restart always \
      woiza/docker-tvheadend-sundtek-ubuntu-arm64
