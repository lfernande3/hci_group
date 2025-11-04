# Task Breakdown Document (TBD)  
## CityUHK Mobile App – Enhanced Features Demo  

**Version:** 1.0  
**Date:** November 2025  
**Status:** Ready for Sprint Planning  
**Project Type:** Academic – HCI Group Project  

---

## Overview  

This **Task Breakdown Document (TBD)** translates the **PRD v1.1** into **actionable, prioritized, and time-boxed tasks** for a **3-week sprint** (UI-only demo, no backend).  

All tasks assume:  
- **Flutter 3.9.2+**  
- **Legacy code** in `legacy/` (onboarding, homepage, navbar) is **reusable**  
- **No API, no auth, no real data** – all static/demo  
- **Hive** for persistence (onboarding, navbar config)  
- **GoRouter** for navigation  

---

## Task Structure  

| ID | Category | Task | Owner | Est. Effort | Dependencies | Status |
|----|--------|------|-------|-------------|--------------|--------|
| T-XXX | [Module] | Description | @name | X hrs | T-XXX | [ ] Not Started / [ ] In Progress / [x] Done |

---

## Sprint Goal  
> **Deliver a fully navigable, visually consistent, offline-capable UI demo** showcasing **all 4 new features + legacy accessibility core**, with **<2-tap access** to every primary action.

---

## Week 1 – Foundation & Data (7 days)

| ID | Category | Task | Owner | Est. Effort | Dependencies | Status |
|----|----------|------|-------|-------------|--------------|--------|
| **T-101** | **Setup** | Initialize `lib/data/demo/` folder | @lead | 1h | – | [x] |
| **T-102** | **Data** | Create `booking_data.dart` with 3+ rooms per type (Study, Class, Sports, Music) + availability matrix | @dev1 | 3h | T-101 | [x] |
| **T-103** | **Data** | Create `laundry_data.dart` with 2 dorm floors, 6+ machine stacks, varied statuses (Free, In Use, Finishing Soon) | @dev2 | 3h | T-101 | [x] |
| **T-104** | **Data** | Create `printing_data.dart` with AC2/CMC/Library queues, pricing, release steps | @dev1 | 2h | T-101 | [x] |
| **T-105** | **Data** | Create `events_data.dart` with 10+ events (CRESDA, clubs, curated) | @dev2 | 2h | T-101 | [x] |
| **T-106** | **Navigation** | Add 4 new routes to `GoRouter` (Booking, Laundry, Print, Events) | @lead | 2h | – | [x] |
| **T-107** | **Navbar** | Add 4 new navbar icons to customization list (Booking, Laundry, Print, Events) | @lead | 1h | Legacy | [x] |
| **T-108** | **Theme** | Verify `AppTheme` from `legacy/` works in new screens (light/dark) | @design | 2h | Legacy | [x] |

> **Week 1 Deliverable**: All demo data + navigation scaffold in place.

---

## Week 2 – Core UI Implementation (7 days)

### **Booking Services**

| ID | Task | Owner | Est. Effort | Dependencies | Status |
|----|------|-------|-------------|--------------|--------|
| T-201 | Build **TabBar** (Study, Classrooms, Sports, Music) | @dev1 | 2h | T-106 | [x] |
| T-202 | Build **Timetable Grid** (rooms × time slots) with color-coded slots | @dev1 | 6h | T-102 | [x] |
| T-203 | Build **Room Card** (name, location, capacity, tags) | @design | 2h | T-202 | [x] |
| T-204 | Implement **Slot Tap → Confirmation Modal** (mock booking) | @dev1 | 3h | T-202 | [x] |

### **Laundry Management**

| ID | Task | Owner | Est. Effort | Dependencies | Status |
|----|------|-------|-------------|--------------|--------|
| T-211 | Build **Laundry Room Selector** (dropdown or chips) | @dev2 | 2h | T-106 | [x] |
| T-212 | Build **Machine Stack Grid** (Dryer + Washer, status badge) | @dev2 | 5h | T-103 | [x] |
| T-213 | Build **Machine Detail Bottom Sheet** (countdown, Notify buttons) | @dev2 | 4h | T-212 | [x] |
| T-214 | Add **Filter Chips** + **Segmented Control** (All | Washers | Dryers | Free) | @design | 3h | T-212 | [x] |
| T-215 | Build **Alert Center Page** (list of active alerts) | @dev2 | 3h | T-213 | [x] |

### **In-App Print Submission**

| ID | Task | Owner | Est. Effort | Dependencies | Status |
|----|------|-------|-------------|--------------|--------|
| T-221 | Build **File Upload Mock** (button → fake file) | @dev1 | 1h | T-106 | [x] |
| T-222 | Build **Building Selector** with queue preview | @dev1 | 3h | T-104 | [x] |
| T-223 | Build **Print Type Selector** (Free B/W, Charged B/W, Color) | @dev1 | 2h | T-222 | [x] |
| T-224 | Build **Review & Submit Screen** → Job ID + release steps | @dev1 | 3h | T-223 | [x] |
| T-225 | Add **Wi-Fi Detection Banner** (mock) | @design | 1h | T-224 | [x] |

### **Events Dashboard**

| ID | Task | Owner | Est. Effort | Dependencies | Status |
|----|------|-------|-------------|--------------|--------|
| T-231 | Build **Event Feed** with `ListView.builder` | @dev2 | 3h | T-106 | [x] |
| T-232 | Build **Event Card** (title, time, venue, badges, actions) | @design | 3h | T-105 | [x] |
| T-233 | Add **Filter Chips** (Category, Language, Time) | @dev2 | 3h | T-231 | [x] |
| T-234 | Add **Search Bar** with mock filtering | @dev2 | 2h | T-231 | [x] |
| T-235 | Build **Event Detail View** + Register / Add to Calendar (mock) | @dev2 | 4h | T-232 | [x] |

> **Week 2 Deliverable**: All core screens built and navigable.

---

## Week 3 – Polish, Integration & Demo Prep (5 days)

| ID | Category | Task | Owner | Est. Effort | Dependencies | Status |
|----|----------|------|-------|-------------|--------------|--------|
| **T-301** | **Polish** | Ensure **all screens use `AppTheme`** (colors, radius, text styles) | @design | 4h | All UI | [ ] |
| **T-302** | **Dark Mode** | Test **all new screens in dark mode** (badge visibility, contrast) | @design | 3h | T-301 | [ ] |
| **T-303** | **Transitions** | Add smooth page transitions (fade/slide) via `GoRouter` | @lead | 2h | All routes | [ ] |
| **T-304** | **Empty States** | Add “No events”, “No free machines”, etc. | @dev2 | 2h | T-212, T-231 | [ ] |
| **T-305** | **Load More** | Add “Load More” button in Events & Booking | @dev1 | 1h | T-231, T-202 | [ ] |
| **T-306** | **Offline Banner** | Add global offline retry (reuse from legacy homepage) | @lead | 2h | Legacy | [ ] |
| **T-307** | **Demo Flow** | Create **demo script** (record 2-min walkthrough) | @lead | 3h | All | [ ] |
| **T-308** | **Screenshots** | Capture light/dark mode for **all 4 features + legacy** | @design | 2h | All | [ ] |
| **T-309** | **Bug Bash** | Full app walkthrough on iOS & Android simulators | Team | 4h | All | [ ] |
| **T-310** | **Final Handoff** | Export APK/AAB + video + `task.md` + `prd.md` | @lead | 2h | T-307–309 | [ ] |

> **Week 3 Deliverable**: **Demo-ready app** with video, screenshots, and documentation.

---

## Task Summary by Owner

| Owner | Total Hours | Key Tasks |
|-------|-------------|---------|
| **@lead** | 18h | Setup, nav, polish, demo script |
| **@dev1** | 25h | Booking, Print, data |
| **@dev2** | 28h | Laundry, Events, data |
| **@design** | 17h | UI components, theme, screenshots |

---

## Definition of Done (DoD)

A task is **Done** when:  
- [x] Code committed to `main`  
- [x] UI matches **PRD + features.md**  
- [x] Works in **light & dark mode**  
- [x] Works **offline** with demo data  
- [x] No crashes on iOS/Android simulator  
- [x] Reviewed by **1 peer**  
- [x] Screenshot added to `doc/screenshots/`  

---

## File Deliverables

```
doc/
├── prd.md                 # This PRD
├── task.md                # This TBD
├── features.md            # User research & rationale
└── screenshots/
    ├── booking_light.png
    ├── laundry_dark.png
    └── ...

lib/
├── data/demo/
│   ├── booking_data.dart
│   ├── laundry_data.dart
│   ├── printing_data.dart
│   └── events_data.dart
└── features/
    ├── booking/
    ├── laundry/
    ├── print/
    └── events/

demo/
├── cityuhk_demo.mp4       # 2-min walkthrough
└── cityuhk_demo.apk
```

---

## Sprint Board (Suggested – Trello / GitHub Projects)

| To Do | In Progress | Review | Done |
|-------|-------------|--------|------|
| T-101, T-102, ... | | | |

---

**Sprint Start:** [Date]  
**Demo Deadline:** [Date + 3 weeks]  
**Daily Standup:** 15 mins @ 10:00 AM  

> **Let’s build the future of CityUHK in one app.**