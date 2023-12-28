import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memoiree/Screen/AddDiaryPage.dart';
import 'package:memoiree/Screen/HomePage.dart';

void main() {
  testWidgets('HomePage Design Test', (WidgetTester tester) async {
    // Build our widget
    await tester.pumpWidget(MaterialApp(home: HomePage()));

    // Verify that specific widgets and elements are present
    // expect(find.widgetWithText(AppBar, "Diary"), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.byType(StreamBuilder), findsOneWidget);
    expect(find.text("Pick Date"), findsOneWidget);
    expect(find.byType(Divider), findsWidgets);
  });
}
