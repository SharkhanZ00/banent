#!/bin/make

ROOT=/
ETC=${ROOT}/etc
LOCAL=${ROOT}/usr/local
INSTALL_CMD=cp
SUFFIX=-call
BANENT=banent${SUFFIX}.sh

BUILD=./temp
BINDIR=${ROOT}/bin
TARBALL=banent.tgz

first: all

all: banent unbanent

banent: banent${SUFFIX}.sh
	ln -sf banent${SUFFIX}.sh banent

unbanent: banent${SUFFIX}.sh
	ln -sf banent${SUFFIX}.sh unbanent

clean:
	rm -f banent unbanent
	rm -fr ${BUILD}
	rm -f ${TARBALL}

install:
	test -d ${BINDIR} || mkdir -p ${BINDIR}
	${INSTALL_CMD} banent${SUFFIX}.sh ${BINDIR}
	cd ${BINDIR} && ln -sf banent${SUFFIX}.sh banent && ln -sf banent${SUFFIX}.sh unbanent
	test -d ${ETC} || mkdir -p ${ETC}
	test -d ${ETC}/sudoers.d || mkdir -p ${ETC}/sudoers.d
	${INSTALL_CMD} banent.sudoers ${ETC}/sudoers.d

uninstall:
	rm -f ${ETC}/sudoers.d/banent.sudoers
	test -d ${LOCAL}
	rm -f ${BINDIR}/banent${SUFFIX}.sh ${BINDIR}/banent ${BINDIR}/unbanent

${BUILD}/banent-call.sh: banent-call.sh Makefile
	test -d ${BUILD} || mkdir -p ${BUILD}
	${INSTALL_CMD} banent-call.sh ${BUILD}/

${BUILD}/banent-impl.sh: banent-impl.sh Makefile
	test -d ${BUILD} || mkdir -p ${BUILD}
	${INSTALL_CMD} banent-impl.sh ${BUILD}/

${BUILD}/Makefile: Makefile
	test -d ${BUILD} || mkdir -p ${BUILD}
	sed -e 's|ROOT=/|ROOT=overlay/upper|' -e 's/SUFFIX=-call/SUFFIX=-impl/' Makefile > ${BUILD}/Makefile

${BUILD}/banent.sudoers: banent.sudoers
	test -d ${BUILD} || mkdir -p ${BUILD}
	${INSTALL_CMD} banent.sudoers ${BUILD}/

${BINDIR}/banent${SUFFIX}.sh: ${BUILD}/banent-call.sh ${BUILD}/banent-impl.sh ${BUILD}/Makefile ${BUILD}/banent.sudoers
	cd ./temp && make && make install

${TARBALL}: ${BINDIR}/banent${SUFFIX}.sh
	tar -C ./temp -czf ${TARBALL} overlay/
