import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aqua_verify/app/app.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Complete AquaVerify Track 1 Journey Test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(420, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(const AquaVerifyApp());
    await tester.pumpAndSettle();

    // 1. Welcome Screen verification
    expect(find.text('AquaVerify'), findsWidgets);
    expect(find.text('Get Started'), findsOneWidget);
    expect(find.text('View My Observations'), findsOneWidget);

    // Ensure visible and tap "Get Started" -> Home Dashboard
    await tester.ensureVisible(find.text('Get Started'));
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    // 2. Dashboard verification
    expect(find.text('Start New Assessment'), findsWidgets);
    expect(find.text('View Observation History'), findsOneWidget);
    expect(find.text('What is Citizen Science?'), findsOneWidget);

    // Tap "Start New Assessment" -> Form Wizard Step 1
    await tester.tap(find.text('Start New Assessment').first);
    await tester.pumpAndSettle();

    // 3. Step 1: Location & Water Body
    expect(find.text('Where are you observing?'), findsOneWidget);
    expect(find.text('Stream'), findsWidgets);
    expect(find.text('Willow Creek Bridge'), findsOneWidget);

    // Tap demo location quick chip
    await tester.tap(find.text('Willow Creek Bridge'));
    await tester.pumpAndSettle();

    // Tap "Next Step" -> Step 2
    await tester.ensureVisible(find.text('Next Step'));
    await tester.tap(find.text('Next Step'));
    await tester.pumpAndSettle();

    // 4. Step 2: Water Appearance
    expect(find.text('How clear does the water look?'), findsOneWidget);
    expect(find.text('Clear'), findsOneWidget);

    // Tap "Next Step" -> Step 3
    await tester.ensureVisible(find.text('Next Step'));
    await tester.tap(find.text('Next Step'));
    await tester.pumpAndSettle();

    // 5. Step 3: Environmental Factors
    expect(find.text('How is the water moving?'), findsOneWidget);
    expect(find.text('What do you notice around the water (Vegetation)?'), findsOneWidget);

    // Tap "Next Step" -> Step 4
    await tester.ensureVisible(find.text('Next Step'));
    await tester.tap(find.text('Next Step'));
    await tester.pumpAndSettle();

    // 6. Step 4: Field Notes & Disclaimer
    expect(find.text('Observation Disclaimer'), findsOneWidget);

    // Tap "Review Summary" -> Review Screen
    await tester.ensureVisible(find.text('Review Summary'));
    await tester.tap(find.text('Review Summary'));
    await tester.pumpAndSettle();

    // 7. Review & Save Screen
    expect(find.text('Review Your Assessment'), findsOneWidget);
    expect(find.text('1. Location & Water Body'), findsOneWidget);
    expect(find.text('2. Water Appearance'), findsOneWidget);
    expect(find.text('3. Environmental Factors'), findsOneWidget);
    expect(find.text('4. Field Notes & Summary'), findsOneWidget);
    expect(find.text('Save Observation'), findsOneWidget);

    // Tap "Save Observation" -> Dialog
    await tester.ensureVisible(find.text('Save Observation'));
    await tester.tap(find.text('Save Observation'));
    await tester.pumpAndSettle();

    // 8. Dialog Success & Navigation to History
    expect(find.text('Observation Saved!'), findsOneWidget);
    expect(find.text('View Observation History'), findsOneWidget);

    await tester.tap(find.text('View Observation History'));
    await tester.pumpAndSettle();

    // 9. History Screen
    expect(find.text('Observation History'), findsOneWidget);
    expect(find.text('Willow Creek Bridge Assessment'), findsWidgets);
  });
}
