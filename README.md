# Porting X11Libre to FreeBSD  [![Build Status](https://api.cirrus-ci.com/github/probonopd/xlibre-ports.svg)](https://cirrus-ci.com/github/probonopd/xlibre-ports)

An effort for porting X11libre to FreeBSD.

After cloning, you can use the OVERLAY option in the /etc/make.conf to overlay
this folder to your main tree. 
Use a jail for testing, so that your packages won't get messed up. 

## Packages

[Built packages](https://api.cirrus-ci.com/v1/artifact/github/probonopd/xlibre-ports/pkg/binary/FreeBSD:14:amd64/index.html)

```sh
sudo su

cat > /usr/local/etc/pkg/repos/xlibre.conf <<\EOF
xlibre: {
        url: "pkg+https://api.cirrus-ci.com/v1/artifact/github/probonopd/xlibre-ports/pkg/binary/${ABI}",
        mirror_type: "srv",
        enabled: yes,
        priority: 100
}
EOF
exit

sudo pkg install xlibre-server xlibre-drivers
```
