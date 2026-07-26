ENV_FILE := .env
DEFINE := --dart-define-from-file=$(ENV_FILE)

# Optional: make run DEVICE=chrome / DEVICE=<device-id from `flutter devices`)
DEVICE_FLAG := $(if $(DEVICE),-d $(DEVICE),)

.PHONY: devices run run-local run-lan build-web deploy build-apk build-appbundle build-ios clean

devices: ## list available devices (simulators, emulators, phones, chrome)
	flutter devices

run: ## flutter run against production API (.env). Add DEVICE=<id> to target a specific device
	flutter run $(DEFINE) $(DEVICE_FLAG)

run-local: ## flutter run against Android emulator loopback (.env.local). Add DEVICE=<id>
	flutter run --dart-define-from-file=.env.local $(DEVICE_FLAG)

run-lan: ## flutter run against your machine's LAN IP, for a real device on same WiFi/hotspot (.env.lan). Add DEVICE=<id>
	flutter run --dart-define-from-file=.env.lan $(DEVICE_FLAG)

build-web: ## release web build
	flutter build web --wasm --release $(DEFINE)

deploy: build-web ## build web + deploy to Firebase Hosting
	firebase deploy --only hosting

build-apk: ## release APK
	flutter build apk --release $(DEFINE)

build-appbundle: ## release App Bundle (Play Store)
	flutter build appbundle --release $(DEFINE)

build-ios: ## release iOS build
	flutter build ios --release $(DEFINE)

clean:
	flutter clean && flutter pub get
