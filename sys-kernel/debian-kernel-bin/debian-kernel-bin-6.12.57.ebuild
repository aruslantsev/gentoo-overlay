# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KV_LOCALVERSION="+deb13-amd64"
S=${WORKDIR}

DESCRIPTION="Pre-built Debian Linux kernel"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="
	https://ftp.debian.org/debian/pool/main/l/linux-signed-amd64/linux-image-${PV}${KV_LOCALVERSION}_${PV}-1_amd64.deb
"

LICENSE="GPL-2"
KEYWORDS="amd64"
SLOT="${PV}"

DEPEND=""
RDEPEND=""
BDEPEND="
	app-arch/tar
	app-arch/zstd
	initramfs? ( sys-kernel/dracut )
"

IUSE="+initramfs"

src_unpack () {
	unpack ${A}
	tar xpf data.tar.xz || die "Unpack failed"
}

src_install() {
	cd ${S}
	cp -R boot ${D} || die "Install failed"
	cp -R usr/lib ${D} || die "Install failed"
	# cp -R usr ${D} || die "Install failed" # Nothing valuable
}

pkg_postinst() {
	einfo "Running depmod."
	if [ -x "$(command -v depmod)" ]
	then
		depmod -b ${ROOT}/ ${PV}${KV_LOCALVERSION} || die "depmod failed"
	else
		ewarn "depmod is missing"
	fi
	if use initramfs
	then
		einfo "Creating initramfs at ${ROOT}/boot/initramfs-${PV}${KV_LOCALVERSION}.img"
		dracut --force --kver ${PV}${KV_LOCALVERSION} ${ROOT}/boot/initramfs-${PV}${KV_LOCALVERSION}.img || die "dracut failed"
	else
		einfo "This package does not provide initramfs."
		einfo "You may need to build it yourself or to install sys-kernel/dracut"
	fi
}

pkg_postrm() {
	if [ -f ${ROOT}/boot/initramfs-${PV}${KV_LOCALVERSION}.img ]
	then
		einfo "Initramfs at ${ROOT}/boot/initramfs-${PV}${KV_LOCALVERSION}.img was not removed"
	fi
	if [ -d ${ROOT}/usr/lib/modules/${PV}${KV_LOCALVERSION} ]
	then
		einfo "Modules directory ${ROOT}/usr/lib/modules/${PV}${KV_LOCALVERSION} was not removed"
	fi
}
