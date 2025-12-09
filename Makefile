# Saisonier - Development Makefile
.PHONY: run android linux web emulator clean build test

# Default: Android Emulator
run: android

# Android Emulator (startet automatisch falls nötig)
android:
	@./run.sh

# Nur Emulator starten
emulator:
	@./run.sh --emulator-only

# Linux Desktop (funktioniert nicht mit Snap Flutter wegen libsecret)
linux:
	flutter run -d linux

# Chrome Web
web:
	flutter run -d chrome

# Build (Debug APK - Local)
build:
	flutter build apk --debug

# Build Release APK für Live Server
apk:
	flutter build apk --release \
		--dart-define=PB_URL=https://saisonier-api.21home.ch

# Build Debug APK für Live Server (zum Testen)
apk-debug:
	flutter build apk --debug \
		--dart-define=PB_URL=https://saisonier-api.21home.ch

# Build App Bundle für Play Store
aab:
	flutter build appbundle --release \
		--dart-define=PB_URL=https://saisonier-api.21home.ch

# Clean
clean:
	flutter clean

# Tests
test:
	flutter test

# Code Generation (Riverpod, Freezed, etc.)
generate:
	dart run build_runner build --delete-conflicting-outputs

# Watch mode für Code Generation
watch:
	dart run build_runner watch --delete-conflicting-outputs

# Alle Abhängigkeiten holen
deps:
	flutter pub get

# PocketBase Seed (Schema + Daten)
seed:
	dart run tool/seed_data.dart

# Hilfe
help:
	@echo "Saisonier Development Commands:"
	@echo ""
	@echo "  Development:"
	@echo "    make run       - Startet App auf Android Emulator (lokale DB)"
	@echo "    make android   - Startet App auf Android Emulator"
	@echo "    make emulator  - Startet nur den Emulator"
	@echo "    make linux     - Startet App auf Linux Desktop"
	@echo "    make web       - Startet App im Chrome Browser"
	@echo ""
	@echo "  Build (Production):"
	@echo "    make apk       - Release APK für Live Server"
	@echo "    make apk-debug - Debug APK für Live Server (zum Testen)"
	@echo "    make aab       - App Bundle für Play Store"
	@echo "    make build     - Debug APK (lokale DB)"
	@echo ""
	@echo "  Utilities:"
	@echo "    make generate  - Code Generation (Riverpod, Freezed)"
	@echo "    make watch     - Watch mode für Code Generation"
	@echo "    make deps      - Dependencies holen"
	@echo "    make clean     - Build-Artefakte bereinigen"
	@echo "    make test      - Tests ausführen"
	@echo "    make seed      - PocketBase Schema + Seed-Daten"
