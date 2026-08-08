SHELL := /bin/bash
ROOT := $(CURDIR)
DISTRO_DIR := $(ROOT)/distro
KERNEL_SRC ?=
PROFILE ?= desktop

.PHONY: help validate commercial-gates iso first-party-debs dev-repo research-kernel research-iso research-smoke production-kernel production-module package clean
help:
	@echo "Targets:"
	@echo "  validate | commercial-gates | iso | first-party-debs | dev-repo"
	@echo "  research-kernel | research-iso | research-smoke"
	@echo "  production-module | production-kernel KERNEL_SRC=/path PROFILE=desktop"
	@echo "  package | clean"
validate:
	@./ci/validate.sh
commercial-gates:
	@./ci/commercial-gates.sh
iso: validate
	@cd "$(DISTRO_DIR)" && ./build.sh
first-party-debs:
	@./tools/build-first-party-debs.py
dev-repo: first-party-debs
	@./tools/build-dev-repository.sh
research-kernel:
	@./kernel/experimental/scripts/build.sh
research-iso: research-kernel
	@./kernel/experimental/scripts/make-iso.sh
research-smoke:
	@./kernel/experimental/scripts/qemu-smoke.sh
production-module:
	@kdir=$$(find /usr/src -maxdepth 1 -type d -name 'linux-headers-*-amd64' | sort -V | tail -n1); \
	[[ -n $$kdir ]] || { echo "Debian amd64 kernel headers not found" >&2; exit 2; }; \
	KDIR="$$kdir" ./kernel/production/scripts/build-identity-module.sh
production-kernel:
	@if [[ -z "$(KERNEL_SRC)" ]]; then echo "Set KERNEL_SRC=/path/to/linux-source" >&2; exit 2; fi
	@./kernel/production/scripts/prepare-source.sh "$(KERNEL_SRC)" "$(PROFILE)" -privora4.0rc2-amd64
	@./kernel/production/scripts/source-provenance.sh "$(KERNEL_SRC)" kernel/production/build/source-provenance.json
	@./kernel/production/scripts/build.sh "$(KERNEL_SRC)"
package: validate
	@./tools/make-rc1-artifacts.sh
clean:
	@rm -rf kernel/experimental/build/* release/.deb-work
	@if command -v lb >/dev/null 2>&1; then cd "$(DISTRO_DIR)" && lb clean --purge || true; fi
