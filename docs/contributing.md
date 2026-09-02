# 🤝 Private Contribution & Guidelines

> [!IMPORTANT]
> **PROPRIETARY & PRIVATE REPOSITORY**  
> This project is a proprietary, closed-source corporate asset. All contributions, documentation, code conventions, and workflows described herein are intended solely for authorized internal developers and agents working on behalf of the company. Sharing code or architectural details outside the company is strictly prohibited.

This document describes the collaboration conventions, agent roles, coding standards, and handover protocols for the Pink Auto Customer App.

---

## Agent Roles

The project is developed collaboratively by four AI agent personas. Each has a defined scope.

| Agent | Focus | Primary Code Locations |
|---|---|---|
| **Architect Agent** | App structure, routing, global state, caching, DI | `main.dart`, `core/storage/`, repository interfaces |
| **UI/UX Designer Agent** | Visual components, theme, MDS widgets, animations | `core/theme/`, `core/mds/`, shared widget folders |
| **Feature Developer Agent** | Business logic, ViewModels, BLoCs, API wiring | `features/*/presentation/`, `features/*/domain/` |
| **QA & Verification Agent** | Testing, linting, performance audits | `test/`, `analysis_options.yaml` |

For the full agent governance spec, see [`AGENTS.md`](../AGENTS.md).

---

## Handover Protocols

### Protocol A — New Feature Launch

```
1. UI/UX Agent   → Creates screen layout & MDS widgets
2. Feature Dev   → Integrates ViewModel/BLoC into screen
3. Feature Dev   → Connects data repository (mock or real)
4. QA Agent      → Writes tests, runs analyzer, signs off
```

### Protocol B — Bug Resolution

```
1. QA Agent      → Isolates the bug (Presentation / Domain / Data layer)
2. UI/UX Agent   ← layout/animation bugs
   Feature Dev   ← logic/async bugs
3. QA Agent      → Validates fix with regression test
```

---

## Coding Conventions

### Dart / Flutter Style
- Follow the [`analysis_options.yaml`](../analysis_options.yaml) linting rules (extends `package:flutter_lints/flutter.yaml`).
- All public symbols must have a Dart doc comment (`///`).
- Prefer `const` constructors wherever possible.
- Class names: `PascalCase`. Variables, methods: `camelCase`. Files: `snake_case.dart`.

### File Naming
```
# Screens & Views
my_feature_screen.dart
my_feature_view.dart

# ViewModels & Cubits
my_feature_viewmodel.dart
my_feature_cubit.dart
my_feature_state.dart

# MDS Widgets
mds_<component_name>.dart
pink_auto_<component_name>.dart

# Tests (mirror lib/ structure)
my_feature_screen_test.dart
```

### Widget Guidelines
- Use `MdsButton` instead of raw `ElevatedButton`.
- Use `TranslatedText` instead of `Text` for any user-visible strings.
- Use `PinkAppTheme.*` color constants — never hardcode hex values inside feature files.
- All screen root widgets should be `Scaffold` wrapped.

---

## Adding a New Feature

1. **Create the folder structure**:
   ```
   lib/features/<feature_name>/
   ├── data/                # (if needed)
   ├── domain/              # (if needed)
   └── presentation/
       ├── views/
       ├── viewmodels/ or bloc/
       └── widgets/         # (if needed)
   ```

2. **Register the route** in `main.dart`:
   ```dart
   '/<route-name>': (context) => const MyNewView(),
   ```

3. **Add BLoC provider** to `MultiBlocProvider` in `main.dart` if the feature has a global Cubit.

4. **Add localization keys** to `LanguageCubit` for all user-visible strings.

5. **Write tests** under `test/features/<feature_name>/`.

6. **Run checks** before committing:
   ```bash
   flutter analyze
   flutter test
   ```

---

## Dependencies

| Package | Version | Purpose |
|---|---|---|
| `flutter_bloc` | `^9.1.1` | BLoC / Cubit state management |
| `flutter_svg` | `^2.3.0` | SVG asset rendering |
| `permission_handler` | `^11.3.1` | Location & camera permissions |
| `image_picker` | `^1.1.2` | Profile photo selection |
| `flutter_lints` | `^3.0.0` | Dart linting (dev only) |

> [!CAUTION]
> Do not add new dependencies without discussion. This project deliberately keeps its dependency footprint minimal to ensure build reproducibility and performance.

---

## Environment Setup

See [`README.md`](../README.md) for full setup instructions using the **Nix shell** environment.

Quick start:
```bash
nix-shell           # Load dev environment
flutter pub get     # Install dependencies
flutter run         # Launch on device/emulator
flutter test        # Run test suite
flutter analyze     # Run static analysis
```
