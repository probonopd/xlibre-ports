# XLibre ports categories and other things needed to build XLibre ports.
# This is intended only for ports of XLibre and related applications.
#
# Use USES=xlibre and USE_XLIBRE to depend on various XLibre components.
#
# Feature:	xlibre-cat
# Usage:	USES=xlibre-cat:category[,buildsystem]
#
# 		category is one of:
# 		* driver   depends on xorgproto at least
#
# 		Bleow are the old freedesktop.org categories and their comments
# 		X11Libre only hosts the driver category and the xserver, these
# 		categoryes are disabled now, but kept in a commented state for
#		if they be added to X11Libre in the future.
#
# 		* app      Installs applications, no shared libraries.
# 		* data     Installs only data.
# 		* doc      no particular notes
# 		* font     don't install .pc file
# 		* lib      various dependencies, install .pc file, needs
# 		           pathfix
# 		* proto    install .pc file, needs pathfix, most only needed at
# 		           build time.
# 		* util     no particular notes
#
# 		These categories has to match upstream categories.  Don't invent
# 		your own.
#
# 		builsystem is one of:
# 		* autotools (default)
# 		* meson (experimental)
#
#
#
#.MAINTAINER:	b-aazbsd.proton.me

.if !defined(_INCLUDE_USES_XLIBRE_CAT_MK)
_INCLUDE_USES_XLIBRE_CAT_MK=yes

######_XLIBRE_CATEGORIES=	app data doc driver font lib proto util
_XLIBRE_CATEGORIES=	driver
_XLIBRE_BUILDSYSTEMS=	autotools meson

_XLIBRE_CAT=		# empty
_XLIBRE_BUILDSYS=	# empty

.  if empty(xlibre-cat_ARGS)
IGNORE=		no arguments specified to xlibre-cat
.  endif

.  for _arg in ${xlibre-cat_ARGS}
.    if ${_XLIBRE_CATEGORIES:M${_arg}}
.      if empty(_XLIBRE_CAT)
_XLIBRE_CAT=	${_arg}
.      else
IGNORE=		multipe xlibre categories specified via xlibre-cat:${xlibre-cat_ARGS:ts,}
.      endif
.    elif ${_XLIBRE_BUILDSYSTEMS:M${_arg}}
.      if empty(_XLIBRE_BUILDSYS)
_XLIBRE_BUILDSYS=	${_arg}
.      else
IGNORE=		multipe xlibre build systems specified via xlibre-cat:${xlibre-cat_ARGS:ts,}
.      endif
.    else
IGNORE=		unknown argument specified via xlibre-cat:${xlibre-cat_ARGS:ts,}
.    endif
.  endfor

# Default to the autotools build system
.  if empty(_XLIBRE_BUILDSYS)
_XLIBRE_BUILDSYS=		autotools
.  endif

# Default variables, common to all new modular xorg ports.
.  if empty(USES:Mtar)
EXTRACT_SUFX?=		.tar.bz2
.  endif

DIST_SUBDIR=	xlibre/${_XLIBRE_CAT}

.  if ${_XLIBRE_BUILDSYS} == meson
.include "${USESDIR}/meson.mk"
.  elif ${_XLIBRE_BUILDSYS} == autotools
GNU_CONFIGURE=		yes
.  else
# This should not happen
IGNORE=		unknown build system specified via xlibre-cat:${xlibre-cat_ARGS:ts,}
.  endif

# Set up things for fetching from X11Libre GitHub.
# This can be overridden using normal GH_* macros in the ports Makefile.
# We make a best guess for GH_PROJECT.
USE_GITHUB=		yes
GH_ACCOUNT?=		X11Libre
.  if ${_XLIBRE_CAT} == driver
# Removeds the xlibre- suffix from the PORTNAME
GH_PROJECT?=		${PORTNAME:tl:C/xlibre-//}
.  else
GH_PROJECT?=		${PORTNAME:tl}
.  endif

.  if empty(GH_TAGNAME)
IGNORE= GH_TAGNAME is empty, add a tagname!
.  endif
.  if ${_XLIBRE_BUILDSYS} == meson
# set up meson stuff here
.  else
# Things from GitHub doesn't come with pre-generated configure, add dependency on
# autoreconf and run it, if we're using autotools.
.include "${USESDIR}/autoreconf.mk"
.  endif

#
## All xlibre ports needs pkgconfig to build, but some ports look for pkgconfig
## and then continue the build.
.include "${USESDIR}/pkgconfig.mk"

#
## All xlibre ports need xorg-macros.
.  if ${PORTNAME} != xorg-macros
USE_XLIBRE+=      xorg-macros
.  endif

#####.  if ${_XLIBRE_CAT} == app
###### Nothing at the moment
#####
#####.  elif ${_XLIBRE_CAT} == data
###### Nothing at the moment.

#####.  elif ${_XLIBRE_CAT} == driver

.  if ${_XLIBRE_CAT} == driver
USE_XLIBRE+=	xi xlibre-server xorgproto
CFLAGS+=	-Werror=uninitialized
.    if ${_XLIBRE_BUILDSYS} == meson
# Put special stuff for meson here
.    else
CONFIGURE_ENV+=	DRIVER_MAN_SUFFIX=4x DRIVER_MAN_DIR='$$(mandir)/man4'
libtool_ARGS?=	# empty
.include "${USESDIR}/libtool.mk"
INSTALL_TARGET=	install-strip
.    endif

## X11Libre does not host any category other than drivers for now so there is 
## need to check for them. 

#####.  elif ${_XLIBRE_CAT} == font
#####FONTNAME?=	${PORTNAME:C/.*-//g:S/type/Type/:S/ttf/TTF/:S/speedo/Speedo/}
#####.    if ${_XLIBRE_BUILDSYS} == meson
###### Put special stuff for meson here
#####.    else
#####CONFIGURE_ARGS+=	--with-fontrootdir=${PREFIX}/share/fonts
#####CONFIGURE_ENV+=	FONTROOTDIR=${PREFIX}/share/fonts
#####.    endif
#####.    if !defined(NOFONT)
#####.include "${USESDIR}/fonts.mk"
#####BUILD_DEPENDS+=	mkfontscale>=0:x11-fonts/mkfontscale \
#####		bdftopcf:x11-fonts/bdftopcf
#####PLIST_FILES+=	"@comment ${FONTSDIR}/fonts.dir" \
#####		"@comment ${FONTSDIR}/fonts.scale"
#####.    endif
#####
#####.  elif ${_XLIBRE_CAT} == lib
#####CFLAGS+=	-Werror=uninitialized
#####.include "${USESDIR}/pathfix.mk"
#####.    if ${_XLIBRE_BUILDSYS} == meson
###### put meson stuff here
#####.    else
#####libtool_ARGS?=	# empty
#####.include "${USESDIR}/libtool.mk"
#####USE_LDCONFIG=	yes
#####CONFIGURE_ARGS+=--enable-malloc0returnsnull
#####.    endif
#####
#####.  elif ${_XLIBRE_CAT} == proto
#####.include "${USESDIR}/pathfix.mk"
#####

.  endif # ${_XLIBRE_CAT} == <category>

# We only need to include xlibre.mk if we want USE_XLIBRE modules
# USES+=xlibre does not provide any functionality, it just silences an error
# message about USES=xlibre not being set
.  if defined(USE_XLIBRE) && !empty(USE_XLIBRE)
USES+=		xlibre
# This line needs to change to ${USESDIR}/xlibre.mk if this file ends up in the
# main ports tree
.include "./xlibre.mk"
.  endif

.endif
