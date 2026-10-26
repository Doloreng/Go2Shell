#!/bin/bash
# Rebuild the applets with this Mac's osacompile, so the stub matches the current system.
set -euo pipefail
cd "$(dirname "$0")"

build_one() {
	local name="$1"
	local src="scripts/${name}.applescript"
	local app="${name}.app"
	local work icon plist

	work="$(mktemp -d)"
	icon="$(mktemp)"

	if [[ -f "${app}/Contents/Resources/applet.icns" ]]; then
		cp "${app}/Contents/Resources/applet.icns" "$icon"
	fi

	osacompile -o "${work}/${name}.app" "$src"

	if [[ -s "$icon" ]]; then
		cp "$icon" "${work}/${name}.app/Contents/Resources/applet.icns"
	fi
	rm -f "${work}/${name}.app/Contents/Resources/Assets.car"

	plist="${work}/${name}.app/Contents/Info.plist"
	/usr/libexec/PlistBuddy -c "Set :CFBundleName go2shell" "$plist"
	/usr/libexec/PlistBuddy -c "Add :CFBundleIdentifier string com.apple.ScriptEditor.id.go2shell" "$plist"
	/usr/libexec/PlistBuddy -c "Add :CFBundleShortVersionString string 1.0" "$plist"
	/usr/libexec/PlistBuddy -c "Delete :CFBundleIconName" "$plist"

	codesign --force --deep --sign - "${work}/${name}.app"
	rm -rf "$app"
	cp -R "${work}/${name}.app" "$app"
	xattr -cr "$app" || true
	rm -rf "$work"
	rm -f "$icon"
	echo "built ${app}"
}

build_one Go2Shell_iTerm
build_one Go2Shell_iTerm_newWin
build_one Go2Shell_Term
build_one Go2Shell_Term_newWin
