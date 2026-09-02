# ⚙️ State Management

Pink Auto uses a **layered state management strategy**. The right tool is selected based on the scope and complexity of state.

---

## Strategy Overview

| State Scope | Approach | Package |
|---|---|---|
| App-wide / cross-feature | `Cubit` (BLoC) | `flutter_bloc` |
| Feature-local / multi-screen | `ChangeNotifier` + `ListenableBuilder` | Flutter built-in |
| Single-widget ephemeral | `StatefulWidget` + `setState` | Flutter built-in |

---

## 1. Global State — Cubits

Global cubits are provided at the app root in `main.dart` via `MultiBlocProvider`. They are accessible from any widget below the root.

### `ProfileCubit`

**Files**:
- [`lib/features/profile/presentation/bloc/profile_cubit.dart`](../lib/features/profile/presentation/bloc/profile_cubit.dart)
- [`lib/features/profile/presentation/bloc/profile_state.dart`](../lib/features/profile/presentation/bloc/profile_state.dart)

**Responsibilities**: Manages the logged-in user's profile data — name, phone number, gender, profile photo path, and emergency contacts list.

**State shape** (`ProfileState`):
```dart
class ProfileState {
  final String name;
  final String phone;
  final String? avatarPath;
  final String gender;
  final List<EmergencyContact> emergencyContacts;
}
```

**Key methods**:
```dart
context.read<ProfileCubit>().updateName('Priya');
context.read<ProfileCubit>().updateAvatarPath('/path/to/photo.jpg');
context.read<ProfileCubit>().addEmergencyContact(contact);
```

**Consuming in UI**:
```dart
BlocBuilder<ProfileCubit, ProfileState>(
  builder: (context, state) {
    return Text(state.name);
  },
)
```

---

### `LanguageCubit`

**Files**:
- [`lib/core/localization/language_cubit.dart`](../lib/core/localization/language_cubit.dart)
- [`lib/core/localization/language_state.dart`](../lib/core/localization/language_state.dart)

**Responsibilities**: Holds the active language code and exposes the translation lookup method. See [localization.md](./localization.md) for full details.

---

## 2. Feature-Local State — ViewModels (ChangeNotifier)

Used for multi-screen or multi-step flows where state doesn't need to be shared globally.

### `RideBookingViewModel`

**File**: [`lib/features/ride_booking/presentation/viewmodels/ride_booking_viewmodel.dart`](../lib/features/ride_booking/presentation/viewmodels/ride_booking_viewmodel.dart)

**Responsibilities**: Tracks the complete ride booking flow state:
- Selected auto type (`standard` / `pink`)
- Destination address string
- Estimated fare
- Current booking phase (`idle` / `selecting` / `searching` / `enRoute` / `completed`)

**Usage**:
```dart
// Provide above the feature sub-tree
ChangeNotifierProvider(
  create: (_) => RideBookingViewModel(),
  child: RideSelectionView(),
)

// Consume in child widget
final vm = context.watch<RideBookingViewModel>();
```

### `OnboardingViewModel`

**File**: `lib/features/onboarding/presentation/viewmodels/`

**Responsibilities**: Manages the `PageController` current page index for the onboarding carousel.

---

### `AuthViewModel`

**File**: `lib/features/auth/presentation/viewmodels/`

**Responsibilities**: Tracks auth step (`phoneEntry` / `otpEntry`), the entered phone number, OTP digits, and loading spinner visibility.

---

## 3. Ephemeral State — setState

Simple, self-contained widget state that doesn't need to be shared. Examples:

- Focus node management in `MdsOtpInput` (auto-focus each cell).
- Expansion/collapse of sections in `SavedPlacesView`.
- Star rating selection in `PostRideRatingSheet`.
- Bottom nav tab index in `MainNavigationWrapper`.

---

## Anti-Patterns to Avoid

> [!WARNING]
> - Do **not** call `context.read<>()` inside `build()` — use `context.watch<>()` or `BlocBuilder` instead.
> - Do **not** put ephemeral UI state (e.g., text field focus) into a global Cubit.
> - Do **not** `setState` inside a `StatelessWidget` callback if the state is shared — lift it to a ViewModel or Cubit.
