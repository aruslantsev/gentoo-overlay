# Copyright 2025 Andrei Ruslantsev
# Distributed under the terms of the GNU General Public License v2


EAPI=8

DESCRIPTION="Set up remote ssh tunnel"
HOMEPAGE="https://github.com/aruslantsev/${PN}"
SRC_URI="https://github.com/aruslantsev/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~x86"

DEPEND="
	app-shells/bash
	net-misc/openssh
"

src_compile() {
	einfo "Nothing to compile"
}

src_install() {
	cd ${S}/src
	mkdir ${D}/etc
	cp -R conf.d init.d ${D}/etc
}

pkg_postinst() {
	if [ ! -f /etc/ssh-remote/id_ed25519_nopasswd ]
	then
		einfo "Creating new ssh key"
		mkdir /etc/ssh-remote
		ssh-keygen -o -a 100 -t ed25519 -N "" -f /etc/ssh-remote/id_ed25519_nopasswd -C "$(hostname)"
	fi
}

pkg_postrm() {
	if [ -d /etc/ssh-remote ]
	then
		einfo "/etc/ssh-remote is not empty and was not removed automatically"
	fi
}
