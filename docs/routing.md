# 🧭 Routing

Pink Auto uses Flutter's built-in **Named Routes** system, declared in `main.dart`. All routes are registered in the `MaterialApp.routes` map.

---

## Route Registry

| Route Name | Widget | Description |
|---|---|---|
| `/onboarding` | `OnboardingScreen` | Value proposition carousel. Default if not logged in. |
| `/phone-auth` | `PhoneAuthScreen` | Phone number + OTP two-step auth. |
| `/home` | `MainNavigationWrapper` | Bottom nav shell (Home / Activity / Account). Default if logged in. |
| `/edit-profile` | `EditProfileView` | Editable user profile form. |
| `/safety-hub` | `SafetyHubView` | Emergency contacts and safety features. |
| `/saved-places` | `SavedPlacesView` | Saved location management. |
| `/destination-search` | `DestinationSearchView` | Address/destination lookup. |
| `/ride-selection` | `RideSelectionView` | Auto type selection and fare estimate. |
| `/searching-driver` | `SearchingDriverView` | Animated driver-matching loading screen. |
| `/driver-en-route` | `DriverEnRouteView` | Active ride tracking screen. |

> [!NOTE]
> `PostRideRatingSheet` is presented as a modal bottom sheet from within `DriverEnRouteView` rather than a named route, since it appears on top of the map screen.

---

## Initial Route Logic

```dart
initialRoute: SessionStorage.isLoggedIn() ? '/home' : '/onboarding',
```

`SessionStorage.isLoggedIn()` reads an in-memory flag set by `AuthViewModel` after mock OTP verification. On a fresh install the flag is `false`, routing the user to `/onboarding`.

---

## Navigation Patterns

### Push (forward navigation)
```dart
Navigator.pushNamed(context, '/destination-search');
```

### Push with arguments
```dart
Navigator.pushNamed(
  context,
  '/ride-selection',
  arguments: {'destination': 'MG Road, Bangalore'},
);

// In destination screen:
final args = ModalRoute.of(context)!.settings.arguments as Map;
```

### Replace (no back stack)
```dart
// Used after successful auth — user shouldn't go back to OTP screen
Navigator.pushReplacementNamed(context, '/home');
```

### Pop (back)
```dart
Navigator.pop(context);
// Or with a return value:
Navigator.pop(context, selectedDestination);
```

### Modal Bottom Sheet
```dart
showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
  ),
  builder: (_) => const PostRideRatingSheet(),
);
```

---

## Full User Journey Flow

```
App Launch
    │
    ├─ isLoggedIn = false ──▶ /onboarding ──▶ /phone-auth ──▶ /home (replace)
    │
    └─ isLoggedIn = true  ──▶ /home
                                │
                  ┌─────────────┼─────────────────────────┐
                  │             │                         │
              Home tab     Activity tab             Account tab
                  │                                       │
            Search bar tap                    ┌──────────────────────┐
                  │                           │          │           │
        /destination-search          /edit-profile  /safety-hub  /saved-places
                  │
        (destination chosen)
                  │
          /ride-selection
                  │
        (Book button tapped)
                  │
        /searching-driver (auto-advances)
                  │
         /driver-en-route
                  │
       PostRideRatingSheet (modal)
                  │
               (dismiss)
                  │
              /home (pop to root)
```
