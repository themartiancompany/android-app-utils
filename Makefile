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
MAN_DIR?=$(DESTDIR)$(PREFIX)/share/man

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

_BUILD_TARGETS=\
  build-man
_INSTALL_DOC_TARGETS=\
  install-doc \
  install-man
_INSTALL_TARGETS=\
  $(_INSTALL_DOC_TARGETS) \
  install-scripts
_PREPARE_TARGETS=\
  prepare-man
_UNINSTALL_TARGETS=\
  uninstall-man \
  uninstall-scripts
_CHECK_TARGETS=\
  shellcheck

_PHONY_TARGETS=\
  $(_BUILD_TARGETS) \
  check \
  $(_CHECK_TARGETS) \
  install \
  $(_INSTALL_TARGETS) \
  $(_UNINSTALL_TARGETS) \
  uninstall

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

install: $(_INSTALL_TARGETS)

shellcheck:

	shellcheck \
	  -s \
	    "bash" \
	  $(SCRIPT_FILES)

install-scripts:

	$(_INSTALL_EXE) \
	  "$(_PROJECT)/app-installed" \
	  "$(BIN_DIR)/app-installed"
	$(_INSTALL_EXE) \
	  "$(_PROJECT)/app-name" \
	  "$(BIN_DIR)/app-name"
	$(_MAKE_LINK) \
	  "$(PREFIX)/bin/app-name" \
	  "$(BIN_DIR)/app-label" || \
	true

install-doc:

	$(_INSTALL_FILE) \
	  $(DOC_FILES) \
	  -t \
	  $(DOC_DIR)

install-man:

	$(_INSTALL_DIR) \
	  "$(MAN_DIR)/man1"
	rst2man \
	  "man/app-installed.1.rst" \
	  "$(MAN_DIR)/man1/app-installed.1"
	rst2man \
	  "man/app-name.1.rst" \
	  "$(MAN_DIR)/man1/app-name.1"
	rst2man \
	  "man/app-name.1.rst" \
	  "$(MAN_DIR)/man1/app-label.1"

uninstall: uninstall-scripts

uninstall-scripts:

	rm \
	  -vrf \
	  "$(BIN_DIR)/app-installed" \
	  "$(BIN_DIR)/app-label" \
	  "$(BIN_DIR)/app-name"

.PHONY: $(_PHONY_TARGETS)
