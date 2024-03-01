#!/bin/make

ROOT=/
ETC=${ROOT}/etc
LOCAL=${ROOT}/usr/local
INSTALL_CMD=install

BUILD=./temp
BINDIR=${ROOT}/bin
TARBALL=banent.tgz

first: all

all: banent unbanent

banent: banent.sh
	ln -sf banent.sh banent

unbanent: banent.sh
	ln -sf banent.sh unbanent

clean:
	rm -f banent unbanent
	rm -fr ${BUILD}
	rm -f ${TARBALL}

install:
	test -d ${BINDIR} || mkdir -p ${BINDIR}
	${INSTALL_CMD} banent.sh ${BINDIR}
	cd ${BINDIR} && ln -sf banent.sh banent && ln -sf banent.sh unbanent
	test -d ${ETC} || mkdir -p ${ETC}
	test -d ${ETC}/sudoers.d || mkdir -p ${ETC}/sudoers.d
	${INSTALL_CMD} ../banent.sudoers ${ETC}/sudoers.d

uninstall:
	rm -f ${ETC}/sudoers.d/banent.sudoers
	test -d ${LOCAL}
	rm -f ${BINDIR}/banent.sh ${BINDIR}/banent ${BINDIR}/unbanent

owrt_pack: ${BUILD}/banent.sh ${BUILD}/Makefile ${BUILD}/banent.sudoers ${BINDIR}/banent.sh ${TARBALL}

${BUILD}/banent.sh: banent.sh Makefile
	mkdir -p ${BUILD}
	sed -e 's|#!/bin/bash|#!/bin/ash|' -e "s|REMOTE='echo '|REMOTE=''|" banent.sh > ${BUILD}/banent.sh

${BUILD}/Makefile: Makefile
	mkdir -p ${BUILD}
	sed 's|ROOT=/|ROOT=overlay/upper|' Makefile > ${BUILD}/Makefile

${BUILD}/banent.sudoers: banent.sudoers
	mkdir -p ${BUILD}
	install banent.sudoers ${BUILD}/banent.sudoers

${BINDIR}/banent.sh: ${BUILD}/banent.sh ${BUILD}/Makefile
	cd ./temp && make && make install

${TARBALL}: ${BINDIR}/banent.sh ${BUILD}/banent.sudoers
	tar -C ./temp -czf ${TARBALL} overlay/
