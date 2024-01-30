#!/bin/make

ROOT=/usr/local
INSTALL_CMD=install

first: all

all: banent unbanent

banent: banent.sh
	ln -sf banent.sh banent

unbanent: banent.sh
	ln -sf banent.sh unbanent

clean:
	rm banent unbanent

install:
	test -d ${ROOT}/bin
	${INSTALL_CMD} banent.sh ${ROOT}/bin
	cd ${ROOT}/bin && ln -sf banent.sh banent && ln -sf banent.sh unbanent
	${INSTALL_CMD} banent.sudoers /etc/sudoers.d

uninstall:
	rm -f /etc/sudoers.d/banent.sudoers
	test -d ${ROOT}
	rm -f ${ROOT}/bin/banent.sh ${ROOT}/bin/banent ${ROOT}/bin/unbanent
