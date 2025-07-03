PORTNAME=	xlibre-xf86-input-vmmouse
PORTVERSION=	13.1.0
PORTREVISION=	7
CATEGORIES=	x11-drivers

MAINTAINER=	b-aazbsd@proton.me
COMMENT=	XLibre vmmouse input driver
WWW=		https://github.com/X11Libre/

GH_TAGNAME=	f27f2b1
USES=		gmake xlibre-cat:driver

GNU_CONFIGURE_MANPREFIX=${PREFIX}/share

ONLY_FOR_ARCHS=	i386 amd64
ONLY_FOR_ARCHS_REASON=	vmmouse protocol is only supported on x86-compatible architectures

.include <bsd.port.mk>
