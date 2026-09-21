# AquaVerify 🌊
> **Observe water. Understand your surroundings.**

A guided freshwater observation app created for the **OneAquaHealth × IEEE Hackathon** (Track 1: Citizen Science UX). **AquaVerify** helps ordinary citizens, students, local volunteers, and community members record clear, structured stream and water-body observations without requiring advanced scientific knowledge or complex technical jargon.

---

## 🌟 Hackathon Context & Positioning

| Parameter | Details |
|---|---|
| **Hackathon** | OneAquaHealth × IEEE Hackathon |
| **Track** | **Track 1: Citizen Science UX** |
| **Challenge** | Improve citizen science app experiences for stream assessments |
| **Core Problem** | Complex tools, confusing scientific terminology, long forms, and lack of immediate feedback discourage repeat participation |
| **Solution** | A beginner-friendly, guided freshwater observation app focused on UX, plain language, and instant visual feedback |

---

## ✨ Key Features

1. **Guided Multi-Step Workflow**: A 4-step observation wizard that clearly indicates progress, current section, and what step comes next.
2. **Simplified Ecological Terminology**: Scientific jargon is replaced with intuitive, plain-language questions (e.g., *"How clear does the water look?"* instead of turbidity units).
3. **Beginner Guidance & Tooltips**: Collapsible *"Why we ask this"* cards explain ecological concepts in plain English so users learn while observing.
4. **Data Accuracy & "Unsure" Options**: Every qualitative choice provides an "Unsure" option alongside visual choices to prevent forced incorrect answers.
5. **Review & Non-Scientific Disclaimer**: Dedicated verification step before saving. Explicitly clarifies that records represent citizen observations, avoiding false laboratory scientific claims.
6. **100% Offline Local Storage**: Built-in persistence using `SharedPreferences` with JSON serialization so observations save directly on-device without cloud dependency.
7. **Observation History & Search**: Instant local search by title or location, filtering by water body type (River, Stream, Pond, Lake, Canal, Other), and detail view with clipboard summary export.
8. **Repeat Engagement**: Dashboard statistics, recent observation previews, and prominent *"Make Another Observation"* CTAs encourage repeated community involvement.

---

## 📸 Screenshots & Workflow

```
[ Welcome Screen ]  -->  [ Home Dashboard ]  -->  [ Guided Form Wizard ]  -->  [ Review & Save ]  -->  [ History & Details ]
```

---

## 🛠️ Technology Stack & Architectural Decision

* **Frontend Framework**: Flutter (v3.44.1+), Dart SDK (v3.12.1+)
* **Design System**: Material 3 with custom aquatic palette (Primary Navy `#17324D`, Primary Teal `#2D8C88`, Surface `#F4F8F7`)
* **Typography**: Google Fonts (Inter)
* **Local Storage Choice**: **`SharedPreferences`** with structured JSON serialization via `ObservationRepository`.
  * *Rationale*: `SharedPreferences` was selected over complex embedded databases (like Hive/Isar) because it provides **100% cross-platform zero-dependency stability** across Web (Chrome/Edge), Desktop (Windows/macOS), Android, and iOS without native C++ compilation friction. The data access is abstracted behind an `ObservationRepository` pattern, allowing seamless swapping to a cloud backend (PostgreSQL/Supabase/Firebase) in future iterations.

---

## 📂 Project Structure

```
lib/
├── main.dart                          # App entry point & initialization
├── app/
│   ├── app.dart                       # MaterialApp configuration & splash state
│   └── theme.dart                     # Material 3 theme & color palette
├── models/
│   └── observation.dart               # Observation data model with JSON serialization
├── services/
│   └── storage_service.dart           # SharedPreferences storage wrapper
├── repositories/
│   └── observation_repository.dart    # Reactive repository & sample data manager
├── screens/
│   ├── welcome_screen.dart            # Screen 1: Welcome & Branding Splash
│   ├── home_screen.dart               # Screen 2: Workspace Home Dashboard
│   ├── observation_form_screen.dart   # Screen 3: Guided 4-Step Form Wizard
│   ├── review_save_screen.dart        # Screen 4: Data Verification & Review
│   ├── history_screen.dart            # Screen 5: Local Observation History & Search
│   └── details_screen.dart            # Screen 6: Detailed Readout & Report Export
├── widgets/
│   ├── custom_button.dart             # Primary, Secondary, Outlined & Danger buttons
│   ├── form_step_indicator.dart       # Step progress indicator widget
│   ├── info_tooltip_card.dart         # Expandable beginner guidance tooltip card
│   ├── observation_tile.dart          # Observation summary list card
│   └── status_badge.dart              # Water clarity, water body & demo chips
└── utils/
    ├── app_colors.dart                # Color tokens matching hackathon specification
    ├── constants.dart                 # Form options & beginner guidance text
    └── sample_data.dart               # Seed demo observations for demonstration
```

---

## 🚀 Getting Started & How to Run

### Prerequisites
* [Flutter SDK](https://docs.flutter.dev/get-started/install) installed (v3.20.0 or higher)
* Chrome / Edge browser (for Web) or Windows / macOS / Linux desktop environment

### Installation Steps

1. **Clone the repository**:
   ```bash
   git clone https://github.com/your-username/aqua_verify.git
   cd aqua_verify
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run unit & widget tests**:
   ```bash
   flutter test
   ```

4. **Run the application locally**:
   * **Web (Chrome)**:
     ```bash
     flutter run -d chrome
     ```
   * **Windows Desktop**:
     ```bash
     flutter run -d windows
     ```

---

## 🧪 Testing & Verification

The project includes unit tests for `Observation` serialization and widget tests for app rendering:
```bash
flutter test
```
All tests pass cleanly without errors or warnings.

---

## 📌 MVP Limitations & Future Scope

### Current MVP Scope (Version 1)
* Operates fully offline using local device storage.
* Seeded with 2 realistic sample observations for preview, clearly marked with a "Demo" badge.
* Plain-language qualitative indicators (clarity, colour, odour, surface movement, litter).

### Future Roadmap (Version 2)
* **GPS Auto-Tagging**: Geolocation lookup for exact stream coordinates.
* **Photo Attachment**: Camera/gallery photo capture for visual evidence.
* **Backend Synchronization**: Sync local observations to a OneAquaHealth cloud database.
* **Data Export**: Export observations to CSV / GeoJSON for community environmental groups.

---

## 📜 License & Credits

Built with ❤️ for **OneAquaHealth × IEEE Hackathon** (Track 1: Citizen Science UX).  
Released under the MIT License.
