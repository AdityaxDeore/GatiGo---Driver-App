# 🧪 Testing

Pink Auto maintains a widget + unit test suite with **29 passing tests** verified against `flutter analyze` (zero warnings).

---

## Test Stack

| Tool | Purpose |
|---|---|
| `flutter_test` | Widget tests and unit tests |
| `flutter_bloc` test utilities | Cubit state testing |
| `mockito` / mock objects | Isolating ViewModel behavior |

---

## Running Tests

```bash
# Run all tests
flutter test

# Run with verbose output
flutter test --reporter expanded

# Run a specific test file
flutter test test/features/ride_booking/presentation/views/ride_booking_views_test.dart

# Run static analysis (zero issues expected)
flutter analyze
```

---

## Test Structure

```
test/
├── widget_test.dart                                        # Smoke test — app renders without crashing
└── features/
    ├── auth/
    │   └── presentation/
    │       └── viewmodels/
    │           └── phone_auth_viewmodel_test.dart          # Unit tests for AuthViewModel
    ├── onboarding/
    │   └── presentation/
    │       └── viewmodels/
    │           └── onboarding_viewmodel_test.dart          # Unit tests for OnboardingViewModel
    ├── profile/
    │   └── presentation/
    │       └── views/
    │           └── profile_views_test.dart                 # Widget tests for Profile screens
    └── ride_booking/
        └── presentation/
            ├── viewmodels/
            │   └── ride_booking_viewmodel_test.dart        # Unit tests for RideBookingViewModel
            └── views/
                ├── ride_booking_views_test.dart            # Widget tests for booking screens
                └── post_booking_lifecycle_test.dart        # End-to-end booking flow widget test
```

---

## Test Coverage by Area

### `phone_auth_viewmodel_test.dart`
Tests `AuthViewModel` state transitions:
- Initial step is `phoneEntry`.
- Valid 10-digit phone transitions to `otpEntry` step.
- Invalid phone length prevents step transition.
- Correct OTP mock triggers `isAuthenticated = true`.
- Back navigation resets to `phoneEntry`.

### `onboarding_viewmodel_test.dart`
Tests `OnboardingViewModel`:
- Initial page index is `0`.
- `nextPage()` increments index up to the last page.
- `previousPage()` decrements index but does not go below `0`.

### `ride_booking_viewmodel_test.dart`
Tests `RideBookingViewModel`:
- Initial phase is `idle`.
- Setting destination updates state and notifies listeners.
- Selecting auto type stores the selection.
- Booking transitions phase to `searching`.
- Fare estimate is returned correctly per auto type.

### `ride_booking_views_test.dart`
Widget tests for booking UI:
- `RideSelectionView` renders both Standard Auto and Pink Auto cards.
- Tapping "Book" card navigates to `/searching-driver`.
- `DestinationSearchView` renders search input and recent places list.

### `post_booking_lifecycle_test.dart`
End-to-end widget test covering:
- Full booking flow from `RideSelectionView` → `SearchingDriverView` → `DriverEnRouteView`.
- SOS hold button renders and is visible on `DriverEnRouteView`.
- Share ride status button is present and tappable.

### `profile_views_test.dart`
Widget tests for Profile screens:
- `MainAccountView` displays user name and avatar from `ProfileCubit`.
- `EditProfileView` has name and gender form fields.
- `SafetyHubView` lists emergency contacts section.
- `SavedPlacesView` shows Home and Work place entries.

---

## Writing a New Test

1. Create a file under `test/features/<feature>/presentation/<layer>/`.
2. Mirror the `lib/` directory structure.
3. Use `testWidgets` for UI tests and `test` for pure Dart unit tests.
4. Wrap widget tests that need global state in `MultiBlocProvider` with test cubits.

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pink_auto/features/profile/presentation/bloc/profile_cubit.dart';
import 'package:pink_auto/features/profile/presentation/views/main_account_view.dart';

void main() {
  testWidgets('MainAccountView shows user name', (tester) async {
    await tester.pumpWidget(
      BlocProvider(
        create: (_) => ProfileCubit(),
        child: const MaterialApp(home: MainAccountView()),
      ),
    );
    expect(find.textContaining('Account'), findsOneWidget);
  });
}
```

---

> [!TIP]
> Run `flutter test --coverage` to generate an `lcov.info` coverage report. Use `genhtml lcov.info -o coverage/html` to produce a browsable HTML report.
