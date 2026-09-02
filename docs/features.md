# 🗺️ Features

This document describes every feature module in the app, including its screens, state management approach, and navigation entry/exit points.

---

## Feature Map

```
Onboarding → Phone Auth → Home
                            ├── Destination Search → Ride Selection → Searching Driver → Driver En Route → Post-Ride Rating
                            ├── Activity (mock ride history)
                            └── Profile → Edit Profile / Safety Hub / Saved Places / Crop Photo
```

---

## 1. Onboarding

**Location**: `lib/features/onboarding/`  
**Entry route**: `/onboarding` (shown when `SessionStorage.isLoggedIn()` returns `false`)

### Screens
| File | Description |
|---|---|
| [`onboarding_screen.dart`](../lib/features/onboarding/presentation/screens/onboarding_screen.dart) | Full-screen carousel with 3 value-proposition slides. Includes language selection drawer. |

### State
- **ViewModel**: `OnboardingViewModel` (ChangeNotifier) — manages current page index and `PageController`.
- **Language**: Reads `LanguageCubit` from context for localized slide content.

### Navigation
- **Skip / Get Started** → navigates to `/phone-auth`.
- Language drawer can switch app locale without leaving the screen.

---

## 2. Auth

**Location**: `lib/features/auth/`  
**Entry route**: `/phone-auth`

### Screens
| File | Description |
|---|---|
| [`phone_auth_screen.dart`](../lib/features/auth/presentation/screens/phone_auth_screen.dart) | Two-step flow: (1) 10-digit phone entry, (2) 6-digit OTP entry. Validation is performed client-side. OTP verification is mocked. |

### State
- **ViewModel**: `AuthViewModel` (ChangeNotifier) — tracks active step (`phoneEntry` / `otpEntry`), phone number, OTP value, and loading state.

### Navigation
- Successful mock OTP verification → `SessionStorage.setLoggedIn(true)` → navigates to `/home`.
- Back button on OTP step → returns to phone entry step.

---

## 3. Home

**Location**: `lib/features/home/`  
**Entry route**: `/home` (via `MainNavigationWrapper`)

### Screens / Views
| File | Description |
|---|---|
| [`main_navigation_wrapper.dart`](../lib/features/home/presentation/views/main_navigation_wrapper.dart) | Bottom navigation bar with 3 tabs: Home, Activity, Account. |
| [`home_view.dart`](../lib/features/home/presentation/views/home_view.dart) | Map canvas, search bar, shortcut chips, SOS button. |
| [`activity_mock_screen.dart`](../lib/features/home/presentation/views/activity_mock_screen.dart) | Mock ride history list. |

### Widgets
| File | Description |
|---|---|
| [`home_map_widget.dart`](../lib/features/home/presentation/widgets/home_map_widget.dart) | Renders the simulated map canvas with mock auto-rickshaw pins and route overlay. |

### Navigation
- Search bar tap → `/destination-search`
- SOS button hold → in-screen SOS modal

---

## 4. Profile

**Location**: `lib/features/profile/`  
**Tab**: "Account" tab in `MainNavigationWrapper`

### Screens / Views
| File | Description |
|---|---|
| [`main_account_view.dart`](../lib/features/profile/presentation/views/main_account_view.dart) | Account overview with avatar, stats, and quick links. |
| [`edit_profile_view.dart`](../lib/features/profile/presentation/views/edit_profile_view.dart) | Editable name, gender, and profile photo. |
| [`safety_hub_view.dart`](../lib/features/profile/presentation/views/safety_hub_view.dart) | Emergency contacts and safety settings. |
| [`saved_places_view.dart`](../lib/features/profile/presentation/views/saved_places_view.dart) | Home / Work / custom saved location management. |
| [`crop_photo_view.dart`](../lib/features/profile/presentation/views/crop_photo_view.dart) | Image preview and crop flow after photo selection via `image_picker`. |

### State
- **`ProfileCubit`** ([`profile_cubit.dart`](../lib/features/profile/presentation/bloc/profile_cubit.dart)): Global cubit provided at the app root. Holds `ProfileState` with name, phone, avatar path, gender, and emergency contacts.
- **`ProfileState`** ([`profile_state.dart`](../lib/features/profile/presentation/bloc/profile_state.dart)): Immutable state class with `copyWith`.

### Navigation
| From | To | Route |
|---|---|---|
| Account tab | Edit Profile | `/edit-profile` |
| Account tab | Safety Hub | `/safety-hub` |
| Account tab | Saved Places | `/saved-places` |
| Edit Profile (photo tap) | Crop Photo | pushed via `Navigator.push` |

---

## 5. Ride Booking

**Location**: `lib/features/ride_booking/`  
**Entry route**: `/destination-search`

### Screens / Views
| File | Description |
|---|---|
| [`destination_search_view.dart`](../lib/features/ride_booking/presentation/views/destination_search_view.dart) | Address search with recent places and saved shortcuts. Returns selected destination to caller. |
| [`ride_selection_view.dart`](../lib/features/ride_booking/presentation/views/ride_selection_view.dart) | Side-by-side Auto vs. Pink Auto cards with fare estimate, ETA, and a "Book" CTA. |
| [`searching_driver_view.dart`](../lib/features/ride_booking/presentation/views/searching_driver_view.dart) | Animated loading screen simulating driver matching (auto-advances after ~3 seconds). |
| [`driver_en_route_view.dart`](../lib/features/ride_booking/presentation/views/driver_en_route_view.dart) | Live (simulated) ride tracking: driver card, ETA badge, SOS hold button, share ride status. |
| [`post_ride_rating_sheet.dart`](../lib/features/ride_booking/presentation/views/post_ride_rating_sheet.dart) | Post-ride modal: star rating, tip selection, and receipt summary. |

### Widgets
| File | Description |
|---|---|
| [`map_canvas_placeholder.dart`](../lib/features/ride_booking/presentation/widgets/map_canvas_placeholder.dart) | Custom-painted map placeholder with simulated route and vehicle pin. |

### State
- **`RideBookingViewModel`** ([`ride_booking_viewmodel.dart`](../lib/features/ride_booking/presentation/viewmodels/ride_booking_viewmodel.dart)): ChangeNotifier tracking selected auto type, destination, fare, and booking phase.

### Booking Flow (Navigation)
```
/destination-search
      │ (destination selected)
      ▼
/ride-selection
      │ (Book tapped)
      ▼
/searching-driver (auto-advances after mock delay)
      │
      ▼
/driver-en-route
      │ (ride completes)
      ▼
PostRideRatingSheet (modal bottom sheet, then pops to /home)
```
