# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 toolchain-funcs

DESCRIPTION="Logs process fork(), exec() and exit() activity"
HOMEPAGE="https://launchpad.net/ubuntu/+source/forkstat https://github.com/ColinIanKing/forkstat"
SRC_URI="https://github.com/ColinIanKing/${PN}/archive/V${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~x86"

src_prepare() {
	default

	# Don't compress manpages, respect CFLAGS
	sed -i  -e '/install:/s/ forkstat.8.gz//' \
		-e '/cp forkstat.8/s/.gz//' \
		-e '/CFLAGS += -Wall/s| -O2||' \
		Makefile || die "sed failed"
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	default
	dobashcomp bash-completion/forkstat
}
