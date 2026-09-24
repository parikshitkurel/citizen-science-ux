# AquaVerify

A guided, offline-first freshwater observation application designed for beginner citizen scientists to record structured environmental observations through a simplified multi-step workflow.

Built for the **OneAquaHealth × IEEE Hackathon — Track 1: Citizen Science UX**.

![Flutter](https://img.shields.io/badge/Flutter-3.44+-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.12+-0175C2?logo=dart&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Desktop-informational)
![Track](https://img.shields.io/badge/Track-Citizen%20Science%20UX-2D8C88)

---

## Overview

AquaVerify replaces complex scientific observation tools with a beginner-oriented, 4-step guided wizard for recording freshwater conditions. It is designed for students, community volunteers, and non-expert citizens who want to document local streams, rivers, ponds, and canals without specialized training or equipment.

The application translates scientific terminology (turbidity, chromaticity, hydrological velocity) into plain-language visual questions, embeds contextual educational explanations for each indicator, provides structured "Unsure / Cannot tell" options to prevent forced guessing, and stores all observations locally on the device with zero internet dependency.

AquaVerify does not claim to produce laboratory-grade measurements. All observations are explicitly presented as citizen visual estimates with a mandatory transparency disclaimer before submission.

---

## Problem

Existing citizen science water-monitoring tools create friction for non-expert users through:

- **Scientific jargon** — Terms like *turbidity (NTU)*, *dissolved oxygen (mg/L)*, and *hydrological velocity* alienate beginners
- **Monolithic form architecture** — Long, single-page forms cause high abandonment during field observations
- **Missing context** — Users are asked to record data without understanding why the information matters
- **Forced guessing** — Forms without explicit "Unsure" options push users toward inaccurate inputs
- **Misleading precision** — Some tools present amateur visual estimates as validated scientific data
- **Connectivity dependency** — Cloud-authenticated tools fail in remote areas with poor cellular coverage

---

## Solution

AquaVerify addresses these problems through:

- **Guided multi-step wizard** — 4 discrete steps with progress indicator, reducing cognitive load
- **Plain-language questions** — Scientific concepts reframed as everyday visual observations
- **Predefined response options** — Standardized choices for consistency across observers
- **"Unsure / Cannot tell" handling** — Every observation question includes an explicit uncertainty option
- **Contextual "Why we ask this" guidance** — Collapsible educational cards explain the ecological relevance of each indicator
- **Review before saving** — Grouped summary with per-section edit buttons and validation
- **Transparency disclaimer** — Checkbox acknowledgement that observations are visual estimates, not certified measurements
- **Offline-first local persistence** — `SharedPreferences`-backed storage requiring no internet, accounts, or cloud services
- **Demo/user data separation** — Clear visual distinction between seeded sample data and citizen-submitted observations

---

## Core Workflow

```
Welcome Screen
      │
      ▼
  Dashboard
      │
      ▼
Step 1: Location & Water Body
      │
      ▼
Step 2: Water Appearance
      │
      ▼
Step 3: Environmental Factors
      │
      ▼
Step 4: Field Notes & Summary
      │
      ▼
  Review & Validate
      │
      ▼
Save Observation
      │
      ▼
Observation History
      │
      ▼
Observation Details
```

| Stage | Description |
|---|---|
| **Welcome** | Branding, purpose statement, hackathon badge, "Get Started" and "View My Observations" entry points |
| **Dashboard** | Workspace header with separated user/demo/total counts, "Start New Assessment" CTA, citizen science educational card, recent observations preview, data management menu (restore demo, hide demo, clear all) |
| **Step 1** | Water body type selection (chips), predefined demo locations (1-tap fill), manual location name input with validation, optional observation title, auto-generated timestamp with date/time picker override |
| **Step 2** | Water clarity, visible colour, and odour observation — each with educational "Why we ask this" guidance card and safety reminders |
| **Step 3** | Surface water movement, visible litter, surrounding vegetation, and surrounding land use — each with educational guidance |
| **Step 4** | Optional free-text field notes, photo/GPS placeholder (future), observation disclaimer banner |
| **Review** | Grouped summary cards for all 4 steps with per-section "Edit" buttons, disclaimer acknowledgement checkbox, debounced save button |
| **History** | 3-way scope filter (All / My Observations / Demo Samples), keyword search, water body type filter chips, observation tiles with metadata badges, delete with confirmation dialog |
| **Details** | Full observation readout, formatted clipboard summary export, "Start New Assessment" re-engagement CTA, delete with confirmation |

---

## Feature Set

### Observation Workflow

- 4-step guided assessment wizard with `FormStepIndicator` progress bar
- Water body type selection (Stream, River, Pond, Lake, Urban canal, Other)
- 6 predefined demonstration locations for quick entry
- Manual location name input with form validation
- Optional observation title (auto-generated from water body type if blank)
- Auto-captured timestamp with date/time picker override
- 7 structured observation indicators across Steps 2–3
- Free-text field notes

### Data Quality

- Required-field validation on location name (prevents saving without location)
- Standardized response options drawn from `AppConstants`
- "Unsure / Cannot tell" option on every observation indicator
- Review screen with per-section edit navigation
- Disclaimer acknowledgement checkbox required before save
- Debounced save action preventing duplicate submissions (guard via `_isSaving` flag)

### Local Data

- Offline-first operation via `SharedPreferences`
- JSON serialization/deserialization with legacy field fallbacks
- Data persists across application restarts
- Observation history with search, scope filtering, and water body filtering
- Individual observation deletion with confirmation dialog
- Malformed/empty storage handled gracefully (returns empty list on parse error)

### Demo Data Management

- 3 seeded sample observations auto-loaded on first launch
- `isDemo` flag distinguishes samples from user-submitted records
- Dashboard displays separate counters for user observations vs. demo samples
- Menu actions: Restore Demo Data, Hide Demo Samples, Clear All Data
- Demo samples can be restored without affecting user observations

### UX

- `FormStepIndicator` widget displaying step number, title, and linear progress
- Collapsible `InfoTooltipCard` for "Why we ask this" educational guidance
- `StatusBadge` widgets for clarity (color-coded: green/amber/red), water body type, litter level, and demo/citizen tags
- `CustomButton` component with primary, secondary, outlined, danger, and loading variants
- Material 3 design system with custom `AppTheme` and `AppColors` palette
- Google Fonts (Inter) typography
- Responsive layouts with `ConstrainedBox` (max-width 760px)
- Entry animations via `flutter_animate` on Welcome screen
- Accessible touch targets and overflow-safe text

---

## Terminology Simplification

This table documents the actual mapping implemented in `AppConstants` and the observation form screens:

| Scientific Concept | User-Facing Question | Available Responses |
|---|---|---|
| Turbidity | *"How clear does the water look?"* | Clear · Slightly cloudy · Very cloudy · Unsure / Cannot tell |
| Chromaticity | *"What colour does the water appear to be?"* | Normal / Natural-looking · Greenish · Brownish · Unusual · Unsure / Cannot tell |
| Olfactory assessment | *"Do you notice any unusual smell?"* | No unusual odour · Mild unusual odour · Strong unusual odour · Unsure / Cannot tell |
| Hydrological velocity | *"How is the water moving?"* | Still · Light movement · Fast movement · Unsure / Cannot tell |
| Solid waste pollution | *"How much visible litter or trash do you notice?"* | None noticed · Small amount · Large amount · Unsure / Cannot tell |
| Riparian buffer quality | *"What do you notice around the water (Vegetation)?"* | Abundant vegetation · Some vegetation · Little or no vegetation · Unsure / Cannot tell |
| Catchment land use | *"What best describes the surrounding area?"* | Natural / Green area · Residential area · Industrial area · Agricultural area · Other · Unsure / Cannot tell |

Each question includes a collapsible `InfoTooltipCard` with ecological context drawn from `AppConstants.educationalExplanations`.

---

## Architecture

```
┌─────────────────────────────────────────┐
│            Presentation Layer           │
│  Screens (6) + Widgets (5)              │
│  StatelessWidget / StatefulWidget       │
│  ValueListenableBuilder for reactivity  │
└────────────────┬────────────────────────┘
                 │
┌────────────────▼────────────────────────┐
│           Repository Layer              │
│  ObservationRepository (singleton)      │
│  ValueNotifier<List<Observation>>       │
│  CRUD + demo data management            │
└────────────────┬────────────────────────┘
                 │
┌────────────────▼────────────────────────┐
│           Persistence Layer             │
│  StorageService                         │
│  SharedPreferences + JSON               │
└────────────────┬────────────────────────┘
                 │
┌────────────────▼────────────────────────┐
│             Domain Model                │
│  Observation (15 fields)                │
│  toJson / fromJson / copyWith           │
└─────────────────────────────────────────┘
```

- **Presentation**: 6 screens and 5 reusable widgets. UI reactivity is provided by `ValueListenableBuilder` listening to the repository's `ValueNotifier<List<Observation>>`.
- **Repository**: `ObservationRepository` is a singleton initialized at app startup. It manages the in-memory observation list, delegates persistence to `StorageService`, and handles demo data seeding, restoration, and clearing.
- **Persistence**: `StorageService` reads/writes a JSON-encoded string to `SharedPreferences` under the key `aqua_verify_observations`. On parse failure, it returns an empty list.
- **Domain Model**: `Observation` is an immutable data class with 15 fields, JSON serialization with legacy fallbacks (nullable `surroundingVegetation`, `surroundingEnvironment`, `notes`, `isDemo`), and a `copyWith` method for the edit-and-review workflow.

No external state management libraries (BLoC, Riverpod, Provider) are used.

---

## Technical Stack

| Technology | Version | Purpose |
|---|---|---|
| Flutter | ≥ 3.44 | Cross-platform application framework |
| Dart | ≥ 3.12.1 | Application language |
| Material 3 | — | UI design system (`useMaterial3: true`) |
| `shared_preferences` | ^2.5.5 | Local key-value persistence |
| `google_fonts` | ^8.2.1 | Inter typeface |
| `flutter_animate` | ^4.5.2 | Entry animations on Welcome screen |
| `intl` | ^0.20.3 | Date/time formatting |
| `uuid` | ^4.6.0 | Declared dependency (not currently imported in application code) |
| `flutter_lints` | ^6.0.0 | Static analysis rules |

---

## Data Model

```
Observation
├── id                      : String       Unique identifier (timestamp-based or demo prefix)
├── title                   : String       User-provided or auto-generated observation title
├── waterBodyType           : String       Stream | River | Pond | Lake | Urban canal | Other
├── location                : String       Location name or landmark
├── observationDate         : DateTime     Date/time of observation (user-adjustable)
├── clarity                 : String       Water clarity assessment
├── visibleColour           : String       Water colour assessment
├── odour                   : String       Odour assessment
├── surfaceMovement         : String       Water movement assessment
├── visibleLitter           : String       Litter/trash assessment
├── surroundingVegetation   : String       Riparian vegetation assessment (default: "Unsure / Cannot tell")
├── surroundingEnvironment  : String       Land use context (default: "Unsure / Cannot tell")
├── notes                   : String       Free-text field notes
├── isDemo                  : bool         true for seeded sample observations, false for user submissions
└── createdAt               : DateTime     Record creation timestamp
```

JSON serialization uses ISO 8601 strings for `DateTime` fields. The `fromJson` factory provides backwards-compatible defaults for `surroundingVegetation`, `surroundingEnvironment`, `notes`, and `isDemo` to handle legacy data gracefully.

---

## Persistence & Offline Architecture

```
User Input → Observation Model → ObservationRepository → StorageService → SharedPreferences
                                                                              │
                                                          JSON-encoded string stored under
                                                          key: "aqua_verify_observations"
```

- **Storage mechanism**: `SharedPreferences` (platform-native key-value store)
- **Serialization**: `Observation.toJson()` produces `Map<String, dynamic>`, list of maps is JSON-encoded to a single string
- **Loading**: On app startup, `ObservationRepository.init()` loads and deserializes the stored string. If storage is empty (first launch), 3 demo observations are seeded automatically.
- **Persistence**: Every add/delete/clear operation immediately serializes the full list back to storage
- **Error handling**: `StorageService.loadObservations()` catches all exceptions and returns an empty list. `saveObservations()` returns a `bool` success indicator.
- **Restart survival**: Data persists across application restarts via platform-native `SharedPreferences`
- **No cloud synchronization**: All data remains on-device

---

## Project Structure

```
lib/
├── main.dart                          # App entry point (WidgetsFlutterBinding + runApp)
├── app/
│   ├── app.dart                       # MaterialApp, FutureBuilder initialization, routing
│   └── theme.dart                     # Material 3 theme, color scheme, typography, input decoration
├── models/
│   └── observation.dart               # Observation data class with JSON serialization + copyWith
├── services/
│   └── storage_service.dart           # SharedPreferences read/write with error handling
├── repositories/
│   └── observation_repository.dart    # Singleton repository, ValueNotifier, CRUD, demo data management
├── screens/
│   ├── welcome_screen.dart            # Welcome screen with branding, feature cards, entry animations
│   ├── home_screen.dart               # Dashboard with stats, actions, citizen science card, recent list
│   ├── observation_form_screen.dart   # 4-step guided wizard with validation and navigation
│   ├── review_save_screen.dart        # Grouped review, disclaimer checkbox, save with debounce guard
│   ├── history_screen.dart            # Search, scope filter, water body filter, delete confirmation
│   └── details_screen.dart            # Full observation readout, clipboard export, delete
├── widgets/
│   ├── custom_button.dart             # Button component (primary, secondary, outlined, danger, loading)
│   ├── form_step_indicator.dart       # Step counter + linear progress bar
│   ├── info_tooltip_card.dart         # Collapsible "Why we ask this" educational card
│   ├── observation_tile.dart          # Observation list item with metadata badges
│   └── status_badge.dart             # Color-coded badges for clarity, water body, litter, demo/citizen
└── utils/
    ├── app_colors.dart                # Design token palette (navy, teal, text, status colors)
    ├── constants.dart                 # App strings, observation options, demo locations, educational text
    └── sample_data.dart               # 3 seeded demo Observation instances
```

---

## Validation & Error Handling

| Mechanism | Implementation |
|---|---|
| **Required location** | `TextFormField` validator in Step 1 prevents proceeding without a location name |
| **Step 1 form gate** | `_formKeyStep1` validation blocks `_nextStep()` until the form is valid |
| **Review-time location check** | `_saveObservation()` re-validates location; redirects to Step 1 if empty |
| **Disclaimer acknowledgement** | Save is blocked with a SnackBar if the checkbox is unchecked |
| **Duplicate-save prevention** | `_isSaving` boolean flag prevents concurrent save operations |
| **Storage parse failure** | `StorageService.loadObservations()` catches all exceptions, returns `[]` |
| **Legacy data compatibility** | `Observation.fromJson()` defaults nullable fields to safe values |

---

## Demo Data

AquaVerify ships with 3 pre-seeded sample observations for demonstration and evaluation purposes:

| Title | Water Body | Location |
|---|---|---|
| Morning Stream Survey | Stream | Willow Creek Bridge |
| Canal Bank Inspection | Urban canal | Riverside Urban Canal |
| Park Pond Seasonal Check | Pond | Community Mill Pond |

**Important distinctions:**

- Demo observations have `isDemo: true` and IDs prefixed with `demo-obs-`
- The dashboard displays separate counters: "My Observations" (user) vs. "Demo Samples"
- History screen provides 3-way scope filtering: All / My Observations / Demo Samples
- Observation tiles display a "Demo Sample" badge (blue) vs. "Citizen Entry" badge (green)
- Demo data can be removed via "Hide Demo Samples" without affecting user observations
- Demo data can be restored via "Restore Demo Data" without affecting user observations
- "Clear All Data" removes both user and demo records (with confirmation dialog)

Demo data is **not** real citizen observation data. It exists solely for testing, evaluation, and demonstration.

---

## Testing

The repository includes 3 test files:

### `test/observation_test.dart` — Unit Tests

- `toJson` / `fromJson` round-trip serialization of all 15 fields
- Legacy JSON parsing (missing `surroundingVegetation`, `surroundingEnvironment`) defaults to "Unsure / Cannot tell"
- `copyWith` correctly updates specified fields while preserving unchanged fields
- `formattedDate`, `formattedTime`, `formattedCreatedAt` return non-empty strings

### `test/flow_test.dart` — Integration Test

End-to-end journey validation:

1. Welcome screen renders with "Get Started" and "View My Observations"
2. Dashboard renders with "Start New Assessment" and citizen science card
3. Step 1: Demo location chip tap fills location field
4. Step 2: Water clarity question renders
5. Step 3: Environmental factor questions render
6. Step 4: Disclaimer banner renders
7. Review screen displays all 4 section cards and "Save Observation"
8. Save produces success dialog
9. Navigation to History screen shows the saved observation

### `test/widget_test.dart` — Smoke Test

- Verifies `AquaVerifyApp` widget renders without error

### Running Tests

```bash
flutter test
```

### Not Currently Tested

- `StorageService` read/write behavior
- `ObservationRepository` CRUD operations and demo data management
- Individual widget rendering and interaction
- History screen search/filter behavior
- Details screen clipboard export

---

## Setup & Installation

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) ≥ 3.44 with Dart SDK ≥ 3.12.1
- A target platform: Web browser (Chrome/Edge), Android emulator/device, iOS simulator/device, or Desktop (Windows/macOS/Linux)

### Getting Started

```bash
git clone https://github.com/parikshitkurel/citizen-science-ux.git
cd citizen-science-ux
flutter pub get
flutter run
```

### Development Commands

```bash
flutter pub get       # Install dependencies
flutter analyze       # Run static analysis
flutter test          # Run test suite
flutter run           # Launch application
flutter run -d chrome # Launch on Chrome specifically
```

---

## Current MVP Scope

The current version (1.0.0+1) implements:

- ✅ Guided 4-step freshwater observation wizard
- ✅ Plain-language terminology for 7 observation indicators
- ✅ "Unsure / Cannot tell" option on every indicator
- ✅ Contextual "Why we ask this" educational guidance
- ✅ Safety reminders (odour observation step)
- ✅ Review screen with per-section edit navigation
- ✅ Transparency disclaimer with checkbox acknowledgement
- ✅ Offline-first local persistence via SharedPreferences
- ✅ Observation history with search, scope filtering, and water body filtering
- ✅ Observation detail view with clipboard summary export
- ✅ Demo data management (seed, restore, hide, clear)
- ✅ Delete individual observations with confirmation
- ✅ Automated unit and integration tests

---

## Limitations

- **Qualitative observations only** — All observations are visual estimates; the application does not perform or claim laboratory-grade measurements
- **No GPS coordinate capture** — Location is recorded as a text name/landmark, not as geographic coordinates (GPS integration is a roadmap item)
- **No photo attachments** — Camera/gallery capture is not implemented (placeholder UI indicates future support)
- **No backend or cloud synchronization** — All data is stored locally on-device only
- **No data export** — Observations cannot be exported as CSV, GeoJSON, or other structured formats (clipboard summary copy is available)
- **No user accounts or authentication** — By design for the MVP, but limits multi-device access
- **No predictive analytics or AI classification** — The application does not analyze or classify observation data
- **Local-only persistence** — Data loss occurs if the device storage is cleared or the application is uninstalled

---

## Roadmap

The following features are **not currently implemented**. They represent potential future development directions consistent with the project's scope:

### v2 (Planned)

- GPS-assisted location metadata via device geolocation
- Photo attachments via camera/gallery capture
- CSV and GeoJSON data export for community watershed organizations
- Optional cloud synchronization with backend infrastructure

---

## Hackathon Alignment

**OneAquaHealth × IEEE Hackathon — Track 1: Citizen Science UX**

| Track Requirement | AquaVerify Implementation |
|---|---|
| Guided citizen-science workflow | 4-step observation wizard with progress indicator |
| Simplified ecological terminology | 7 scientific concepts translated to plain-language questions |
| Data accuracy and honesty | Standardized options + "Unsure / Cannot tell" + review + disclaimer |
| Repeat participation | Observation history, dashboard re-engagement, "Start New Assessment" CTAs |
| Accessible UX | Educational guidance cards, safety reminders, beginner-oriented instructions |
| Offline capability | 100% local storage via SharedPreferences, zero internet dependency |
| Demo/evaluation support | 3 seeded sample observations with clear visual separation from user data |

---

## Design Principles

The following principles are reflected in the current implementation:

1. **Progressive disclosure** — Complex observation broken into 4 digestible steps
2. **Plain-language terminology** — Scientific jargon replaced with everyday visual questions
3. **Structured input** — Predefined options reduce free-form ambiguity
4. **Validation before submission** — Required fields enforced, review screen with edit access
5. **Transparency about uncertainty** — "Unsure / Cannot tell" option and non-scientific disclaimer
6. **Offline-first operation** — No internet, cloud accounts, or login required
7. **Clear separation between demo and user data** — `isDemo` flag, separate counters, scope filtering, visual badges

---

## License

No license file is currently present in the repository.

---

## Acknowledgements

Built for the **OneAquaHealth × IEEE Global Hackathon** (Track 1: Citizen Science UX).
