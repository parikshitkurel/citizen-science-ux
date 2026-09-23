# AquaVerify 🌊
> **Observe water. Understand your surroundings.**

**AquaVerify** is a user-friendly, mobile-first freshwater observation application created for the **OneAquaHealth × IEEE Global Hackathon** (**Track 1: Citizen Science UX**).

AquaVerify enables students, citizen scientists, and community members to document freshwater ecosystems through intuitive guided questions, visual guidance, step validation, educational explanations, and 100% offline local device storage.

---

## 🌟 Hackathon Context & Track Alignment

| Parameter | Details |
|---|---|
| **Hackathon** | OneAquaHealth × IEEE Global Hackathon |
| **Track** | **Track 1: Citizen Science UX** |
| **Project Goal** | Create an accessible, engaging freshwater observation tool prioritizing UX, scientific transparency, and a complete end-to-end user journey |
| **Core Challenge** | Complex tools, confusing scientific jargon, long unguided forms, and lack of context discourage citizens from repeat environmental monitoring |
| **Solution** | A guided 4-step wizard with visual selection cards, "Why we ask this" educational tips, safety reminders, and zero-login offline persistence |

---

## 🗺️ Complete End-to-End User Journey

```
[ Welcome Screen ]  -->  [ Dashboard ]  -->  [ Step 1: Location & Water Body ]  -->  [ Step 2: Water Appearance ]
                                                                                               │
[ Observation Details ]  <--  [ History & Search ]  <--  [ Save to Storage ]  <--  [ Review & Validate ]  <--  [ Step 3: Environmental Factors ]
                                                                                               ▲
                                                                                               └──  [ Step 4: Notes & Disclaimer ]
```

The application functions completely without requiring any backend, cloud login, or internet connection.

---

## ✨ Key Features & Track 1 Innovations

### 1. Welcome & Onboarding
* **App Name & Tagline**: *AquaVerify* — *"Observe water. Understand your surroundings."*
* **Clear Purpose**: *"Help document freshwater environments through simple, guided observations."*
* **Direct CTAs**: Primary *"Get Started"* → Dashboard, Secondary *"View My Observations"* → Observation History.
* **No Authentication Barrier**: Immediate access without mandatory signup or data collection.

### 2. Workspace Dashboard
* **Live Local Statistics**: Displays total saved observations and user-submitted entries stored on-device.
* **Primary Actions**: Prominent *"Start New Assessment"* and *"View Observation History"*.
* **Citizen Science Education**: Built-in explanation card clarifying the purpose of community water monitoring.
* **Helpful Empty States**: Inspiring prompts when zero observations are recorded.

### 3. Step 1 — Basic Location & Water Body
* **Predefined Demonstration Locations**: 1-tap quick selection for demo streams, rivers, canals, and lakes (*Willow Creek Bridge*, *Riverside Urban Canal*, *Community Mill Pond*, *Highland Reservoir Park*, *Greenway Stream Overlook*, *Centennial Lake Boardwalk*).
* **Manual Input**: Custom landmark or location name with validation.
* **Water Body Types**: *Stream*, *River*, *Pond*, *Lake*, *Urban canal*, *Other*.
* **Timestamping**: Automatic date and time capture with picker override.

### 4. Step 2 — Water Appearance (Visual Guidance)
* **Water Clarity**: Clear, Slightly cloudy, Very cloudy, Unsure / Cannot tell.
  * *Educational Guidance*: *"Cloudy water can contain suspended particles. This observation is a visual estimate, not a laboratory turbidity measurement."*
* **Visible Water Colour**: Normal / Natural-looking, Greenish, Brownish, Unusual, Unsure / Cannot tell.
* **Water Odour & Safety**: No unusual odour, Mild unusual odour, Strong unusual odour, Unsure / Cannot tell.
  * *Safety Notice*: Explicit warning reminding users never to touch or taste questionable water.

### 5. Step 3 — Environmental Factors
* **Surface Water Movement**: Still, Light movement, Fast movement, Unsure / Cannot tell.
* **Visible Litter / Trash**: None noticed, Small amount, Large amount, Unsure / Cannot tell.
* **Surrounding Vegetation**: Abundant vegetation, Some vegetation, Little or no vegetation, Unsure / Cannot tell.
* **Surrounding Area Context**: Natural / Green area, Residential area, Industrial area, Agricultural area, Other, Unsure / Cannot tell.
* **"Why We Ask This" Guidance**: Every question includes an educational card explaining the ecological relevance.

### 6. Step 4 — Field Notes & Summary
* **Qualitative Field Notes**: Space for wildlife sightings, water level changes, or unusual conditions.
* **Extensible Placeholder**: Architecture ready for photo capture and GPS tagging in future releases.
* **Citizen Science Disclaimer**: *"These records represent citizen observations and are not certified laboratory measurements. They should not be used alone to determine water safety or ecosystem health."*

### 7. Review & Validation
* **Structured Grouping**: All 4 steps organized into summary cards with direct **Edit** jump actions to each respective wizard step.
* **Validation Protection**: Prevents saving if required fields are missing.
* **Transparency Acknowledgement**: Interactive checkbox ensuring users understand the observational nature of the record.
* **Duplicate Prevention**: Debounced save action preventing multiple record creation.

### 8. Observation History & Detailed Report View
* **Search & Filter**: Real-time title/location search and water body type filter chips.
* **Observation Tiles**: Visual status badges for water body type and clarity.
* **Comprehensive Detail Screen**: Complete readout of all 10+ indicators, formatted clipboard export, and safe deletion confirmation dialog.

---

## 📊 Terminology Simplification Matrix

| Scientific / Technical Concept | Standard Technical Term | AquaVerify Plain-Language Question | Options Provided |
|---|---|---|---|
| Light attenuation / Turbidity | Turbidity (NTU) | *"How clear does the water look?"* | Clear, Slightly cloudy, Very cloudy, Unsure / Cannot tell |
| Chromaticity / Organic tannins | Colorimetric index | *"What colour does the water appear to be?"* | Normal / Natural-looking, Greenish, Brownish, Unusual, Unsure / Cannot tell |
| Olfactory indicators | Anaerobic VOCs | *"Do you notice any unusual smell?"* | No unusual odour, Mild unusual odour, Strong unusual odour, Unsure / Cannot tell |
| Hydrological flow rate | Water velocity | *"How is the water moving?"* | Still, Light movement, Fast movement, Unsure / Cannot tell |
| Riparian buffer condition | Riparian vegetation index | *"What do you notice around the water?"* | Abundant vegetation, Some vegetation, Little or no vegetation, Unsure / Cannot tell |
| Catchment land use | Anthropogenic land use | *"What best describes the surrounding area?"* | Natural / Green area, Residential, Industrial, Agricultural, Other, Unsure / Cannot tell |
| Solid waste contamination | Macrolitter density | *"How much visible litter or trash do you notice?"* | None noticed, Small amount, Large amount, Unsure / Cannot tell |

---

## 🛠️ Technology Stack & Architecture

* **Framework**: Flutter 3.44+ / Dart 3.12+ (Material 3)
* **Design System**: Modern aquatic visual language with custom tokens (`AppColors`, `AppTheme`), Google Fonts (Inter), and accessible touch targets.
* **Architecture**: Repository Pattern with `ObservationRepository` managing a reactive `ValueNotifier<List<Observation>>` for seamless state updates without external bloat.
* **Local Storage Service**: `StorageService` using `SharedPreferences` with structured JSON serialization, ensuring zero-dependency, crash-resilient persistence across Android, iOS, Web, and Desktop.

---

## 📂 Project Structure

```
lib/
├── main.dart                          # App entry point & initialization
├── app/
│   ├── app.dart                       # MaterialApp configuration & repository initialization
│   └── theme.dart                     # Material 3 theme, typography & aquatic color palette
├── models/
│   └── observation.dart               # Complete Observation model with JSON serialization & fallbacks
├── services/
│   └── storage_service.dart           # Offline SharedPreferences persistence service
├── repositories/
│   └── observation_repository.dart    # Reactive repository & demo seed data manager
├── screens/
│   ├── welcome_screen.dart            # Welcome screen with primary & secondary CTAs
│   ├── home_screen.dart               # Dashboard with stats, citizen science tips & recent entries
│   ├── observation_form_screen.dart   # Guided 4-step observation wizard
│   ├── review_save_screen.dart        # Grouped review, validation & disclaimer acknowledgement
│   ├── history_screen.dart            # Observation history with search & filter chips
│   └── details_screen.dart            # Observation detail view with formatted report export
├── widgets/
│   ├── custom_button.dart             # Adaptive primary, outlined, secondary & danger buttons
│   ├── form_step_indicator.dart       # Responsive progress indicator widget
│   ├── info_tooltip_card.dart         # "Why we ask this" educational explanation cards
│   ├── observation_tile.dart          # Observation list tile with metadata chips
│   └── status_badge.dart              # Badges for clarity, water body type & litter
└── utils/
    ├── app_colors.dart                # Aquatic color palette tokens
    ├── constants.dart                 # Standard choices, demo locations & educational texts
    └── sample_data.dart               # Initial demo observations for demonstration
```

---

## 🚀 Getting Started

### Prerequisites
* [Flutter SDK](https://docs.flutter.dev/get-started/install) installed (v3.20.0 or higher)
* Web browser (Chrome / Edge) or Android / iOS / Desktop environment

### Running the App Locally

1. **Clone the repository**:
   ```bash
   git clone https://github.com/parikshitkurel/citizen-science-ux.git
   cd citizen-science-ux
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run automated test suite**:
   ```bash
   flutter test
   ```

4. **Launch the application**:
   ```bash
   flutter run
   ```

---

## 🧪 Testing & Verification

The repository includes a comprehensive automated test suite:
* **Model Tests (`test/observation_test.dart`)**: Validates JSON serialization/deserialization, backwards-compatible parsing of legacy data, and `copyWith` mutations.
* **Full Journey Integration Test (`test/flow_test.dart`)**: Validates the complete user flow from Welcome → Dashboard → Steps 1-4 → Review → Save → History → Detail View.

Run tests anytime with:
```bash
flutter test
```

---

## 📌 Version 2 Roadmap

* **GPS Auto-Tagging**: Geolocation lookup for exact stream coordinates.
* **Photo Attachment**: Camera/gallery capture for visual bank evidence.
* **Cloud Sync**: Optional cloud sync with the OneAquaHealth database when internet becomes available.
* **Data Export**: Export observations to CSV / GeoJSON for community watershed groups.

---

## 📜 License & Credits

Created with ❤️ for the **OneAquaHealth × IEEE Global Hackathon** (Track 1: Citizen Science UX).  
Released under the MIT License.
