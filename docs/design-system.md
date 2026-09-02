# 🎨 Design System

The Pink Auto design system is implemented in `lib/core/theme/` and `lib/core/mds/`. It provides a consistent, premium visual language across the entire application.

---

## Color Palette

| Token | Hex | Usage |
|---|---|---|
| `primaryPink` | `#FA4EAB` (Electric Rose) | Primary actions, buttons, active indicators |
| `secondaryPink` | `#FE83C6` (Soft Magenta) | Gradients, secondary highlights |
| `accentPurple` | `#4B0082` (Indigo / Amethyst) | Text buttons, trust indicators, SOS |
| `backgroundLight` | `#FFF2F9` (Blush Mist) | Scaffold background |
| `backgroundWhite` | `#FFFFFF` | Card surfaces, input fills |
| `textDark` | `#323232` | Primary body and heading text |
| `textLight` | `#757575` | Placeholder and secondary text |
| `textOnPrimary` | `#FFFFFF` | Text on pink buttons |
| `success` | `#4CAF50` | Positive feedback, confirmation states |
| `error` | `#E53935` | Validation errors, destructive actions |

All tokens are declared as `static const Color` values inside `PinkAppTheme` in [`lib/core/theme/theme.dart`](../lib/core/theme/theme.dart).

---

## Typography Scale

The app uses Flutter Material 3's `TextTheme`. All styles are configured in `PinkAppTheme.lightTheme`.

| Style Token | Size | Weight | Usage |
|---|---|---|---|
| `headlineLarge` | 32 sp | Bold (700) | Hero headings, onboarding title |
| `headlineMedium` | 24 sp | ExtraBold (800) | Screen titles |
| `titleLarge` | 20 sp | Bold (700) | Card titles, section headers |
| `bodyLarge` | 16 sp | Regular | Main body copy, descriptions |
| `bodyMedium` | 14 sp | Regular | Secondary text, captions |

> [!TIP]
> For any text that needs to be localized, use `TranslatedText` from `lib/core/localization/translated_text.dart` instead of a plain `Text` widget.

---

## Spacing & Shape

| Concept | Value |
|---|---|
| Default button radius | `16.0` px |
| Input field radius | `16.0` px |
| Card / sheet radius | `16–24` px |
| Button vertical padding | `16.0` px |
| Content padding (inputs) | `18.0` px all sides |

---

## Modular Design System (MDS)

Reusable UI components live in `lib/core/mds/widgets/`. Always prefer these components over ad-hoc implementations.

### `MdsButton` — [`mds_button.dart`](../lib/core/mds/widgets/mds_button.dart)

A full-width primary action button styled with the pink gradient and `16 px` rounded corners.

```dart
MdsButton(
  label: 'Book Ride',
  onPressed: () => /* action */,
)
```

---

### `MdsPhoneInputField` — [`mds_phone_input_field.dart`](../lib/core/mds/widgets/mds_phone_input_field.dart)

A formatted phone number input with a `+91` country prefix, 10-digit validation, and pink focus border.

```dart
MdsPhoneInputField(
  controller: _controller,
  onChanged: (val) => /* validate */,
)
```

---

### `MdsOtpInput` — [`mds_otp_input.dart`](../lib/core/mds/widgets/mds_otp_input.dart)

A 6-cell OTP entry row. Each cell auto-advances focus on digit entry and auto-retreats on backspace.

```dart
MdsOtpInput(
  onCompleted: (otp) => /* verify */,
)
```

---

### `MdsPageIndicator` — [`mds_page_indicator.dart`](../lib/core/mds/widgets/mds_page_indicator.dart)

Animated dot row for carousel/onboarding screens. Active dot expands and fills with `primaryPink`.

```dart
MdsPageIndicator(
  count: 3,
  currentIndex: _currentPage,
)
```

---

### `PinkAutoCapsuleSearchBar` — [`pink_auto_capsule_search_bar.dart`](../lib/core/mds/widgets/pink_auto_capsule_search_bar.dart)

A pill-shaped search bar used on the Home screen to trigger the destination search flow.

---

### `PinkAutoMiniShortcutChip` — [`pink_auto_mini_shortcut_chip.dart`](../lib/core/mds/widgets/pink_auto_mini_shortcut_chip.dart)

Compact, tappable chip for quick-access shortcuts (e.g., "Home", "Work") on the home map overlay.

---

### `SosHoldButton` — [`sos_hold_button.dart`](../lib/core/mds/widgets/sos_hold_button.dart)

A press-and-hold animated emergency button. Displays a radial progress animation; triggers SOS callback on completion. Requires a minimum hold duration to prevent accidental activation.

```dart
SosHoldButton(
  onSosTriggered: () => /* show SOS modal */,
)
```

---

## Theme Access

Access the theme in any widget via `Theme.of(context)` or the extension shorthand:

```dart
// Colors
final pink = Theme.of(context).colorScheme.primary;
final purple = Theme.of(context).colorScheme.tertiary;

// Text styles
final heading = Theme.of(context).textTheme.headlineLarge;
```

Direct access to static tokens:

```dart
import 'package:pink_auto/core/theme/theme.dart';

Container(color: PinkAppTheme.primaryPink)
```
