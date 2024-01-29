#!/bin/make

ROOT=/usr/local

first: all

all: banent unbanent

banent:
	ln -s banent.sh banent

unbanent:
	ln -s banent.sh unbanent

clean:
	rm banent unbanent

install:
	test -d ${ROOT}/bin
	cp banent.sh ${ROOT}/bin
	cd ${ROOT}/bin && ln -s banent.sh banent && ln -s banent.sh unbanent

uninstall:
	test -d ${ROOT}
	rm -f ${ROOT}/bin/banent.sh ${ROOT}/bin/banent ${ROOT}/bin/unbanent
