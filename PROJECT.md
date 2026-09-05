# Project Governance & Architecture: Pink Auto Driver App

Welcome to the **Pink Auto Driver App** development space. This project is built as a reliable, efficient, and driver-centric application for auto-rickshaw drivers (both standard and women-driven Pink Autos).

---

## 1. Tech Stack
- **Framework**: [Flutter](https://flutter.dev) (Android, iOS & Web)
- **Language**: [Dart](https://dart.dev)
- **State Management**: BLoC / Cubit & ChangeNotifier (MVVM pattern)
- **Mapping & Geolocation**: Geolocator, Google Maps Flutter
- **Localization**: Tri-lingual (English, Hindi, Marathi) via `LanguageCubit`

---

## 2. Clean Architecture & MVVM Pattern
We adhere to Clean Architecture and MVVM (Model-View-ViewModel) design principles to separate business logic from the UI and data frameworks.

```
lib/
├── core/                         # Shared utilities, routing, themes, errors
│   ├── localization/             # LanguageCubit, language state, translations
│   ├── mds/                      # Modular Design System (MdsButton, inputs)
│   ├── storage/                  # SessionStorage for driver auth & registration
│   └── theme/                    # Pink & purple design tokens
├── features/                     # Feature-centric modules
│   ├── auth/                     # Driver phone number and OTP verification
│   ├── driver_registration/      # KYC, vehicle selection, document upload
│   └── driver_home/              # Online/offline toggle, dispatch cards, navigation
└── main.dart                     # Application root & routes
```

Within each feature (e.g., `features/driver_home/`), we structure code into:
1. **Domain**: Models (driver status, ride requests, trip states) and services (location, ride dispatch simulation).
2. **Presentation**: Screens (views), ViewModels (handling UI state and event dispatching), and feature widgets (ride cards, status banners).

---

## 3. Core Design System & Theme
- **Primary Color**: Modern Hot Pink (`0xFFFF1493`) - energetic, safe, premium.
- **Accent Color**: Deep Amethyst Purple (`0xFF4B0082`) - adds trustworthiness and high contrast.
- **Success Color**: Fresh Emerald Green (`0xFF00C853`) - online status and ride acceptances.
- **Offline / Neutral**: Cool grey, dark charcoal, and clean white.

---

## 4. Driver App Feature Roadmap
- [x] **Authentication**: Driver phone authentication with OTP verification.
- [x] **Registration & KYC**: Multi-step registration (Personal details, vehicle selection, Aadhaar/DL document uploads, verification review screen).
- [x] **Driver Dispatch Dashboard**: Online/offline toggle, simulated incoming ride request dialog with countdown, pickup navigation card, arrived pickup confirmation, drop-off navigation card, and ride completion receipt.
- [x] **Localization**: Tri-lingual support across English, Hindi, and Marathi.
