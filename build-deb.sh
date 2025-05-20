#!/bin/bash
set -e

# define build directory and output package filename
BUILD_DIR="build-deb"
PKG_FILENAME="counter-v2.0.0.deb"

# clean up previous build
if [ -d "$BUILD_DIR" ]; then
    rm -rf "$BUILD_DIR"
fi

# create directory structure
mkdir -p "$BUILD_DIR/DEBIAN"
mkdir -p "$BUILD_DIR/usr/bin"
mkdir -p "$BUILD_DIR/lib/systemd/system"

# create control file with package metadata
cat <<EOF > "$BUILD_DIR/DEBIAN/control"
Package: counter
Version: 2.0.0
Section: base
Priority: optional
Architecture: all
Maintainer: Cooper Braun
Description: A simple counter systemd service written in Python.
EOF

# create postinst script
cat <<'EOF' > "$BUILD_DIR/DEBIAN/postinst"
#!/bin/bash
set -e
# create the system user
if ! id "counter" >/dev/null 2>&1; then
    useradd --system counter
fi
# reload systemd to pick up new service file
systemctl daemon-reload
# enable and start counter service
systemctl enable counter.service
systemctl start counter.service
exit 0
EOF
chmod +x "$BUILD_DIR/DEBIAN/postinst"

# create prerm script
cat <<'EOF' > "$BUILD_DIR/DEBIAN/prerm"
#!/bin/bash
set -e
# stop counter service before package removal
systemctl stop counter.service || true
exit 0
EOF
chmod +x "$BUILD_DIR/DEBIAN/prerm"

# create postrm script
cat <<'EOF' > "$BUILD_DIR/DEBIAN/postrm"
#!/bin/bash
set -e
# reload systemd to update its configuration
systemctl daemon-reload
# remove system user
if id "counter" >/dev/null 2>&1; then
    userdel counter
fi
exit 0
EOF
chmod +x "$BUILD_DIR/DEBIAN/postrm"

# copy the python script to /usr/bin
cp bin/counter.py "$BUILD_DIR/usr/bin/counter"
chmod +x "$BUILD_DIR/usr/bin/counter"

# copy systemd service file to correct directory
cp counter.service "$BUILD_DIR/lib/systemd/system/"

# build the debian package
dpkg-deb --build "$BUILD_DIR" "$PKG_FILENAME"

echo "Debian package created: $PKG_FILENAME"