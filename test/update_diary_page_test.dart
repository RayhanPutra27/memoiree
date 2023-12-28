import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memoiree/Utilities/FirestoreSystem.dart';
import 'package:mockito/mockito.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:memoiree/Screen/UpdateDiaryPage.dart';

void main() {
  testWidgets('UpdateDiaryPage Design Test', (WidgetTester tester) async {
    // Build our widget
    await tester.pumpWidget(
      MaterialApp(
        home: UpdateDiaryPage(
          docId: 'sampleDocId',
          diaryId: 'sampleDiaryId',
          title: 'Sample Title',
          diary: 'Sample Diary Content',
          date: 'October 26, 2023',
          imageUrl: 'sampleImageUrl',
        ),
      ),
    );

    // Verify that specific widgets are present and have the expected text
    expect(find.text("How's your day?"), findsOneWidget);
    expect(find.text('Sample Title'), findsOneWidget);
    expect(find.text('Sample Diary Content'), findsOneWidget);
    expect(find.text('October 26, 2023'), findsOneWidget);
    expect(find.text('Post Diary'), findsOneWidget);

    // Verify that TextFormField and ElevatedButton widgets are present
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.byType(ElevatedButton), findsOneWidget);

    // You can add more widget checks as needed for your design

    // Example: Check if a button with a specific text is present
    expect(find.widgetWithText(TextButton, 'Post Diary'), findsOneWidget);
  });
}
