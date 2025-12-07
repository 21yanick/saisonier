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

# Build
build:
	flutter build apk --debug

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
	@echo "  make run      - Startet App auf Android Emulator (default)"
	@echo "  make android  - Startet App auf Android Emulator"
	@echo "  make emulator - Startet nur den Emulator"
	@echo "  make linux    - Startet App auf Linux Desktop"
	@echo "  make web      - Startet App im Chrome Browser"
	@echo "  make build    - Baut Debug APK"
	@echo "  make clean    - Bereinigt Build-Artefakte"
	@echo "  make test     - Führt Tests aus"
	@echo "  make generate - Generiert Code (Riverpod, Freezed)"
	@echo "  make deps     - Holt Dependencies"
	@echo "  make seed     - PocketBase Schema + Seed-Daten"
