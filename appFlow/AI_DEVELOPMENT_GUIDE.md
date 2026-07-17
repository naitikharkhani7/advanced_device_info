# Advanced Device Info Plugin - Development Instructions

## Project Overview

You are developing a production-ready Flutter plugin named **advanced_device_info**.

This plugin will become a high-quality open-source package for pub.dev and should follow Flutter best practices, clean architecture, proper documentation, and production-ready code.

Do not generate unnecessary code or placeholder implementations. Every implementation should be production-ready.

---

# Important Rules

Before writing any code, always read the documentation files in the following order.

## Documentation Reading Order

1. README.md
2. ROADMAP.md
3. FEATURES.md
4. API_REFERENCE.md
5. ARCHITECTURE.md
6. TODO.md
7. CHANGELOG.md
8. CONTRIBUTING.md
9. PUB_DEV_CHECKLIST.md
10. EXAMPLE.md

Never skip this order.

---

# Development Rules

Always complete one task at a time.

Never start implementing multiple features simultaneously.

Always complete the current task before moving to the next one.

Every feature must compile successfully before proceeding.

Every implementation must work on a real device.

No mock implementation.

No fake data.

No TODO implementations.

No placeholder methods.

---

# Documentation Rules

Whenever a feature is completed,

update

- README.md
- FEATURES.md
- CHANGELOG.md
- TODO.md

Documentation should always remain synchronized with the source code.

---

# Architecture Rules

Follow Flutter plugin architecture.

Flutter

↓

MethodChannel

↓

Android (Kotlin)

↓

iOS (Swift)

↓

Native APIs

↓

Flutter API

Never place Android logic inside Dart.

Never place iOS logic inside Dart.

Only expose clean Dart APIs.

---

# Folder Rules

Do not change the existing project structure unless necessary.

Keep source code organized.

Separate

- Dart
- Android
- iOS
- Example

properly.

---

# Coding Standards

Use

- Dart Style Guide
- Effective Dart
- Flutter Lints
- Null Safety

Avoid code duplication.

Keep methods small.

Keep files modular.

Always document public APIs.

---

# Error Handling

Every public API should

- validate input
- catch native exceptions
- return meaningful errors
- never crash Flutter

---

# Platform Support

Current target

✅ Android

✅ iOS

Desktop and Web support will be added later.

Do not generate desktop code unless explicitly requested.

---

# Performance

Avoid unnecessary MethodChannel calls.

Cache values when appropriate.

Avoid blocking the UI thread.

Native code should be efficient.

---

# API Design

Public API should remain simple.

Example

```dart
final info = await AdvancedDeviceInfo.getDeviceInfo();
```

Avoid exposing native implementation details.

---

# Testing

Every completed feature should be tested on

Android Emulator

Android Physical Device

iPhone Simulator

iPhone Physical Device (where possible)

---

# Versioning

Follow Semantic Versioning.

Major

Breaking changes

Minor

New Features

Patch

Bug Fixes

---

# Git Rules

Every completed feature should represent a logical commit.

Example

feat: add storage information

feat: add battery information

fix: calculate used storage correctly

docs: update README

---

# Development Priority

Follow exactly this order.

Phase 1

- Device Information
- Storage
- RAM
- CPU
- Screen

Phase 2

- Battery
- Network
- Locale
- Application Information

Phase 3

- Android ID
- IdentifierForVendor
- Emulator Detection
- Root Detection
- Jailbreak Detection

Phase 4

- Security
- Sensors
- Bluetooth
- NFC
- SIM
- Thermal

Phase 5

- Live Streams
- EventChannel
- Connectivity Listener
- Battery Listener

Phase 6

- Windows
- macOS
- Linux
- Web

Do not change this order.

---

# File Update Rules

Whenever a feature is completed

update

README.md

FEATURES.md

TODO.md

CHANGELOG.md

If APIs change

also update

API_REFERENCE.md

If architecture changes

update

ARCHITECTURE.md

---

# Code Quality

Before completing any task

ensure

flutter analyze

passes without warnings.

Code should be properly formatted.

No dead code.

No unused imports.

No commented production code.

---

# Objective

Build a production-ready Flutter plugin that provides comprehensive Android and iOS device information while following Flutter best practices, clean architecture, proper documentation, and pub.dev quality standards.

Never compromise code quality for speed.