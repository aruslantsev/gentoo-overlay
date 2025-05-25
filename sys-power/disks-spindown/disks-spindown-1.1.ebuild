# Copyright 2025 Andrei Ruslantsev
# Distributed under the terms of the GNU General Public License v2


EAPI=8

DESCRIPTION="Spins down disks after period of inactivity"
HOMEPAGE="https://github.com/aruslantsev/${PN}"
SRC_URI="https://github.com/aruslantsev/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~x86"

DEPEND="
	app-shells/bash
	sys-apps/hdparm
	sys-apps/smartmontools
"

src_compile() {
	einfo "Nothing to compile"
}

src_install() {
	cd ${S}/src
	mkdir ${D}/etc
	mkdir -p ${D}/usr/bin
	cp -R conf.d init.d ${D}/etc
	cp disks-spindown ${D}/usr/bin
}
