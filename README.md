# CityUHK Mobile App

## 📱 Overview

**CityUHK Mobile** is a comprehensive mobile application designed to consolidate all campus services into a single, intuitive interface. By eliminating fragmented portals, repeated logins, and unclear navigation, the app reduces student cognitive load and time-to-task from minutes to seconds.

### Vision
Transform the fragmented campus service ecosystem into a unified, accessible, and actionable mobile experience that delivers **<2-tap access** to high-frequency tasks.

---

## 🗺️ Navigation Guide for Graders

This section provides quick navigation to key project files, documentation, and deliverables.

### 📄 Documentation Files

All project documentation is located in the `doc/` folder:

| File | Path | Description |
|------|------|-------------|
| **Task Breakdown** | `doc/tasks.md` | Complete 3-week sprint task breakdown with status tracking |
| **Product Requirements** | `doc/prd.md` | Full product specifications and requirements |
| **Features Documentation** | `doc/features.md` | User research, feature rationale, and implementation details |
| **Improvements Report** | `doc/improvements.md` | Heuristic evaluation findings and recommendations |

**Quick Access:**
```bash
# View all documentation
cd doc/
ls -la

# Open specific document
code doc/tasks.md      # Task breakdown
code doc/prd.md        # Product requirements
code doc/features.md   # Feature documentation
code doc/improvements.md  # Improvements report
```

### 📦 Downloadables & Build Outputs

**APK Files (Prototype Builds):**
- Location: `prototype/` folder
- Files available:
  - `initial_v1.apk`, `initial_v2.apk`, `initial_v3.apk` - Early prototype versions
  - `final_v1.apk`, `final_v2.apk` - Final demo builds

**To Build Your Own:**
```bash
# Build release APK
flutter build apk --release

# Output location: build/app/outputs/flutter-apk/app-release.apk
```

### 🏗️ Key Directories

| Directory | Purpose | Key Files |
|-----------|---------|-----------|
| `lib/features/` | Feature modules (Clean Architecture) | Each feature has `data/`, `domain/`, `presentation/` |
| `lib/core/` | Shared utilities, theme, DI | `theme/app_theme.dart`, `injection/injection_container.dart` |
| `lib/data/demo/` | Demo data for UI testing | `booking_data.dart`, `laundry_data.dart`, `events_data.dart`, etc. |
| `lib/config/routes/` | Navigation configuration | `app_router.dart`, `route_constants.dart` |
| `assets/` | App assets | `cityu_logo.png` |

### 🔍 Finding Specific Features

**Booking Services:**
- UI: `lib/features/booking/presentation/pages/booking_page.dart`
- Demo Data: `lib/data/demo/booking_data.dart`
- Route: Check `lib/config/routes/route_constants.dart` for route name

**Laundry Management:**
- UI: `lib/features/laundry/presentation/pages/laundry_page.dart`
- Demo Data: `lib/data/demo/laundry_data.dart`
- Alert Center: `lib/features/laundry/presentation/pages/alert_center_page.dart`

**Print Submission:**
- UI: `lib/features/print/presentation/pages/print_page.dart`
- Demo Data: `lib/data/demo/printing_data.dart`

**Events Dashboard:**
- UI: `lib/features/events/presentation/pages/events_page.dart`
- Demo Data: `lib/data/demo/events_data.dart`
- Detail View: `lib/features/events/presentation/pages/event_detail_page.dart`

**Dorm Services (A/C & Visitor):**
- A/C Management: `lib/features/dorm/presentation/pages/ac_management_page.dart`
- Visitor Registration: `lib/features/dorm/presentation/pages/visitor_registration_page.dart`
- Demo Data: `lib/data/demo/dorm_services_data.dart`

### 🎯 Quick Start for Evaluation

1. **Review Documentation:**
   ```bash
   # Start here for project overview
   cat doc/tasks.md
   cat doc/prd.md
   ```

2. **Run the App:**
   ```bash
   flutter pub get
   flutter run
   ```

3. **Check Feature Implementation:**
   - Navigate through app using bottom navbar
   - Test all 4 new features (Booking, Laundry, Print, Events)
   - Verify dark/light mode support
   - Check offline functionality with demo data

4. **Review Code Structure:**
   - Check `lib/features/` for feature implementations
   - Review `lib/core/theme/app_theme.dart` for theming
   - Examine `lib/config/routes/app_router.dart` for navigation

### 📊 Project Status Tracking

- **Task Status:** See `doc/tasks.md` for detailed task breakdown with completion status
- **Week 1-4 Progress:** All tasks marked with `[x]` are completed
- **Current Phase:** Week 4 (Heuristic Improvements) - All tasks completed

---

### 🆕 New Features (Week 1-3 - In Progress)

#### 1. **Booking Services** 📅
- Unified booking dashboard for all room types
- Tab-based navigation: Study Rooms | Classrooms | Sports Facilities | Music Rooms
- Interactive timetable grid with color-coded availability
- Room cards with location, capacity, and equipment tags
- Real-time availability matrix (30-minute slots)

#### 2. **Laundry Management** 🧺
- Live status dashboard for dorm laundry machines
- Machine stack view (Dryer + Washer) with status badges
- Smart alert system with countdown timers
- Filter and sort: All | Washers | Dryers | Free | Finishing Soon
- Alert Center for managing active notifications

#### 3. **In-App Print Submission** 🖨️
- Building-aware print submission flow
- Building selector with live queue preview (AC2, CMC, Library)
- Print type selection: Free B/W | Charged B/W | Charged Color
- Step-by-step release instructions per building
- Wi-Fi detection and offline fallback

#### 4. **Events Dashboard** 🎉
- Centralized event feed from CRESDA, clubs, and curated sources
- Event cards with organizer, time, venue, and registration status
- Advanced filtering: Category | Language | Time Range
- Search functionality with real-time results
- Event detail view with registration and calendar integration

---

## 🛠️ Tech Stack

- **Framework**: Flutter
- **Language**: Dart
- **Architecture**: Clean Architecture (Feature-Driven)
- **State Management**: Provider
- **Navigation**: GoRouter
- **Dependency Injection**: GetIt
- **Local Storage**: Hive
- **Networking**: HTTP
- **Functional Programming**: dartz
- **Utilities**: equatable, connectivity_plus

---

## 📋 Requirements

- Flutter SDK 3.9.2 or higher
- Dart SDK 3.9.2 or higher
- Android Studio / VS Code with Flutter extensions
- iOS Simulator (for Mac) or Android Emulator
- Git

---

## 🚀 Getting Started

### Prerequisites

1. **Install Flutter**
   ```bash
   # Check Flutter installation
   flutter --version
   
   # Verify setup
   flutter doctor
   ```

2. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd hci_group
   ```

### Installation

1. **Install dependencies**
   ```bash
   flutter pub get
   ```

2. **Run the app**
   ```bash
   # List available devices
   flutter devices
   
   # Run on a specific device
   flutter run -d <device-id>
   
   # Or run on default device
   flutter run
   ```

### Build for Production

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS (requires Mac)
flutter build ios --release
```

---

## 📁 Project Structure

The project follows a **feature-driven clean architecture** pattern, organizing code by features rather than technical layers.

```
hci_group/
├── doc/                       # 📄 All project documentation
│   ├── tasks.md               # Task breakdown with status
│   ├── prd.md                 # Product requirements
│   ├── features.md            # Feature documentation
│   └── improvements.md        # Heuristic improvements
│
├── prototype/                 # 📦 Downloadable APK builds
│   ├── initial_v*.apk         # Early prototypes
│   └── final_v*.apk           # Final demo builds
│
├── lib/
│   ├── main.dart              # App entry point
│   │
│   ├── config/                # App configuration
│   │   └── routes/            # GoRouter setup & route constants
│   │
│   ├── core/                  # Shared core utilities
│   │   ├── constants/         # App constants, API constants, UI constants
│   │   ├── theme/             # AppTheme (light/dark), colors, text styles
│   │   ├── utils/             # Connectivity, offline cache, date formatters
│   │   ├── injection/          # Dependency injection (GetIt)
│   │   ├── errors/            # Error handling (exceptions, failures)
│   │   ├── data/              # Core data layer (datasources, mocks)
│   │   ├── domain/            # Core domain layer (usecases)
│   │   └── presentation/      # Core UI widgets (navbar, error widgets)
│   │
│   ├── data/
│   │   └── demo/              # Demo data for UI-only implementation
│   │       ├── booking_data.dart
│   │       ├── laundry_data.dart
│   │       ├── printing_data.dart
│   │       ├── events_data.dart
│   │       └── dorm_services_data.dart
│   │
│   └── features/              # Feature modules (Clean Architecture)
│       ├── auth/              # Authentication
│       ├── booking/           # Room booking services
│       ├── laundry/           # Laundry management
│       ├── print/             # Print submission
│       ├── events/            # Events dashboard
│       ├── dorm/              # Dorm services (A/C, Visitor)
│       ├── home/              # Homepage
│       ├── onboarding/        # Onboarding flow
│       ├── navigation/        # Navbar customization
│       ├── settings/          # Settings page
│       ├── timetable/         # Class timetable
│       ├── chatbot/           # Chatbot feature
│       └── qr/                # QR code scanner
│           │
│           # Each feature follows this structure:
│           ├── data/          # Data layer (models, repositories)
│           ├── domain/        # Domain layer (entities, usecases)
│           └── presentation/  # UI layer (pages, widgets, providers)
│
├── assets/                    # App assets (images, fonts)
│   └── cityu_logo.png
│
└── test/                      # Unit & widget tests
    └── widget_test.dart
```

**Architecture Pattern:**
Each feature module follows Clean Architecture with three layers:
- **Data Layer** (`data/`): Models, repositories, datasources
- **Domain Layer** (`domain/`): Entities, use cases, repository interfaces
- **Presentation Layer** (`presentation/`): UI pages, widgets, providers

---

## 📚 Documentation

All documentation files are located in the `doc/` directory. See the [Navigation Guide](#-navigation-guide-for-graders) above for quick access.

- **[Product Requirements Document (PRD)](doc/prd.md)** - Complete product specifications and requirements
- **[Task Breakdown Document (TBD)](doc/tasks.md)** - 3-week sprint task breakdown with status tracking
- **[Features Documentation](doc/features.md)** - User research, feature rationale, and implementation details
- **[Improvements Report](doc/improvements.md)** - Heuristic evaluation findings and recommendations

---

## 🎯 Development Status

### ✅ Week 1: Foundation & Data (COMPLETED)
- [x] **Demo Data**: All demo data files created (Booking, Laundry, Print, Events, Dorm Services)
- [x] **Navigation**: Routes for all new features added to GoRouter
- [x] **Navbar**: Customization logic extended for new feature icons
- [x] **Theming**: `AppTheme` verified for light/dark mode compatibility
- [x] **Dependencies**: All required packages configured and injected

### ✅ Week 2: Core UI Implementation (COMPLETED)
- [x] **Booking Services**: TabBar, Timetable Grid, Room Cards, and booking confirmation implemented
- [x] **Laundry Management**: Machine Grid, Detail Sheet, Filters, and Alert Center built
- [x] **Print Submission**: Upload, Building Selector, Review flow, and Wi-Fi detection completed
- [x] **Events Dashboard**: Feed, Cards, Filters, Search, and Detail View implemented
- [x] **Dorm Services**: A/C Management and Visitor Registration screens completed

### ✅ Week 3: Polish & Integration (COMPLETED)
- [x] Theme consistency across all screens
- [x] Dark mode testing and refinement
- [x] Page transitions and empty states
- [x] Demo script and screenshots prepared

### ✅ Week 4: Heuristic Improvements (COMPLETED)
- [x] Booking persistence and "My Bookings" feature
- [x] Laundry terminology improvements and alert cancellation
- [x] Navbar undo functionality
- [x] Print file change capability
- [x] UI standardization (timestamps, button dimensions)
- [x] NFC availability pre-check
- [x] Onboarding FAQ/Help section

**Current Status:** All planned features completed. Project is demo-ready.

---

## 🎨 Design Principles

- **Nielsen's Usability Heuristics**
  - Visibility: Status indicators, queue counts, machine availability
  - Efficiency: <2 taps to start any task
  - Control: Customizable navbar, alert management
  
- **Material Design 3**
  - Consistent theme system (light/dark)
  - 12px card radius, 8px button radius
  - CityU branding colors (Burgundy primary, Orange/Purple secondary)

- **Accessibility**
  - High contrast ratios
  - Clear visual hierarchy
  - Offline-capable with demo data

---

## 🧪 Testing

### Run Tests
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart
```

---

## 📝 Contributing

This is an academic project for HCI Group. For development:

1. Follow the existing code structure
2. Use `AppTheme` for all UI components
3. Maintain clean architecture principles
4. Add documentation for new features
5. Test in both light and dark modes

---
