// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:theme/Theme/theme_storage.dart';
import 'package:theme/main.dart';

void main() {
  testWidgets('Theme is remembered after restart', (WidgetTester tester) async {
    final tempDirectory = await Directory.systemTemp.createTemp('theme_test_');
    final storageFile = File(
      '${tempDirectory.path}${Platform.pathSeparator}theme_mode.txt',
    );

    addTearDown(() async {
      if (await tempDirectory.exists()) {
        await tempDirectory.delete(recursive: true);
      }
      ThemeStorage.overridePath = null;
    });

    ThemeStorage.overridePath = storageFile.path;

    await storageFile.writeAsString('dark');

    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.text('Dark Mode'), findsOneWidget);

    await tester.tap(find.byType(GestureDetector));
    await tester.pumpAndSettle();

    expect(find.text('Light Mode'), findsOneWidget);

    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.text('Light Mode'), findsOneWidget);
  });
}
