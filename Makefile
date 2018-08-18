# This Makefile will build a jo deb and rpm package from source.
SHELL := /bin/bash
NAME = jo
DESTDIR = build
PKGTYPE = deb
PREFIX = /usr/local
BINDIR = $(PREFIX)/bin
JO_URL = $(shell curl -s https://api.github.com/repos/jpmens/jo/releases/latest | jq -r ".assets[] | select(.name | test(\".tar.gz\")) | .browser_download_url")
TAG_NUMBER = $(shell curl https://api.github.com/repos/jpmens/jo/releases/latest | jq -r ".tag_name")
VERSION = $(shell echo $(TAG_NUMBER) | cut -c 2-)
TARBALL = $(notdir $(JO_URL))
JO_BUILD_BIN = $(DESTDIR)$(BINDIR)/$(NAME)

.PHONY: default package build clean deb rpm

default:
	@echo "Syntax: make [deb|rpm|clean]"

deb: PKGTYPE=deb
deb: package

rpm: PKGTYPE=rpm
rpm: package

$(TARBALL):
	curl -LO "$(JO_URL)"

build: $(TARBALL)
	mkdir -pv $(DESTDIR)
	tar --strip-components=1 -C $(DESTDIR) -zxvf $<
	cd $(DESTDIR); \
	autoreconf -i; \
	./configure; \
	$(MAKE) check; \
	$(MAKE) DESTDIR=$(DESTDIR) install;

package: build
	fpm -s dir -t $(PKGTYPE) -C "$(DESTDIR)/build" \
		--verbose \
		--name "$(NAME)" \
		--version "$(VERSION)" \
		--vendor "Jan-Piet Mens <http://jpmens.net>" \
		--license "GPL" \
		--url "https://github.com/jpmens/jo" \
		--category Web \
		--description "jo - JSON output from a shell" \
		.

clean:
	$(RM) -R build $(TARBALL) *.deb *.rpm
