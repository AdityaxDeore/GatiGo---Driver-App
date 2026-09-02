import 'package:flutter_test/flutter_test.dart';
import 'package:pink_auto/main.dart';

void main() {
  testWidgets('Driver App loads smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const PinkAutoDriverApp());

    // Verify it loads something
    expect(find.byType(PinkAutoDriverApp), findsOneWidget);
  });
}
