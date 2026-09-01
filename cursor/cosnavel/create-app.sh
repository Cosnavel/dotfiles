#!/usr/bin/env bash
# =============================================================================
# create-app.sh — "Cursor Cosnavel.app" erzeugen
# =============================================================================
# Baut eine zweite Cursor-Instanz als eigene macOS-App: gleiche Cursor.app,
# aber mit eigenem User-Data-Dir (~/.cursor-cosnavel) und eigener Bundle-ID,
# damit sie im Dock als separate App mit eigenem Login/Account läuft.
#
# Voraussetzung: /Applications/Cursor.app ist installiert.
# Idempotent — überschreibt eine vorhandene Wrapper-App.
# =============================================================================
set -euo pipefail

SOURCE_APP="/Applications/Cursor.app"
TARGET_APP="/Applications/Cursor Cosnavel.app"
USER_DATA_DIR="$HOME/.cursor-cosnavel"

[ -d "$SOURCE_APP" ] || { echo "FEHLER: $SOURCE_APP nicht gefunden — erst Cursor installieren."; exit 1; }

mkdir -p "$USER_DATA_DIR"
rm -rf "$TARGET_APP"
mkdir -p "$TARGET_APP/Contents/MacOS" "$TARGET_APP/Contents/Resources"

# Info.plist von Cursor übernehmen und umbenennen (behält URL-Schemes & Dateitypen)
cp "$SOURCE_APP/Contents/Info.plist" "$TARGET_APP/Contents/Info.plist"
/usr/libexec/PlistBuddy \
  -c 'Set :CFBundleIdentifier com.local.cursor.cosnavel' \
  -c 'Set :CFBundleName Cursor Cosnavel' \
  -c 'Set :CFBundleExecutable CursorCosnavel' \
  "$TARGET_APP/Contents/Info.plist"
/usr/libexec/PlistBuddy -c 'Set :CFBundleDisplayName Cursor Cosnavel' "$TARGET_APP/Contents/Info.plist" 2>/dev/null \
  || /usr/libexec/PlistBuddy -c 'Add :CFBundleDisplayName string Cursor Cosnavel' "$TARGET_APP/Contents/Info.plist"
# Electron-Integritäts-Check gilt nur für die echte App — im Wrapper entfernen
/usr/libexec/PlistBuddy -c 'Delete :ElectronAsarIntegrity' "$TARGET_APP/Contents/Info.plist" 2>/dev/null || true

# Icon übernehmen
cp "$SOURCE_APP/Contents/Resources/Cursor.icns" "$TARGET_APP/Contents/Resources/Cursor.icns"

# Launcher: echte Cursor.app mit eigenem User-Data-Dir starten
cat > "$TARGET_APP/Contents/MacOS/CursorCosnavel" <<WRAPPER
#!/bin/bash
exec "$SOURCE_APP/Contents/MacOS/Cursor" --user-data-dir="\$HOME/.cursor-cosnavel" "\$@"
WRAPPER
chmod +x "$TARGET_APP/Contents/MacOS/CursorCosnavel"

# Ad-hoc signieren, damit macOS die lokal gebaute App ohne Murren startet
codesign --force -s - "$TARGET_APP" 2>/dev/null || true

echo "OK: '$TARGET_APP' erzeugt (User-Data: $USER_DATA_DIR)"
