# Product Requirements Document (PRD)  
## CityUHK Mobile App – Enhanced Features Demo  

**Version:** 1.1  
**Date:** November 2025  
**Status:** Active Development  
**Project Type:** Academic – HCI Group Project  

---

## 1. Executive Summary  

### 1.1 Product Vision  
**CityUHK Mobile** is the single, intuitive mobile gateway for all campus services at City University of Hong Kong. By eliminating fragmented portals, repeated logins, and unclear navigation, the app reduces student cognitive load and time-to-task from minutes to seconds.  

### 1.2 Problem Statement  
User interviews reveal four systemic pain points:  
1. **Fragmentation** – Students toggle between Library Study Room, SFBI, Hall System, CRESDA, etc.  
2. **Context Switching** – Browser-to-app, login-to-login, queue-to-device.  
3. **Information Asymmetry** – Unclear room names, locations, machine status, print release steps.  
4. **Missed Opportunities** – Scattered event sources lead to FOMO, especially for freshmen/international students.  

### 1.3 Value Proposition  
A **unified, accessible, and actionable** interface that:  
- Consolidates **all booking, dorm, tech, and social services** into one app.  
- Delivers **<2-tap access** to high-frequency tasks (Nielsen Efficiency).  
- Provides **real-time visibility** and **smart nudges** to prevent waste.  
- Establishes a **foundation for personalization** (future phases).  

### 1.4 Success Metrics (Demo)  
| Metric | Target |  
|--------|--------|  
| All screens navigable | 100% |  
| Core flows complete in <2 taps | 100% |  
| Consistent theme (light/dark) | 100% |  
| Offline demo data renders correctly | 100% |  

---

## 2. Target Users  

| Segment | Needs | Pain Points |  
|---------|-------|-------------|  
| **Freshmen** | Guided onboarding, event discovery | Overwhelmed by portals |  
| **Dorm Residents** | Laundry visibility, etiquette | Forgotten clothes, wasted trips |  
| **All Students** | Fast printing, room booking, event registration | Context switching, unclear steps |  

---

## 3. Product Scope  

> **All features equal priority** – delivered together in a single UI-only demo.  
> **No backend, no auth, no API** – static demo data only.  

### 3.1 Core Accessibility Foundation (Legacy – Completed)  
| Feature | Description | Status |  
|--------|-------------|--------|  
| **Onboarding Flow** | 5-step guided tour (skip/replay per slide), Hive-tracked | Functional |  
| **Redesigned Homepage** | Next Event widget + 2-col quick-access grid + scrollable feeds | Functional |  
| **Customizable Bottom Navbar** | 5 slots, drag-reorder, undo, Hive persistence | Functional |  

---

## 4. New Feature Modules  

### 4.1 **Booking Services** – Unified Booking Dashboard  

**Goal:** Replace 4+ fragmented systems with **one timetable interface**.  

#### 4.1.1 User Stories  
| As a… | I want to… | So that… |  
|-------|------------|----------|  
| Student | Open one screen to book any room | I don’t remember which portal does what |  
| User | See room name, location, and availability at a glance | I can pick the best slot fast |  

#### 4.1.2 UI Components  
- **Tab Bar**: Study Rooms | Classrooms | Sports Facilities | Music Rooms  
- **Timetable Grid**:  
  - Rows: Rooms (with location badge)  
  - Columns: Time slots (30-min increments)  
  - Color-coded: Free (green), Booked (gray), Selected (primary)  
- **Room Card**: Name, floor, capacity, equipment tags  
- **Slot Selector**: Tap → Confirmation modal (mock booking)  

#### 4.1.3 Demo Data  
`lib/data/demo/booking_data.dart`  
```dart
List<Room> studyRooms = [...];
Map<DateTime, List<BookingSlot>> availabilityMatrix;
```

---

### 4.2 **Dorm Management** – Laundry Management (Live Status + Smart Reminders)  

**Goal:** Eliminate unnecessary trips and forgotten laundry via **visibility + nudges**.  

#### 4.2.1 Core Components  
| Component | Description |  
|---------|-------------|  
| **Laundry Room Dashboard** | Grid of stacked machines (Dryer atop Washer) with status badges |  
| **Machine Detail View** | Countdown timer, “Notify when free”, “Notify at end” |  
| **Smart Alert System** | Alert + 5/10-min grace period follow-ups |  
| **Polite Nudge** | “I’m on my way” / “Snooze 5 min” to previous user |  
| **Filters & Sorting** | Segmented: All | Washers | Dryers | Free Stack<br>Chips: Nearest | Free | Finishing Soon |  
| **Alert Center** | List of active alerts, cancel/edit grace |  

#### 4.2.2 Interaction Flow  
1. Open Laundry → Select dorm floor  
2. Filter: “Finishing Soon” → Tap machine  
3. Set alert → Receive mock push (in-app banner)  
4. View Alert Center → Cancel or adjust  

#### 4.2.3 Demo Data  
`lib/data/demo/laundry_data.dart`  
```dart
List<LaundryRoom> halls = [...];
List<MachineStack> machines = [...] // status, eta, userId (mock)
```

---

### 4.3 **Tech Services** – In-App Print Submission  

**Goal:** Reduce print task from **~10 min → ~5 min** via **building-aware flow**.  

#### 4.3.1 Rationale (from interviews)  
| Pain | Solution |  
|------|----------|  
| Wrong queue per building | Building selector with live queue preview |  
| Confusing charged print steps | Step-by-step flow with payment badges |  
| Inconsistent release | Building-specific final screen |  

#### 4.3.2 Flow  
1. **Upload** → Mock file picker  
2. **Select Building** → AC2 | CMC | Library (with queue count)  
3. **Print Type** → Free B/W | Charged B/W | Charged Color  
4. **Review & Submit** → Job ID + release steps  
5. **Release Screen** → “Go to printer → Enter Job ID: 1234”  

#### 4.3.3 Offline Fallback  
- Detect Wi-Fi → “Connect to CityU Wi-Fi to print”  
- All steps work offline with mock submission  

#### 4.3.4 Demo Data  
`lib/data/demo/printing_data.dart`  
```dart
Map<String, BuildingQueue> queues; // AC2, CMC, Library
List<ReleaseInstruction> instructionsPerBuilding;
```

---

### 4.4 **Social Clubs & Events** – Centralized Event Dashboard  

**Goal:** Turn scattered event sources into **one actionable feed**.  

#### 4.4.1 Why This First?  
- **Foundation** for recommendations, notifications  
- **High immediate value** – students check events daily  
- **Agile-friendly** – divisible into testable stories  

#### 4.4.2 UI Components  
- **Event Card**:  
  - Title, Organizer, Time, Venue  
  - Badges: Language | Category | Registration Status  
  - Actions: Register | Add to Calendar  
- **Filters**:  
  - Chips: Academic | Sports | Cultural | Today | This Week  
  - Language: EN | ZH  
  - Search bar  
- **Empty State**: “No events match filters” + “Load More”  

#### 4.4.3 Interaction Flow  
1. Open Events → Scroll feed  
2. Filter: “Sports” + “This Week”  
3. Tap event → Detail view  
4. Tap **Register** → Success toast (mock)  

#### 4.4.4 Demo Data  
`lib/data/demo/events_data.dart`  
```dart
List<Event> allEvents = [...]; // from CRESDA, clubs, curated
```

---

### 4.5 **Dorm Services** – A/C & Visitor Management

**Goal:** Provide residents with direct control over room utilities and streamline guest registration.

#### 4.5.1 User Stories
| As a… | I want to… | So that… |
|-------|------------|----------|
| Dorm Resident | See my A/C balance and usage on my phone | I can manage my spending and avoid running out of credit unexpectedly |
| Dorm Resident | Top up my A/C credit via Apple Pay/Google Wallet | I don't have to use a physical top-up kiosk |
| Dorm Resident | Use my student card to verify my identity for a visitor's registration | The process is faster and more secure than waiting for an OTP |

#### 4.5.2 UI Components & Flow
**A/C Management:**
- **A/C Balance Card**: Displays real-time balance with color-coded status (Green, Yellow, Red) and last-updated timestamp.
- **Usage History View**: An hourly bar chart visualizing recent A/C consumption patterns.
- **Top-Up Flow**:
  1. Tap "Top-Up" button on the A/C card.
  2. A modal appears with pre-set amounts (€5, €10, €20).
  3. User selects an amount and confirms via a mock Apple Pay / Google Wallet interface.
  4. Balance is instantly updated on the UI.

**Visitor Registration:**
- **NFC Tap to Verify**:
  1. Visitor initiates registration on their device.
  2. The app prompts the visitor to have the student host tap their ID card to the phone's NFC reader.
  3. A success animation and message confirm the host's identity has been verified.

#### 4.5.3 Demo Data
`lib/data/demo/dorm_services_data.dart`
```dart
Map<String, dynamic> acDetails; // balance, List<ACUsageHour> history
bool mockNfcValidation(studentId);
```

---

## 5. Technical Requirements  

| Requirement | Specification |  
|-----------|---------------|  
| **Platform** | Flutter (iOS & Android) |  
| **Flutter SDK** | ^3.9.2+ |  
| **Backend** | **None** – UI-only |  
| **Data** | Static JSON/Dart constants in `lib/data/demo/` |  
| **Storage** | Hive (onboarding, navbar, theme) |  
| **Navigation** | GoRouter (consistent with legacy) |  
| **State** | Local only (no Provider needed for demo) |  
| **Offline** | 100% functional with cached demo data |  

---

## 6. Design & UX Guidelines  

| Principle | Application |  
|---------|-------------|  
| **Nielsen: Visibility** | Next Event, machine status, queue counts |  
| **Nielsen: Efficiency** | <2 taps to start any task |  
| **Nielsen: Control** | Custom navbar, alert management |  
| **Minimalism** | Rivian-style onboarding, transparent widgets |  
| **Consistency** | Reuse `AppTheme`, colors, radius, icons |  

### 6.1 Theme  
- Primary: CityU Blue  
- Secondary: Orange (sports), Purple (academic)  
- Cards: 12px radius, elevation 2  
- Buttons: 8px radius, full-width on modals  

### 6.2 Dark Mode  
- Full support (system-adaptive)  
- Green badge for login status in dark  

---

## 7. Implementation Plan  

### 7.1 File Structure (Proposed)  
```
lib/
├── data/
│   └── demo/
│       ├── booking_data.dart
│       ├── laundry_data.dart
│       ├── printing_data.dart
│       └── events_data.dart
├── features/
│   ├── booking/
│   ├── laundry/
│   ├── print/
│   └── events/
├── legacy/                 # onboarding, home, navbar
└── core/
    ├── theme/
    ├── constants/
    └── utils/
```

### 7.2 Sprint Breakdown (3 Weeks)  

| Week | Focus | Deliverables |  
|------|-------|--------------|  
| **1** | Data + Scaffolding | 4 demo data files<br>Navigation routes<br>Tab/page shells |  
| **2** | Core UI | Timetable, machine grid, print flow, event cards |  
| **3** | Polish + Integration | Filters, modals, alerts, dark mode, transitions |  

---

## 8. Success Criteria  

| Criteria | Measurable |  
|----------|------------|  
| **Navigation** | All features reachable from navbar/home |  
| **Task Completion** | Booking, laundry alert, print submit, event register in ≤2 taps |  
| **Visual Consistency** | Same theme, icons, spacing as legacy |  
| **Demo Readiness** | Runs on iOS & Android simulators, no crashes |  
| **Offline Resilience** | All screens load with mock data |  

---

## 9. Risks & Mitigations  

| Risk | Impact | Mitigation |  
|------|--------|------------|  
| Time overrun | Incomplete flows | Prioritize **core path** per feature; skip edge filters if needed |  
| Inconsistent design | Poor demo | Enforce `AppTheme` usage; reuse legacy components |  
| Demo data gaps | Unrealistic | Include 3–5 varied items per dataset (e.g., full, empty, mixed) |  

---

## 10. Out of Scope (Future Phases)  

| Feature | Reason |  
|-------|--------|  
| Real API / SSO | Requires backend |  
| Push notifications | Needs FCM/APNs |  
| Multi-language | MVP = English |  
| Analytics | Not needed for demo |  
| Accessibility (WCAG) | Future iteration |  

---

## 11. Appendices  

### 11.1 References  
- `doc/features.md` – Detailed rationale, user quotes, hypothesis mapping  
- `legacy/` – Reusable onboarding, theme, navbar  
