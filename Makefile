# SPDX-License-Identifier: AGPL-3.0

#    -----------------------------------------------------
#    Copyright © 2024, 2025, 2026  Pellegrino Prevete
#
#    All rights reserved
#    -----------------------------------------------------
#
#    This program is free software: you can redistribute
#    it and/or modify it under the terms of the
#    GNU Affero General Public License as published by
#    the Free Software Foundation, either version 3 of
#    the License, or (at your option) any later version.
#
#    This program is distributed in the hope that it
#    will be useful, but WITHOUT ANY WARRANTY;
#    without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#    See the GNU Affero General Public License for
#    more details.
#
#    You should have received a copy of the
#    GNU Affero General Public License
#    along with this program.
#    If not, see <https://www.gnu.org/licenses/>.

SHELL = bash
_PROJECT=android-app-utils
PREFIX ?= /usr/local
DOC_DIR=$(DESTDIR)$(PREFIX)/share/doc/$(_PROJECT)
BIN_DIR=$(DESTDIR)$(PREFIX)/bin

_INSTALL_FILE=\
  install \
    -vDm644
_INSTALL_DIR=\
  install \
    -vdm755
_INSTALL_EXE=\
  install \
    -vDm755
_MAKE_EXE=\
  chmod \
    755
_MAKE_LINK=\
  ln \
    -sv

DOC_FILES=\
  $(wildcard \
      *.rst)
SCRIPT_FILES=\
  $(wildcard \
      $(_PROJECT)/*)

all: build-man

prepare: prepare-man prepare-scripts

prepare-man:

	git \
	  submodule \
	    update \
	    --init \
	      "man" || \
	true

build-man:

	make \
	  prepare
	mkdir \
	  -p \
	  "build/man"
	cd \
	  "man"; \
	make \
	  build-man
	cp \
	  "man/build/"* \
	  "build/man"

check: shellcheck

shellcheck:

	shellcheck \
	  -s \
	    "bash" \
	  $(SCRIPT_FILES)

install: install-scripts install-doc

install-scripts:

	$(_INSTALL_EXE) \
	  "$(_PROJECT)/app-installed" \
	  "$(BIN_DIR)/app-installed"
	$(_INSTALL_EXE) \
	  "$(_PROJECT)/app-name" \
	  "$(BIN_DIR)/app-name"
	$(_MAKE_LINK) \
	  "$(PREFIX)/usr/bin/app-name" \
	  "$(BIN_DIR)/app-label" || \
	true

install-doc:

	install \
	  -vDm644 \
	  $(DOC_FILES) \
	  -t \
	  $(DOC_DIR)

uninstall: uninstall-scripts

uninstall-scripts:

	rm \
	  -vrf \
	  "$(BIN_DIR)/app-installed" \
	  "$(BIN_DIR)/app-label" \
	  "$(BIN_DIR)/app-name"

.PHONY: build-man check install install-doc install-scripts prepare prepare-man shellcheck uninstall unistall-scripts
