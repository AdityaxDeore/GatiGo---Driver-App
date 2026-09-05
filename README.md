# 🛺 Pink Auto Driver App

> [!IMPORTANT]
> **PROPRIETARY & CONFIDENTIAL**  
> This repository is a private corporate project and is the sole property of the company. It is not an open-source project. Access, distribution, or reproduction of this codebase without prior authorization is strictly prohibited.

A specialized driver-partner application for the **Pink Auto** ride-hailing network, built using **Flutter (Material 3)** and **Clean Architecture**.

The app empowers auto-rickshaw drivers (both standard auto drivers and women drivers for Pink Autos) to receive ride dispatches, manage trips, complete onboarding and KYC, and track rides in real time.

---

## 🛠️ Flutter Development Guide

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (3.24+ / 3.44+)
- [Android Studio / Android SDK](https://developer.android.com/studio) or VS Code with Flutter extension
- Java 17 or Java 21 JDK (`JAVA_HOME`)

### Dependencies
Fetch the project dependencies:
```bash
flutter pub get
```

### Running the Application

To launch the app on your connected Android device or emulator:
```bash
flutter run
```

To run on Chrome / Web Server:
```bash
flutter run -d chrome
```
or use the included script:
```bash
start-dev.cmd
```

### Running Tests and Linting
```bash
flutter analyze
flutter test
```

---

## 📱 Feature Overview

1. **Authentication (`/phone-auth`)**: Driver phone authentication with OTP verification.
2. **Registration & KYC (`/registration`, `/verification-status`)**:
   - Driver personal info and license validation
   - Vehicle type selection (Standard Auto or Pink Auto)
   - Aadhaar, Driving License, RC, and Permit uploads
   - Document verification status tracking
3. **Driver Dispatch Dashboard (`/home`)**:
   - Online/Offline availability toggle
   - Real-time ride request modal with countdown and fare summary
   - Interactive pickup navigation with passenger details
   - Arrival at pickup confirmation
   - In-transit navigation card with drop-off destination
   - Ride completion receipt with fare breakdown and rating
4. **Multilingual Support**: English, Hindi, and Marathi localized dynamically via `LanguageCubit`.
