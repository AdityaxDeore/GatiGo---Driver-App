# 🏗️ Architecture

Pink Auto follows **Clean Architecture** combined with the **MVVM (Model-View-ViewModel)** pattern to achieve maximum separation of concerns, testability, and maintainability.

---

## Overview

```
┌───────────────────────────────────────────────────────┐
│                     Presentation                      │
│        (Screens / Views / Widgets / ViewModels)       │
└────────────────────────┬──────────────────────────────┘
                         │ calls
┌────────────────────────▼──────────────────────────────┐
│                       Domain                          │
│          (Entities / Use Cases / Interfaces)          │
└────────────────────────┬──────────────────────────────┘
                         │ implements
┌────────────────────────▼──────────────────────────────┐
│                        Data                           │
│        (Repositories / Data Sources / Models)         │
└───────────────────────────────────────────────────────┘
```

> [!NOTE]
> Because this project is UI-only, not all features have all three layers. Some features (e.g., `auth`, `home`) only implement the **Presentation** layer, with data and domain logic mocked in-place.

---

## Directory Structure

```
lib/
├── core/                        # Shared infrastructure
│   ├── theme/                   # PinkAppTheme — color tokens, TextTheme, ButtonTheme
│   ├── mds/                     # Modular Design System reusable widgets
│   │   └── widgets/             # MDS component files
│   ├── localization/            # LanguageCubit + static translation dictionary
│   └── storage/                 # SessionStorage (mock auth persistence)
│
├── features/                    # Vertical feature slices
│   ├── onboarding/
│   │   ├── domain/              # Onboarding entity / page model
│   │   └── presentation/
│   │       ├── screens/         # OnboardingScreen
│   │       └── viewmodels/      # OnboardingViewModel (ChangeNotifier)
│   │
│   ├── auth/
│   │   └── presentation/
│   │       ├── screens/         # PhoneAuthScreen (phone + OTP)
│   │       └── viewmodels/      # AuthViewModel
│   │
│   ├── home/
│   │   └── presentation/
│   │       ├── views/           # HomeView, MainNavigationWrapper, ActivityMockScreen
│   │       └── widgets/         # HomeMapWidget
│   │
│   ├── profile/
│   │   ├── data/                # ProfileRepository (mock)
│   │   └── presentation/
│   │       ├── bloc/            # ProfileCubit + ProfileState
│   │       └── views/           # MainAccountView, EditProfileView, SafetyHubView,
│   │                            #   SavedPlacesView, CropPhotoView
│   │
│   └── ride_booking/
│       └── presentation/
│           ├── viewmodels/      # RideBookingViewModel (ChangeNotifier)
│           ├── views/           # DestinationSearchView, RideSelectionView,
│           │                    #   SearchingDriverView, DriverEnRouteView,
│           │                    #   PostRideRatingSheet
│           └── widgets/         # MapCanvasPlaceholder
│
└── main.dart                    # App root: MultiBlocProvider + MaterialApp + routes
```

---

## Layer Responsibilities

### Presentation Layer
- **Screens / Views**: Stateless or Stateful Flutter widgets that define UI structure.
- **ViewModels (ChangeNotifier)**: Hold UI-specific state and expose business actions (e.g., `RideBookingViewModel`).
- **Cubits (BLoC)**: Stream-based state management for cross-widget or global state (e.g., `ProfileCubit`, `LanguageCubit`).

### Domain Layer
- **Entities**: Plain Dart objects representing core concepts (e.g., `OnboardingPage`).
- **Use Cases / Interfaces**: Abstract contracts that the Data layer implements.

### Data Layer
- **Repositories**: Implement domain interfaces; for this UI-only project, they return mock data.
- **Data Sources**: Would connect to Firebase / REST APIs in production.
- **Models**: Data Transfer Objects (DTOs) with serialization logic.

---

## State Management Strategy

| Scope | Tool | Example |
|---|---|---|
| Global app state | `BlocProvider` + `Cubit` | `ProfileCubit`, `LanguageCubit` |
| Feature-local state | `ChangeNotifier` + `ListenableBuilder` | `RideBookingViewModel` |
| Ephemeral widget state | `StatefulWidget` + `setState` | OTP digit focus, form validation |

See [state-management.md](./state-management.md) for full details.

---

## Data Flow Example — Ride Booking

```
User taps "Book Ride"
       │
       ▼
RideSelectionView (Presentation)
       │  calls
       ▼
RideBookingViewModel.confirmBooking()
       │  updates state → notifyListeners()
       ▼
UI rebuilds → navigates to /searching-driver
       │
       ▼
SearchingDriverView (simulated 3-second match animation)
       │
       ▼
Navigator.pushReplacementNamed('/driver-en-route')
```
