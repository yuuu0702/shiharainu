// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:shiharainu/app.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Set the test widget size to avoid overflow
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: App()));

    // Verify that the login page is shown.
    expect(find.text('Shiharainu'), findsOneWidget);
    expect(find.text('ログイン'), findsOneWidget);
  });
}
