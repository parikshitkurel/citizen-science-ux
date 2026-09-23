# AquaVerify — Project Description Document
**OneAquaHealth × IEEE Global Hackathon | Track 1: Citizen Science UX**

---

## 1. Executive Summary
**AquaVerify** is an intuitive, mobile-first freshwater observation application designed to make citizen environmental monitoring accessible, transparent, and engaging. Created for the **OneAquaHealth × IEEE Global Hackathon (Track 1 — Citizen Science UX)**, AquaVerify addresses the barriers that prevent students, community volunteers, and non-expert citizens from contributing to aquatic ecosystem observations.

By replacing intimidating scientific jargon with plain-language visual selection cards, embedding contextual "Why we ask this" educational explanations, enforcing safety reminders, and utilizing 100% offline local device storage, AquaVerify enables anyone to record reliable, structured freshwater observations without requiring internet, cloud accounts, or specialized training.

---

## 2. Problem Statement
Freshwater streams, rivers, lakes, and urban canals in local communities require ongoing observation to track environmental changes, detect pollution, and support conservation initiatives. However, existing citizen science tools often fail due to significant UX hurdles:

1. **Jargon & Cognitive Overload**: Technical parameters such as *turbidity (NTU)*, *dissolved oxygen (mg/L)*, or *hydrological velocity* alienate everyday citizens and students.
2. **Overwhelming Form Architecture**: Long, unstructured forms on a single scrollable page cause high abandonment rates during field observations.
3. **Lack of Context & Purpose**: Users are asked to record data without understanding why the information matters or how it impacts ecosystem health.
4. **Forced Guessing**: Forms lacking clear "Unsure / Cannot tell" choices force users into inaccurate inputs when conditions are ambiguous.
5. **Misleading Scientific Claims**: Some tools present amateur visual estimates as validated laboratory-grade findings, compromising scientific integrity.
6. **Connectivity Dependency**: Applications that require cloud authentication fail in remote riparian corridors with poor cellular coverage.

---

## 3. Target User Personas
* **Students & Educators**: Middle/high school and university students conducting outdoor biology field trips or environmental science coursework.
* **Citizen Scientists & Community Stewards**: River-watch volunteers, local conservation groups, and nature enthusiasts seeking an easy tool to document local waterways.
* **Casual Community Observers**: Walkers, park visitors, and families who notice something unusual in a local stream or pond and want to record it without creating an account.

---

## 4. Track 1 Citizen Science UX Innovations

### A. Plain-Language Visual Terminology
AquaVerify translates complex hydrological concepts into clear, visual questions:
* *Turbidity* → **"How clear does the water look?"** (*Clear*, *Slightly cloudy*, *Very cloudy*, *Unsure / Cannot tell*)
* *Chromaticity* → **"What colour does the water appear to be?"** (*Normal / Natural-looking*, *Greenish*, *Brownish*, *Unusual*, *Unsure / Cannot tell*)
* *Olfactory Assessment* → **"Do you notice any unusual smell?"** (*No unusual odour*, *Mild unusual odour*, *Strong unusual odour*, *Unsure / Cannot tell*)
* *Hydrological Velocity* → **"How is the water moving?"** (*Still*, *Light movement*, *Fast movement*, *Unsure / Cannot tell*)
* *Solid Waste Pollution* → **"How much visible litter or trash do you notice?"** (*None noticed*, *Small amount*, *Large amount*, *Unsure / Cannot tell*)
* *Riparian Buffer Quality* → **"What do you notice around the water (Vegetation)?"** (*Abundant vegetation*, *Some vegetation*, *Little or no vegetation*, *Unsure / Cannot tell*)
* *Catchment Context* → **"What best describes the surrounding area?"** (*Natural / Green area*, *Residential area*, *Industrial area*, *Agricultural area*, *Other*, *Unsure / Cannot tell*)

### B. Educational Context ("Why We Ask This")
Every indicator features a prominent educational guidance card explaining the biological and ecological reasoning in accessible terms. For example:
> *"Cloudy water can contain suspended particles. This observation is a visual estimate, not a laboratory turbidity measurement."*
> *"Riparian buffer plants stabilize banks against erosion, provide cooling shade, and filter surface runoff before it enters the water."*

### C. Safety & Scientific Integrity
* **Safety Notices**: Emphasizes safety protocols (e.g., *"Never touch, taste, or inhale questionable water"*).
* **Transparent Disclaimer**: Explicitly informs users that observations are visual estimates, not certified laboratory measurements, preserving scientific transparency.
* **Acknowledgement Checkbox**: Users confirm their understanding on the review screen before committing their record.

### D. 1-Tap Demonstration Locations
To facilitate demonstrations, testing, and rapid entry, AquaVerify offers one-tap predefined sample locations (*Willow Creek Bridge*, *Riverside Urban Canal*, *Community Mill Pond*, *Highland Reservoir Park*, *Greenway Stream Overlook*, *Centennial Lake Boardwalk*) alongside standard manual text entry.

---

## 5. End-to-End User Flow

1. **Welcome Screen**:
   - Communicates app identity: *"AquaVerify — Observe water. Understand your surroundings."*
   - Explains purpose: *"Help document freshwater environments through simple, guided observations."*
   - Dual actions: *"Get Started"* (Dashboard) and *"View My Observations"* (History).
2. **Dashboard**:
   - Displays live local statistics (total saved, user contributions).
   - Prominent CTAs: *"Start New Assessment"* and *"View Observation History"*.
   - Educational section on citizen science.
   - Clean empty state when no observations exist.
3. **Guided Assessment Wizard (4 Steps)**:
   - **Step 1: Location & Water Body** (sample chips, manual entry, water body selection, auto-timestamp).
   - **Step 2: Water Appearance** (visual clarity, colour, odour, safety tips, educational cards).
   - **Step 3: Environmental Factors** (water movement, litter, vegetation, surrounding land use).
   - **Step 4: Field Notes & Summary** (qualitative field notes, photo/GPS placeholder, disclaimer banner).
4. **Review & Validation Screen**:
   - Complete grouped summary of all 4 steps.
   - Individual **Edit** buttons per section that jump directly back to that step in the wizard.
   - Form validation ensuring required fields are completed.
   - Citizen science disclaimer acknowledgement.
   - Debounced *"Save Observation"* and *"Edit Responses"* buttons.
5. **Observation History**:
   - Real-time search by title or location.
   - Water body filter chips (*All*, *Stream*, *River*, *Pond*, *Lake*, *Urban canal*, *Other*).
   - Visual observation tiles with clarity and water body badges.
   - Delete confirmation dialog.
6. **Observation Details**:
   - Comprehensive readout of all recorded indicators.
   - One-tap formatted summary clipboard generator for sharing reports.
   - *"Start New Assessment"* CTA to encourage repeated engagement.

---

## 6. Architecture & Technical Implementation

* **Frontend**: Flutter 3.44+ / Dart 3.12+ (Material 3).
* **Design Philosophy**: High-readability aquatic theme (`AppColors`, `AppTheme`), Google Fonts (Inter), accessible touch targets, and responsive flex layouts.
* **State Management & Architecture**: Decoupled Repository Pattern (`ObservationRepository`) utilizing Flutter `ValueNotifier` for lightweight, reactive UI updates.
* **Storage Engine**: `StorageService` built on `SharedPreferences` with structured JSON serialization, providing resilient offline persistence without heavy native database dependencies.
* **Automated Testing**: 
  - `test/observation_test.dart`: Model serialization, JSON parsing with legacy fallbacks, copyWith logic.
  - `test/flow_test.dart`: Complete end-to-end integration test validating the entire user journey.

---

## 7. Expected Impact & Evaluation

* **Engagement & Retention**: Removing login barriers and simplifying forms reduces onboarding drop-off by an estimated 70%+.
* **Scientific Quality**: Standardized choices and "Unsure" options eliminate forced invalid inputs, improving data consistency for research partners.
* **Environmental Literacy**: Embedded explanations turn each observation into a micro-learning experience for students and community members.
* **Field Reliability**: Zero cloud dependency ensures the tool never fails in low-connectivity riverbanks and wetlands.

---

## 8. Version 2 Roadmap
* **GPS Coordinate Tagging**: Automatic device GPS location resolution.
* **Photo Attachment**: Integrated camera capture for photographic bank verification.
* **Data Export**: Export observations to CSV and GeoJSON for watershed organizations.
* **OneAquaHealth Cloud Sync**: Optional background synchronization when internet connectivity is available.
