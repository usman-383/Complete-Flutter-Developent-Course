import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_programming_fundamentals/main.dart';

void main() {
  testWidgets('drawer Home item navigates to HomePage', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();

    expect(find.text('Home page'), findsOneWidget);
  });
}
