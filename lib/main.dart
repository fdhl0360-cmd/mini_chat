name: Build Mini Chat APK

on:
  workflow_dispatch:
  push:
    branches:
      - main

permissions:
  contents: read

jobs:
  build:
    name: Build APK
    runs-on: ubuntu-latest
    timeout-minutes: 45

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Java
        uses: actions/setup-java@v4
        with:
          distribution: temurin
          java-version: "17"

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: "3.35.3"
          channel: stable
          cache: true

      - name: Create Android project
        run: flutter create . --platforms=android

      - name: Fix Kotlin version
        run: |
          sed -i 's/id("org.jetbrains.kotlin.android") version "[^"]*" apply false/id("org.jetbrains.kotlin.android") version "2.3.0" apply false/' android/settings.gradle.kts

      - name: Fix Java and Kotlin targets
        run: |
          sed -i 's/JavaVersion.VERSION_11/JavaVersion.VERSION_17/g' android/app/build.gradle.kts

          sed -i '/kotlinOptions {/,/}/c\
              kotlin {\
                  compilerOptions {\
                      jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)\
                  }\
              }' android/app/build.gradle.kts

      - name: Add Firebase packages
        run: |
          flutter pub add firebase_core
          flutter pub add firebase_auth
          flutter pub add cloud_firestore

      - name: Add Firebase configuration
        run: |
          mkdir -p android/app
          cp google-services.json android/app/google-services.json

          sed -i '/id("dev.flutter.flutter-plugin-loader")/a\    id("com.google.gms.google-services") version "4.4.4" apply false' android/settings.gradle.kts

          sed -i '/id("dev.flutter.flutter-gradle-plugin")/a\    id("com.google.gms.google-services")' android/app/build.gradle.kts

      - name: Get dependencies
        run: flutter pub get

      - name: Build APK
        run: flutter build apk --release

      - name: Upload APK
        uses: actions/upload-artifact@v4
        with:
          name: mini-chat-apk
          path: build/app/outputs/flutter-apk/app-release.apk
