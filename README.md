# 🌸 Pink Auto Customer App

> [!IMPORTANT]
> **PROPRIETARY & CONFIDENTIAL**  
> This repository is a private corporate project and is the sole property of the company. It is not an open-source project. Access, distribution, or reproduction of this codebase without prior authorization is strictly prohibited.

A premium, safety-centric auto-rickshaw ride-hailing application built using **Flutter (Material 3)** and **Clean Architecture**.

The app provides a reliable experience catering to normal rides while offering a dedicated, safety-first **Pink Auto** option powered by female drivers for female passengers and family safety.

---

## 🚀 Quick Start with Nix

This repository is equipped with a `shell.nix` environment to bootstrap all required dependencies (Java, Flutter SDK, Dart SDK, system tools) automatically.

### Prerequisites

1. Install **Nix**:
   ```bash
   curl -L https://nixos.org/nix/install | sh
   ```
2. (Optional but highly recommended) Install **direnv** and **nix-direnv** to automatically load the Nix shell when you enter the directory.

### Entering the Environment

Run the following command in the project root to load the environment:

```bash
nix-shell
```

Upon loading, you should see:
```text
=========================================================
   Pink Auto Dev Environment Loaded (Nix Shell)          
   - Flutter: <version>
   - Java (JAVA_HOME): <path>
   - Android SDK: <path>
=========================================================
```

> [!NOTE]
> The shell automatically detects your Android SDK path on WSL/Linux environments. Make sure your physical device is connected, or your emulator is running.

---

## 🛠️ Flutter Development Guide

Once inside the Nix shell, manage your Flutter project with standard commands.

### Dependencies
Fetch the project dependencies:
```bash
flutter pub get
```

### Running the Application
To launch the app on your connected device or running emulator:
```bash
flutter run
```

### Running Tests
To run the full unit and widget test suite:
```bash
flutter test
```

### Static Analysis & Linting
Ensure code quality adheres to the project guidelines:
```bash
flutter analyze
```

---

## 📚 Technical & Architectural Documentation

For onboarding and deep dives into the project's internal mechanics, refer to the following private design documents:

* **[Architecture Guide](file:///d:/proj/pink_auto/docs/architecture.md)** — Clean Architecture setup, layers, and data flow.
* **[Design System & MDS Components](file:///d:/proj/pink_auto/docs/design-system.md)** — Theme tokens, style guides, and reusable widgets.
* **[Feature Breakdown](file:///d:/proj/pink_auto/docs/features.md)** — Per-feature views, state management, and navigation mappings.
* **[State Management](file:///d:/proj/pink_auto/docs/state-management.md)** — BLoC/Cubit pattern specs and ViewModels.
* **[Routing Specs](file:///d:/proj/pink_auto/docs/routing.md)** — Named routes configuration and auth guards.
* **[Localization Guide](file:///d:/proj/pink_auto/docs/localization.md)** — Tri-lingual localization implementation (English, Hindi, Marathi).
* **[Testing Strategy](file:///d:/proj/pink_auto/docs/testing.md)** — Unit and widget test execution guidelines.
* **[Private Contribution & Coding Standards](file:///d:/proj/pink_auto/docs/contributing.md)** — Team roles, handover protocols, and conventions.

---

## 🏗️ Architecture & Project Structure

The project strictly follows **Clean Architecture** and the **MVVM (Model-View-ViewModel)** design pattern. It enforces a vertical feature-slice layout to ensure scalability and decoupling.

```text
lib/
├── core/                  # Shared infrastructure & utilities
│   ├── theme/             # Premium Pink & Purple design variables
│   ├── mds/               # Modular Design System (reusable styled widgets)
│   ├── network/           # API clients & simulated services
│   └── utils/             # Helper classes & extensions
├── features/              # Feature-centric vertical slices
│   ├── onboarding/        # Value proposition carousel
│   ├── auth/              # Phone & simulated OTP login UI
│   ├── profile/           # Personal settings, Saved Places, & Safety Hub
│   └── ride_booking/      # Simulated maps, service selections, & SOS triggers
└── main.dart              # Application entry point
```

Each feature folder is structured as follows:
- **`data/`**: Data sources, repositories implementations, and models.
- **`domain/`**: Business rules, entities, and use cases interfaces.
- **`presentation/`**: Screen layouts, custom sub-widgets, and ViewModels/Blocs.

---

## 🎨 Modular Design System (MDS) Components

To ensure visual consistency, always use these components instead of standard Material or custom widgets:

1. **`MdsButton`** ([mds_button.dart](file:///d:/proj/pink_auto/lib/core/mds/widgets/mds_button.dart)) — Full-width primary action button with standard pink gradient and `16 px` corner radius.
2. **`MdsPhoneInputField`** ([mds_phone_input_field.dart](file:///d:/proj/pink_auto/lib/core/mds/widgets/mds_phone_input_field.dart)) — Standard phone number input with `+91` prefix, 10-digit validation, and pink focus border.
3. **`MdsOtpInput`** ([mds_otp_input.dart](file:///d:/proj/pink_auto/lib/core/mds/widgets/mds_otp_input.dart)) — A 6-cell interactive OTP digit entry row with auto-focus movement.
4. **`MdsPageIndicator`** ([mds_page_indicator.dart](file:///d:/proj/pink_auto/lib/core/mds/widgets/mds_page_indicator.dart)) — Animated page/dot indicators for carousel-style screens.
5. **`PinkAutoCapsuleSearchBar`** ([pink_auto_capsule_search_bar.dart](file:///d:/proj/pink_auto/lib/core/mds/widgets/pink_auto_capsule_search_bar.dart)) — Rounded pill-shaped search input for destinations.
6. **`PinkAutoMiniShortcutChip`** ([pink_auto_mini_shortcut_chip.dart](file:///d:/proj/pink_auto/lib/core/mds/widgets/pink_auto_mini_shortcut_chip.dart)) — Tappable shortcut chips (e.g. for Home/Work).
7. **`SosHoldButton`** ([sos_hold_button.dart](file:///d:/proj/pink_auto/lib/core/mds/widgets/sos_hold_button.dart)) — Press-and-hold animated safety button with circular progress loader.

---

## 🤝 Collaboration & Governance

- Detailed AI agent personas, responsibilities, and handover protocols are defined in [AGENTS.md](file:///d:/proj/pink_auto/AGENTS.md).
- The detailed project timeline, features scope, and mock integrations details are tracked in [PROJECT.md](file:///d:/proj/pink_auto/PROJECT.md).
