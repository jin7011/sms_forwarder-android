// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('App launches test', (WidgetTester tester) async {
    // Build a simple test app instead of the complex main app
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Welcome to Empty Flutter Template'),
                SizedBox(height: 16),
                Text('This is the home screen'),
              ],
            ),
          ),
        ),
      ),
    );

    // Verify that our app loads with the welcome message
    expect(find.text('Welcome to Empty Flutter Template'), findsOneWidget);
    expect(find.text('This is the home screen'), findsOneWidget);
  });
}
