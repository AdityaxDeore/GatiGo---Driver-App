# Project Governance & Architecture: Pink Auto Customer App

Welcome to the **Pink Auto Customer App** development space. This project is built as a highly secure, reliable, and premium ride-hailing application for auto-rickshaws, emphasizing safety and choice.

## Core USP
- **Normal Autos**: Accessible rides driven by vetted male drivers.
- **Pink Autos**: Exclusive safety-first option driven by female drivers, designed specifically to cater to female passengers and family safety preferences.

---

## 1. Tech Stack
- **Framework**: [Flutter](https://flutter.dev) (iOS & Android)
- **Language**: [Dart](https://dart.dev)
- **State Management**: BLoC / Cubit (for scalable, predictable state)
- **Local Database**: Hive or Isar (for caching user profiles, active rides, and system configurations)
- **Backend / Services**: Firebase Auth (Phone Authentication), Google Maps API / OpenStreetMap (geocoding, routing), WebSocket/Firebase Realtime Database (real-time driver location updates).

---

## 2. Clean Architecture & MVVM Pattern
We adhere to Clean Architecture and MVVM (Model-View-ViewModel) design principles to separate business logic from the UI and data frameworks.

```
lib/
├── core/                  # Shared utilities, routing, themes, errors
│   ├── theme/             # Styling theme variables
│   ├── mds/               # Modular Design System (reusable UI widgets)
│   ├── network/           # API clients and network info
│   └── utils/             # Helper classes and extensions
├── features/              # Feature-centric modules (vertical slices)
│   ├── onboarding/        # Welcome and value proposition carousel
│   ├── auth/              # Phone number and OTP verification
│   ├── ride_booking/      # Map, search, auto selection, fare estimate
│   └── profile/           # User info, payment settings, ride history
└── main.dart              # Application root
```

Within each feature (e.g., `features/auth/`), we structure code into:
1. **Data**: Data sources, repositories, and models.
2. **Domain**: Repository interfaces, entities, and use cases.
3. **Presentation**: Views (screens/pages), ViewModels (handling UI state and logic via change notifiers/cubits), and component widgets.
4. **MDS (Modular Design System)**: General-purpose, theme-adhering widgets designed for component reusability.

---

## 3. Core Design System & Theme
- **Primary Color**: Modern Hot Pink (`#FF1493` / `0xFFFF1493`) - energetic, safe, premium.
- **Accent Color**: Deep Amethyst Purple (`#4B0082` / `0xFF4B0082`) - adds trustworthiness and high-contrast styling.
- **Neutral Colors**: Cool grey, white, and soft charcoal.
- **Typography**: Modern sans-serif fonts (e.g., Outfit or Inter).

---

## 4. Comprehensive UI-focused Project Roadmap

> [!NOTE]
> This project is focused entirely on **UI/UX Presentation and Frontend Design**. Real backend integration (e.g., Firebase Auth SMS, live WebSockets, Google Places APIs, production payment gateways) is out of scope. All interactive features are powered by mock data and simulated transitions.

### Phase 1: Planning, Setup & Architecture (Completed)
- [x] Establish Clean Architecture folder structure.
- [x] Configure the Design System & Pink Theme variables.
- [x] Create project governance documentation (`PROJECT.md` and `AGENTS.md`).
- [x] Build Modular Design System (MDS) reusable components (text fields, custom buttons, search bars).

### Phase 2: Authentication & Profile UI
- [x] Build onboarding flow screen with service value proposition.
- [x] Build phone number entry screen with 10-digit validation.
- [x] Build OTP entry verification UI mock.
- [x] Design and implement the User Profile & Emergency Contacts/Saved Places setup screen UI.
- [x] Add tri-lingual localization (English, Hindi, Marathi) with offline static dictionary and zero-cost client-side dynamic GTX translation.

### Phase 3: Simulated Location & Map UI
- [x] Build Home View with live zero-cost Google Maps centered dynamically using device geolocation.
- [x] Build standalone Saved Places configuration view.
- [x] Build search destination lookup overlay sheet (for address entry).
- [x] Render simulated route paths and mock auto-rickshaw location markers on the canvas.

### Phase 4: Service Selection & Booking UI
- [x] Build side-by-side Auto Service cards (Standard Auto vs. Pink Auto) with custom visual indicators.
- [x] Build fare estimation, selection, and booking confirmation sheet layout.
- [x] Build loading/matching state screen layout with animation placeholder.

### Phase 5: Live Ride Tracking & Safety UI
- [x] Build interactive Emergency SOS modal dialogue and notification triggers.
- [x] Build active ride tracking screen UI (showing driver details, vehicle info, and ETA badge).
- [x] Build "Share Ride Status" sheets to send mock updates to emergency contacts.

### Phase 6: Payment Selection & Feedback UI
- [x] Design payment option selection bottom sheets (Cash, UPI, Cards mockup).
- [x] Design post-ride completion receipt & driver rating screen UI.

### Phase 7: UI Verification & Polish (Completed)
- [x] Run linter checks and fix any formatting/warning items (Verified zero issues with `flutter analyze`).
- [x] Perform device responsiveness audits (verify safe areas, custom overlays, and layouts on various screen sizes; verified all 29 widget tests are passing).
