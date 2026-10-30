#!/usr/bin/env bash
# The release files (`release.build` in yggdrasil.yml), run on the release agent from the checkout of the
# release's tag. It ports the Linux jobs of the old build.yml (web, android, linux); the Windows build is the
# release-windows.yml workflow. Everything lands in dist/, one file per platform, named with the version:
#
#   dist/fortuna-ui-web-<version>.zip
#   dist/fortuna-ui-linux-x64-<version>.tar.gz
#   dist/fortuna-ui-android-<version>-debug-signed.apk
#
# RELEASE_VERSION is the tag without its v (set by the pipeline; "dev" when this is run by hand).
# Like the old workflow, the desktop builds are the client only: the installer and the portable archive with
# the Fortuna core library (IR-21) wait for that library (artur-rios/fortuna-api#156). The Android APK is
# signed with the debug key, as android/app/build.gradle.kts does for a release build until a signing config
# exists (there is no release keystore, so no release credential), and is named for that. Do not distribute it.
#
# The Linux build needs desktop packages the Flutter image may not carry; they are installed with apt when
# this runs as root, as it does on the release agent.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
root=$PWD

# shellcheck source=ci/flutter-env.sh
source ci/flutter-env.sh

version=${RELEASE_VERSION:-dev}
rm -rf dist
mkdir dist

flutter pub get

# ---- Web ----
flutter build web --release
(cd build/web && zip -qr "$root/dist/fortuna-ui-web-$version.zip" .)

# ---- Android ----
flutter build apk --release
cp build/app/outputs/flutter-apk/app-release.apk "dist/fortuna-ui-android-$version-debug-signed.apk"

# ---- Linux ----
# libsecret-1-dev is not part of Flutter's generic desktop list: it is flutter_secure_storage_linux's own
# dependency, and the session token lives in libsecret, so it is not optional here.
packages=(clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev libstdc++-12-dev libsecret-1-dev)
missing=()
for package in "${packages[@]}"; do
  dpkg -s "$package" >/dev/null 2>&1 || missing+=("$package")
done
if [ "${#missing[@]}" -gt 0 ]; then
  if [ "$(id -u)" -ne 0 ]; then
    echo "ci/release-build.sh: ${missing[*]} must be installed to build for Linux, and this is not run as root" >&2
    exit 1
  fi
  apt-get update
  apt-get install -y --no-install-recommends "${missing[@]}"
fi
flutter build linux --release
tar -czf "dist/fortuna-ui-linux-x64-$version.tar.gz" -C build/linux/x64/release/bundle .

ls -l dist
