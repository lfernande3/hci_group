Booking Services
Feature: Unified Booking Dashboard
Unified Booking Dashboard: integrates key booking systems (study rooms, classrooms, sports facilities, other rooms) into one interface within the existing CityU portal. The booking page should include multiple tabs (study rooms, classrooms, sports facilities, music rooms) and show a timetable layout with room names, locations, and booking slots.
The unified dashboard integrates study rooms, sports courts, music rooms, classrooms into one single booking interface instead of making users switch between fragmented systems (Library Study Room Booking, Sports Facilities Booking (SFBI), Music Rooms, Hall System, etc.).
User interviews showed that students struggle with fragmented booking portals, remembering which systems handle what, repeated logins, and unclear room names/locations. Hence, creating a single entry-point for bookings will reduce confusion and time wasted.

Accessibility
1. Onboarding Flow (Core Feature 1)
Description: A mandatory 5-step guided tour on first app launch, covering welcome, app bar/login, next event widget, navbar customization, and permissions (e.g., notifications/location). Users can skip or remove individual elements (e.g., permissions slide).
Implementation: Uses intro_slider package; stored in Hive for one-time display. Rivian-inspired minimalism with arrows/highlights.
UX Tie: Improves onboarding (Hypothesis 2), ensuring visibility of key elements (Nielsen's Visibility principle).
Status: Fully functional; tested for <1 min completion.
2. Redesigned Homepage (Core Feature 2)
Description: Minimalist home screen with:
Top app bar: Static CityUHK logo icon (left), user full name or subtle login button (right, with green badge for status in dark mode).
Half-screen "Next Event" widget: Transparent background, shows academic event (lecture/exam with time/location/room), semester week count (e.g., "W5" top left), clickable to timetable; placeholder text ("Welcome back to CityUHK Mobile") if no events.
Below widget: 2-column grid (max 2 per row) for quick access to screens (Student Life, Campus, Grade Report, Important Contacts); vertical scrollable feeds for News, CityU CAP, CityUTube (5 hardcoded items, "Load More" button).
Implementation: Built with GridView and ListView.builder in home_page.dart; mock JSON data in data/mocks/; system dark/light mode via ThemeData.
UX Tie: Declutters home screen (Hypothesis 5), enables <2-tap access (Efficiency principle).
Status: Functional with offline retry button; screenshots show light/dark modes.
3. Customizable Bottom Navbar (Core Feature 3)
Description: Persistent bottom navigation bar with up to 5 customizable buttons (defaults: Timetable, Chatbot, CityU ID QR, Account Info). Users can add/remove/reorder via settings (e.g., options: Campus Map, Room Availability, Academic Calendar, Authenticator, Sports Booking, Contacts, Emergency, News, CAP).
Implementation: Uses Flutter's BottomNavigationBar with GoRouter for routing; drag-reorder with undo dialog (Hive snapshot rollback); icons from Material Design (e.g., calendar_today for timetable).
UX Tie: Reduces drawer overload and taps (Hypotheses 4 & 6), provides user control (Nielsen's Control principle).
Status: Functional; persistent prefs in Hive.
Dorm Management Services
Selected Feature: Laundry Management (Live Status + Smart Reminders)
The chosen feature, Laundry Management, provides students with clear visibility of machine availability and cycle progress through live status updates, countdown timers, and intelligent notifications. It eliminates unnecessary trips, prevents forgotten pickups, and fosters a culture of respect within shared laundry spaces.
This feature is composed of six core components designed to support both utility and usability:



Core Features
Laundry Room Dashboard 
Displays a live grid of stacked machines (Dryer above Washer) with clear status labels such as Free, In Use, Finishing Soon, or Out of Service, along with estimated completion times.
Machine Detail View 
Shows detailed countdowns and quick actions like Notify me when free or Notify me at completion.
Smart Alert and Grace Period System
Enables users to set alerts and receive follow-up reminders (e.g., after 5 or 10 minutes) if clothes remain uncollected.
Polite Nudge Feature 
Encourages dorm etiquette by allowing users to send a gentle reminder (Polite nudge previous user) with response options like I’m on my way or Snooze 5 minutes.
Filter and Sorting Controls 
Provides segmented controls (All | Washers | Dryers | Stacks with at least one free), filter chips (Nearest room, Only free, Finishing soon), and sorting options (Finishing soon, Closest room, ID) for fast navigation.
Alert Center 
A centralized space where users can view, manage, or cancel active alerts and modify grace settings to stay updated on their laundry activity.

Tech Services
Feature Selection
Project Context
CityUHK students currently juggle multiple steps across browser portals and on-device instructions to print documents. Interviews highlighted four recurring pains: uncertainty about which queue to use in each building, slow task completion due to context switching, confusion about the order of actions for charged printing, and inconsistent release steps at the device. The project aims to streamline the end-to-end printing journey inside the CityUHK mobile app.
Chosen Feature: In-App Print Submission
A lightweight, built-in print flow that lets students submit free B/W or charged (B/W or color) jobs without leaving the app, is building-aware (AC2, CMC, Library), and shows clear release details tailored to the building and payment path. It works on campus Wi-Fi and prompts users to connect if off campus.
Why This Feature? (Rationale)
Selecting In-App Print Submission is justified by its impact on a high-frequency, time-sensitive student task. Consolidating portal navigation into a single in-app flow reduces context switching and is expected to lower average completion time from roughly ten minutes to five. The choice is grounded in interview evidence that highlighted building-specific queue uncertainty, confusion about the sequence for charged printing, and inconsistent last-mile instructions at devices. The scope is feasible for a sprint because the user interface is straightforward and the principal dependency is a minimal print-server submission endpoint with SSO handoff to existing infrastructure. Reliability at the device is strengthened through building-specific release steps, a visible “last updated” timestamp, and a one-tap “report mismatch” control that supports content governance. The design advances equity and accessibility by using concise copy, large tap targets, no additional registration burden, and explicit off-campus prompts that prevent silent failures. The feature also enables clear measurement for iterative improvement, including task time, submission success rate, queue-selection error rate, incidence of mismatch reports, and help-page visits, all of which are straightforward to instrument.

Social Clubs and Events Registration

Feature Selection
Project Overview
The CityU Student Events Hub project aims to improve student engagement by centralizing all campus event information within the CityU mobile app. Currently, students rely on scattered sources such as CRESDA, emails, social media, and posters, making it difficult to stay updated or register on time. Interviews with CityU students confirmed that this fragmentation leads to confusion and missed opportunities, especially for new and international students.

The proposed solution introduces a centralized event dashboard that gathers all upcoming events in one interface. Students can browse, filter, and register directly through the app, reducing the need to check multiple platforms. This feature serves as the foundation for future enhancements like personalized recommendations and notifications. By focusing on usability, accessibility, and integration, the Events Hub transforms the CityU app into a more engaging, efficient, and student-centered platform for campus participation.
Chosen feature
Centralized Event Dashboard (Home feed): A single screen that consolidates events from disparate sources (CRESDA, club posts, curated highlights), surfaces key metadata (title, time, venue, organizer, language, category), and provides core actions (Register, Add to Calendar) with basic filters (Category, Language, Time) and keyword search.
Why this feature
This feature was chosen because it forms the core entry point of the entire system. Without a dashboard that consolidates event information, other features such as recommendations or notifications would not have a foundation to build on. It represents a clear and practical starting point that allows students to access useful information immediately and interact with the system in a meaningful way.
From a development perspective, this feature is well scoped for an agile sprint. It can be divided into smaller user stories, such as displaying event cards, implementing filters, or enabling in-app registration, each of which delivers visible value and can be tested independently. This makes it suitable for iterative development and continuous feedback.
The feature also demonstrates key agile qualities:
It is user-focused because it directly addresses a clear student need for quick and convenient access to event information.
It is feasible because it requires only basic data integration and standard interface components, which makes it realistic for short development cycles.
It is extensible because future functions such as personalized recommendations or push notifications can be added later without changing the core structure.
It is testable because each function, including filtering, searching, and registration, has measurable acceptance criteria that can be validated through testing.

New Feature:

1.Visitor registration section:
-NFC Tap to Verify Student Identity
Description: When a visitor registers at the lobby, instead of waiting for an OTP code from the student, the visitor can ask the host student to tap their CityU Student ID card on the visitor’s phone. The app reads encrypted ID data via NFC and sends it to the dorm server for validation.
Functionality:

The phone must have NFC capability.

Upon tap, the system automatically cross-checks the SID with the registered student database.

Once confirmed, verification status is updated instantly.
2.A/C management section:
-Real-Time A/C Balance Display Linked to the Student’s Room
Description: Displays the current A/C credit balance retrieved directly from the dorm’s central energy system, linked to the student’s room number.
Purpose: To give users immediate visibility of their remaining balance before it runs out.

Functionality:

The balance auto-updates through periodic sync (e.g., every 10 minutes).

Color-coded indicators (green = sufficient, yellow = low, red = critical) help students take quick action.
-Usage History (Hourly Breakdown)
Description: Visualizes the student’s recent A/C usage in an hourly chart or timeline.
Functionality:

The app records hourly consumption data.

Students can see average daily usage patterns and estimate remaining hours of cooling.
-Online Top-Up via Apple Pay or Google Wallet
Description: Integrates a secure, cashless payment gateway allowing users to top up their A/C credit directly from their phone.
Functionality:

Accepts major digital wallets and cards.

Issues an instant receipt and updates balance immediately.


