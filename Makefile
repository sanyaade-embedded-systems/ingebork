# ingebork - dynamic window manager
# See LICENSE file for copyright and license details.

include config.mk

SRC = ingebork.c
OBJ = ${SRC:.c=.o}

all: options ingebork

options:
	@echo ingebork build options:
	@echo "CFLAGS   = ${CFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"
	@echo "CC       = ${CC}"

.c.o:
	@echo CC $<
	@${CC} -c ${CFLAGS} $<

${OBJ}: config.h config.mk

ingebork: ${OBJ}
	@echo CC -o $@
	@${CC} -o $@ ${OBJ} ${LDFLAGS}

clean:
	@echo cleaning
	@rm -f ingebork ${OBJ} ingebork-${VERSION}.tar.gz

dist: clean
	@echo creating dist tarball
	@mkdir -p ingebork-${VERSION}
	@cp -R LICENSE Makefile README config.h config.mk \
		ingebork.1 ${SRC} ingebork-${VERSION}
	@tar -cf ingebork-${VERSION}.tar ingebork-${VERSION}
	@gzip ingebork-${VERSION}.tar
	@rm -rf ingebork-${VERSION}

install: all
	@echo installing executable file to ${DESTDIR}${PREFIX}/bin
	@mkdir -p ${DESTDIR}${PREFIX}/bin
	@cp -f ingebork ${DESTDIR}${PREFIX}/bin
	@chmod 755 ${DESTDIR}${PREFIX}/bin/ingebork
	@echo installing manual page to ${DESTDIR}${MANPREFIX}/man1
	@mkdir -p ${DESTDIR}${MANPREFIX}/man1
	@sed "s/VERSION/${VERSION}/g" < ingebork.1 > ${DESTDIR}${MANPREFIX}/man1/ingebork.1
	@chmod 644 ${DESTDIR}${MANPREFIX}/man1/ingebork.1

uninstall:
	@echo removing executable file from ${DESTDIR}${PREFIX}/bin
	@rm -f ${DESTDIR}${PREFIX}/bin/ingebork
	@echo removing manual page from ${DESTDIR}${MANPREFIX}/man1
	@rm -f ${DESTDIR}${MANPREFIX}/man1/ingebork.1

.PHONY: all options clean dist install uninstall
