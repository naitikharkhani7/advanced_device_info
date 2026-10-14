import 'package:flutter_test/flutter_test.dart';

import 'package:advanced_device_info_example/main.dart';

void main() {
  testWidgets('Verify Device Info Dashboard renders', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify AppBar title is rendered.
    expect(find.text('DEVICE METRICS & SECURITY'), findsOneWidget);
  });
}
