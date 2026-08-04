import 'package:flutter_test/flutter_test.dart';

import 'package:vexa_ai_fashion_app/main.dart';

void main() {
  testWidgets('VEXA boots to the splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const VexaApp());
    expect(find.text('Your AI Fashion Assistant'), findsOneWidget);
  });
}
