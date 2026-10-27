# The arizona this client is built and tested against: the release tag pinned in
# .arizona-version, cloned into _arizona by `make arizona`. Point ARIZONA_DIR at
# another checkout (e.g. ../arizona) to try a client change against unreleased
# arizona code; CI always uses the pin.
ARIZONA_VERSION := $(shell cat .arizona-version)
ARIZONA_DIR ?= _arizona

.PHONY: arizona build test dev server

# Bundle the app. Needs app icons (`npm run tauri icon <path>`).
build:
	npm install && npm run build

# Compile the shell and run its Rust unit tests (no display needed).
test:
	cd src-tauri && cargo test

# The shell in dev mode (devtools on), loading ARIZONA_URL (default
# http://localhost:4040/os, served by `make server`).
dev:
	npm install && npm run dev

# Clone the pinned arizona release and install its JS deps (the e2e server
# builds the Vite bundle).
arizona:
	git clone --quiet --depth 1 --branch $(ARIZONA_VERSION) https://github.com/arizona-framework/arizona.git _arizona
	cd _arizona && npm ci

# Arizona's e2e test server on :4040, which serves the /os demo.
server:
	cd $(ARIZONA_DIR) && PORT=4040 ./scripts/start_test_server.sh
