# variables
PKG_NAME	:= counter
VERSION		:= 2.0.0
ARCH		:= deb
DEB_DIR		:= build-deb
DEB_PKG		:= $(PKG_NAME)-v$(VERSION).deb
BINDIR		:= bin
SCRIPT		:= $(BINDIR)/counter.py
SERVICE		:= counter.service

.PHONY: build test clean run build-deb lint-deb

build:
	@echo "Building project..."
	@chmod +x $(SCRIPT)
	@echo "Build complete."

test:
	@echo "Running tests..."
	@PYTHONPATH=. pytest --maxfail=1 --disable-warnings -q || exit 1

run:
	@echo "Running the counter service..."
	@python3 $(SCRIPT)

clean:
	@echo "Cleaning up temporary files..."
	@rm -f $(DEB_PKG)
	@rm -rf $(DEB_DIR)
	@find . -name "*.pyc" -delete
	@find . -name "__pycache__" -delete
	@echo "Clean complete."

build-deb: build
	@echo "Building Debian package..."
	@chmod +x build-deb.sh
	@./build-deb.sh

lint-deb: build-deb
	@echo "Linting Debian package..."
	-@lintian counter-v2.0.0.deb

docker-image:
	docker build -t counter:latest .

docker-run:
	docker run --rm --mount type=bind,source=/tmp,target=/tmp counter:latest