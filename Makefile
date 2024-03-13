#!/bin/make

ROOT=/
ETC=${ROOT}/etc
INSTALL_CMD=cp
lINK_CMD=ln -sf
SUFFIX=-call
BANENT=banent${SUFFIX}.sh

BUILD=./temp
BINDIR=${ROOT}/bin
TARBALL=banent.tgz

first: all

all: banent unbanent

banent: banent${SUFFIX}.sh
	${lINK_CMD} banent${SUFFIX}.sh banent

unbanent: banent${SUFFIX}.sh
	${lINK_CMD} banent${SUFFIX}.sh unbanent

clean:
	rm -f banent unbanent
	rm -fr ${BUILD}
	rm -f ${TARBALL}

install:
	test -d ${BINDIR} || mkdir -p ${BINDIR}
	${INSTALL_CMD} banent${SUFFIX}.sh ${BINDIR}
	cd ${BINDIR} && ${lINK_CMD} banent${SUFFIX}.sh banent && ${lINK_CMD} banent${SUFFIX}.sh unbanent
	test ${SUFFIX} = -call || test -d ${ETC} || mkdir -p ${ETC}
	test ${SUFFIX} = -call || test -d ${ETC}/sudoers.d || mkdir -p ${ETC}/sudoers.d
	test ${SUFFIX} = -call || ${INSTALL_CMD} banent ${ETC}/sudoers.d/banent

uninstall:
	rm -f ${ETC}/sudoers.d/banent
	test -d ${ROOT}
	rm -f ${BINDIR}/banent${SUFFIX}.sh ${BINDIR}/banent ${BINDIR}/unbanent

${BUILD}/banent-call.sh: banent-call.sh Makefile
	test -d ${BUILD} || mkdir -p ${BUILD}
	${INSTALL_CMD} banent-call.sh ${BUILD}/

${BUILD}/banent-impl.sh: banent-impl.sh Makefile
	test -d ${BUILD} || mkdir -p ${BUILD}
	${INSTALL_CMD} banent-impl.sh ${BUILD}/

${BUILD}/Makefile: Makefile
	test -d ${BUILD} || mkdir -p ${BUILD}
	sed -e 's|ROOT=/|ROOT=.|' -e 's/SUFFIX=-call/SUFFIX=-impl/' Makefile > ${BUILD}/Makefile

${BUILD}/banent: banent.sudoers
	test -d ${BUILD} || mkdir -p ${BUILD}
	${INSTALL_CMD} banent.sudoers ${BUILD}/banent

${BINDIR}/banent${SUFFIX}.sh: ${BUILD}/banent-call.sh ${BUILD}/banent-impl.sh ${BUILD}/Makefile ${BUILD}/banent
	cd ./temp && make && make install

${TARBALL}: ${BINDIR}/banent${SUFFIX}.sh
	tar -C ./temp --owner=root --group=root -czf ${TARBALL} ./bin ./etc
