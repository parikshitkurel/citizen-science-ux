import 'package:flutter_test/flutter_test.dart';
import 'package:aqua_verify/app/app.dart';

void main() {
  testWidgets('AquaVerifyApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AquaVerifyApp());

    // Verify that AquaVerify loading or welcome screen renders
    expect(find.byType(AquaVerifyApp), findsOneWidget);
  });
}
