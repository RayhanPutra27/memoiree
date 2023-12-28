import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memoiree/Screen/AddDiaryPage.dart';
import 'package:memoiree/Utilities/FirestoreSystem.dart';
import 'package:memoiree/Utilities/Response.dart';
import 'package:mockito/mockito.dart';

class MockFirestoreSystem extends Mock implements FirebaseFirestore {}

void main() {
  group('AddDiaryPage Widget Tests', () {
    late MockFirestoreSystem mockFirestoreSystem;
    late FirestoreSystem firestoreSystem;
    final docId = 'your_document_id';

    setUp(() {
      mockFirestoreSystem = MockFirestoreSystem();
      firestoreSystem = FirestoreSystem(firestore: mockFirestoreSystem);
    });
    testWidgets('AddDiaryPage renders properly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: AddDiaryPage(docId: 'your_doc_id')));

      expect(find.text("How's your day?"), findsOneWidget);
      expect(find.byKey(Key('_name_field')), findsOneWidget);
      expect(find.byKey(Key('_diary_item_field')), findsOneWidget);
      expect(find.byKey(Key('_date_field')), findsOneWidget);
      expect(find.byKey(Key('_date_picker')), findsOneWidget);
      expect(find.byKey(Key('_post_diary_button')), findsOneWidget);
    });

    testWidgets('Entering valid data and posting diary navigates to HomePage', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: AddDiaryPage(docId: 'your_doc_id')));

      await tester.enterText(find.byKey(Key('_name_field')), 'Test Diary');
      await tester.enterText(find.byKey(Key('_diary_item_field')), 'This is a test diary entry');

      await tester.tap(find.byKey(Key('_date_picker')));
      await tester.pumpAndSettle();

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('_post_diary_button')));

      await tester.pumpAndSettle();
    });

    testWidgets('Entering valid data posts a diary', (WidgetTester tester) async {
      when(firestoreSystem.postDiary(
        title: 'title',
        dateDiary: 'dateDiary',
        diaryItem: 'diaryItem',
        imageUrl: 'imageUrl',
        docId: 'docId',
      )).thenAnswer((_) async => Response(code: 200, message: "Sucessfully create proyek to database"));

      await tester.pumpWidget(MaterialApp(
        home: AddDiaryPage(docId: docId),
      ));

      await tester.enterText(find.byKey(Key('_name_field')), 'My Diary');
      await tester.enterText(find.byKey(Key('_diary_item_field')), 'A wonderful day!');
      await tester.tap(find.byKey(Key('_post_diary_button')));

      await tester.pumpAndSettle();

      verify(firestoreSystem.postDiary(
        title: 'My Diary',
        dateDiary: "asd",
        diaryItem: 'A wonderful day!',
        imageUrl: "imageUrl",
        docId: docId,
      )).called(1);

    });

    // Add more tests as needed for other scenarios and edge cases.
  });
}
