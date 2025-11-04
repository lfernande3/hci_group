# CityUHK Mobile App

**A unified mobile gateway for all campus services at City University of Hong Kong**

[![Flutter](https://img.shields.io/badge/Flutter-3.9.2+-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.9.2+-blue.svg)](https://dart.dev)
[![License](https://img.shields.io/badge/License-Academic-green.svg)](LICENSE)

---

## 📱 Overview

**CityUHK Mobile** is a comprehensive mobile application designed to consolidate all campus services into a single, intuitive interface. By eliminating fragmented portals, repeated logins, and unclear navigation, the app reduces student cognitive load and time-to-task from minutes to seconds.

### Vision
Transform the fragmented campus service ecosystem into a unified, accessible, and actionable mobile experience that delivers **<2-tap access** to high-frequency tasks.

---

## ✨ Features

### 🎓 Core Features (Legacy - Completed)
- **Onboarding Flow** - 5-step guided tour with skip/replay functionality
- **Redesigned Homepage** - Next Event widget, quick-access grid, scrollable feeds
- **Customizable Bottom Navbar** - 5 slots, drag-reorder, undo, persistent storage

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

- **Framework:** Flutter 3.9.2+
- **Language:** Dart 3.9.2+
- **Navigation:** GoRouter
- **State Management:** Provider
- **Local Storage:** Hive
- **Dependency Injection:** GetIt
- **Architecture:** Clean Architecture (Domain, Data, Presentation)

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

```
lib/
├── main.dart                    # App entry point (exports legacy/main.dart)
├── data/
│   └── demo/                    # Demo data for UI-only implementation
│       ├── booking_data.dart    # Room booking demo data
│       ├── laundry_data.dart    # Laundry machine demo data
│       ├── printing_data.dart   # Print submission demo data
│       └── events_data.dart     # Events dashboard demo data
└── legacy/                      # Core application (completed features)
    ├── main.dart                # App initialization & providers
    ├── core/                    # Core utilities, theme, constants
    │   ├── constants/           # Route constants, app constants
    │   ├── theme/               # AppTheme (light/dark), colors, text styles
    │   ├── utils/               # Connectivity, offline cache services
    │   └── injection_container.dart  # Dependency injection setup
    ├── data/                    # Data layer (repositories, models, datasources)
    │   ├── datasources/         # Remote, local, mock data sources
    │   ├── models/              # Data models
    │   ├── mocks/               # Mock data sources
    │   └── repositories/        # Repository implementations
    ├── domain/                   # Domain layer (entities, use cases)
    │   ├── entities/            # Business entities
    │   ├── repositories/        # Repository interfaces
    │   └── usecases/            # Business logic use cases
    └── presentation/            # Presentation layer (UI)
        ├── pages/               # Screen widgets
        ├── widgets/             # Reusable UI components
        ├── providers/           # State management providers
        └── routes/              # GoRouter configuration
```

---

## 📚 Documentation

- **[Product Requirements Document (PRD)](doc/prd.md)** - Complete product specifications
- **[Task Breakdown Document (TBD)](doc/tasks.md)** - 3-week sprint task breakdown
- **[Features Documentation](doc/features.md)** - User research & feature rationale
- **[Week 1 Verification Report](doc/week1_verification_report.md)** - Week 1 completion verification
- **[Theme Verification](doc/theme_verification.md)** - AppTheme compatibility guide

---

## 🎯 Development Status

### ✅ Week 1: Foundation & Data (COMPLETED)
- [x] Demo data files created (Booking, Laundry, Print, Events)
- [x] Navigation routes added to GoRouter
- [x] Navbar customization extended
- [x] AppTheme verified for light/dark mode
- [x] All dependencies configured

### 🔄 Week 2: Core UI Implementation (IN PROGRESS)
- [ ] Booking Services UI (TabBar, Timetable Grid, Room Cards)
- [ ] Laundry Management UI (Machine Grid, Detail Sheet, Filters)
- [ ] Print Submission Flow (Upload, Building Selector, Review)
- [ ] Events Dashboard UI (Feed, Cards, Filters, Search)

### ⏳ Week 3: Polish & Integration (PLANNED)
- [ ] Theme consistency across all screens
- [ ] Dark mode testing
- [ ] Page transitions
- [ ] Empty states
- [ ] Demo script and screenshots

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

### Manual Testing Checklist
- [ ] Onboarding flow (skip/replay)
- [ ] Homepage navigation
- [ ] Navbar customization
- [ ] Theme switching (light/dark)
- [ ] All 4 new feature routes accessible
- [ ] Demo data renders correctly
- [ ] Offline functionality

---

## 📝 Contributing

This is an academic project for HCI Group. For development:

1. Follow the existing code structure
2. Use `AppTheme` for all UI components
3. Maintain clean architecture principles
4. Add documentation for new features
5. Test in both light and dark modes

---

## 📄 License

This project is part of an academic HCI Group Project at City University of Hong Kong.

---

## 👥 Team

**Project Type:** Academic – HCI Group Project  
**Institution:** City University of Hong Kong  
**Year:** 2025

---

## 🔗 Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Documentation](https://dart.dev/guides)
- [GoRouter Documentation](https://pub.dev/packages/go_router)
- [Material Design 3](https://m3.material.io/)

---

## 📞 Support

For questions or issues related to this project, please refer to the documentation in the `doc/` folder or contact the development team.

---

**Built with ❤️ for CityUHK Students**
