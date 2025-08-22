# SPDX-License-Identifier: GPL-3.0-or-later

#    ----------------------------------------------------------------------
#    Copyright © 2024, 2025  Pellegrino Prevete
#
#    All rights reserved
#    ----------------------------------------------------------------------
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Affero General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Affero General Public License for more details.
#
#    You should have received a copy of the GNU Affero General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.

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

DOC_FILES=\
  $(wildcard *.rst)
SCRIPT_FILES=\
  $(wildcard $(_PROJECT)/*)

_INSTALL_DOC_TARGETS=\
  install-doc \
  install-man
_INSTALL_TARGETS=\
  $(_INSTALL_DOC_TARGETS) \
  install-scripts
_CHECK_TARGETS=\
  shellcheck

_PHONY_TARGETS=\
  check \
  $(_CHECK_TARGETS) \
  install \
  $(_INSTALL_TARGETS)

all:

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

.PHONY: $(_PHONY_TARGETS)
