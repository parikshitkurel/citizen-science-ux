# AquaVerify — Project Description Document
**OneAquaHealth × IEEE Hackathon | Track 1: Citizen Science UX**

---

## 1. Executive Summary
**AquaVerify** is an intuitive, mobile-first freshwater observation application designed to bridge the gap between community members and local stream monitoring initiatives. By replacing intimidating scientific jargon with plain-language visual choices, guided step-by-step forms, and offline-first local storage, AquaVerify empowers students, citizen scientists, and local volunteers to record high-quality freshwater observations effortlessly.

---

## 2. Problem Statement
Freshwater streams, rivers, and ponds in urban and rural ecosystems require consistent monitoring. However, traditional citizen science apps suffer from:
* **Complex Terminology**: Technical terms like *turbidity (NTU)*, *dissolved oxygen*, or *hydrological velocity* confuse non-experts.
* **Intimidating Forms**: Long, unguided form fields cause high user bounce rates during field observation.
* **Lack of Context & Feedback**: Users often don't understand why specific data points are collected.
* **False Scientific Claims**: Apps sometimes misrepresent user estimates as laboratory-grade measurements.

---

## 3. Target Users
1. **Students & Educators**: K-12 and university students conducting environmental field trips.
2. **Citizen Scientists & Volunteers**: Local stream-watch group participants and river stewards.
3. **Community Visitors**: Citizens walking near local rivers, lakes, ponds, or urban canals.

---

## 4. Proposed Solution & Track 1 Alignment
AquaVerify addresses **Track 1: Citizen Science UX** through four core design innovations:

### A. Terminology Simplification Matrix
| Scientific Concept | Standard Technical Term | AquaVerify Plain-Language Question |
|---|---|---|
| Light attenuation / NTU | Turbidity | *"How clear does the water look?"* (Clear / Slightly cloudy / Very cloudy) |
| Colorimetric hue | Chromaticity | *"Visible water colour"* (Normal / Greenish / Brownish / Unusual) |
| Olfactory analysis | Odour classification | *"Water odour"* (No unusual odour / Mild / Strong) |
| Flow rate | Hydrological velocity | *"Surface water movement"* (Still / Light movement / Fast movement) |
| Debris density | Solid waste pollution | *"Visible litter / trash"* (None noticed / Small amount / Large amount) |

### B. Guided Multi-Step Wizard
Instead of overwhelming users with a single long form, AquaVerify breaks observations into 4 digestible steps with clear progress indicators:
1. **Basic Location & Water Body**
2. **Water Appearance**
3. **Environmental Factors**
4. **Additional Field Notes & Summary**

### C. Data Accuracy Strategy
* **Predefined Standard Options**: Restricts inputs to mutually understandable choices.
* **Always-Available "Unsure" Choice**: Prevents forced guessing when conditions are ambiguous.
* **Verification & Review Step**: Allows users to review all answers before saving.
* **Transparent Non-Scientific Disclaimer**: Clarifies that records represent observational citizen reports rather than certified lab tests.

---

## 5. User Journey Walkthrough
1. **Welcome Screen**: User opens AquaVerify, learns the core tagline *"Observe water. Understand your surroundings."*, and taps *"Get Started"*.
2. **Home Dashboard**: User views their local observation workspace, total observation counter, and recent observation previews.
3. **Guided Observation Form**: User follows the 4-step wizard, benefiting from expandable *"Why we ask this"* tooltip cards explaining ecological relevance.
4. **Review & Save**: User inspects the formatted summary, acknowledges the citizen science disclaimer, and taps *"Save Observation"*.
5. **History & Detail View**: Data is persisted locally on-device. The user views their history list, searches by location, or exports a summary report.

---

## 6. Technology Stack
* **Framework**: Flutter 3.44+ / Dart 3.12+
* **UI & Styling**: Material 3 Design System with custom HSL-tailored aquatic color tokens
* **Local Persistence**: `SharedPreferences` with structured JSON serialization
* **Architecture**: Repository Pattern (`ObservationRepository`) for decoupling storage from UI logic

---

## 7. Expected Environmental & Social Impact
* **Higher Data Volume**: Reduced friction encourages frequent repeat observations along local waterways.
* **Increased Environmental Literacy**: Integrated educational tooltips help citizens understand stream health factors.
* **Community Empowerment**: Enables local watershed associations to collect structured field reports for conservation planning.

---

## 8. Limitations & Future Extensions
* **Current Version**: Operates 100% offline using local storage without cloud login.
* **Version 2 Scope**: GPS location auto-fill, camera photo attachment, GeoJSON export, and OneAquaHealth cloud database sync.
