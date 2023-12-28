import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memoiree/Screen/LoginPage.dart';
import 'package:memoiree/Screen/RegisterPage.dart';
import 'package:memoiree/Utilities/AuthService.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockUserCredential extends Mock implements UserCredential {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  @override
  Future<UserCredential> createUserWithEmailAndPassword({
    required String? email,
    required String? password,
  }) =>
      super.noSuchMethod(
          Invocation.method(#createUserWithEmailAndPassword, [email, password]),
          returnValue: Future.value(MockUserCredential()));
}

void main() {
  group('RegisterPage Widget Tests', () {
    final MockFirebaseAuth mockFirebaseAuth = MockFirebaseAuth();
    final AuthService authService = AuthService(mockFirebaseAuth);

    testWidgets('RegisterPage renders properly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: RegisterPage()));

      expect(find.text('Name'), findsOneWidget);
      expect(find.byKey(Key('tf_email')), findsOneWidget);
      expect(find.byKey(Key('tf_password')), findsOneWidget);
      expect(find.byKey(Key('tf_name')), findsOneWidget);
      expect(find.byKey(Key('tf_username')), findsOneWidget);
      expect(find.byKey(Key('tf_phone')), findsOneWidget);
      expect(find.byKey(Key('btn_sign_in')), findsOneWidget);
      expect(find.byKey(Key('btn_sign_up')), findsOneWidget);
    });

    testWidgets('Successful registration navigates to LoginPage',
        (WidgetTester tester) async {
          // Arrange
          when(mockFirebaseAuth.createUserWithEmailAndPassword(
              email: 'test@example.com', password: 'password'))
              .thenAnswer((_) async => MockUserCredential());

          // Act
          final result = await authService.signUp2(
            email: 'test@example.com',
            password: 'password',
            name: 'Test Name',
            username: 'testuser',
            phoneNumber: '1234567890',
          );

          // Assert
          expect(result, 'Success');

      await tester.pumpWidget(MaterialApp(home: RegisterPage()));
      await tester.enterText(find.byKey(Key('tf_email')), 'test@example.com');
      await tester.enterText(find.byKey(Key('tf_password')), 'password');
      await tester.enterText(find.byKey(Key('tf_fullname')), 'John Doe');
      await tester.enterText(find.byKey(Key('tf_username')), 'johndoe');
      await tester.enterText(find.byKey(Key('tf_phone')), '1234567890');
      await tester.tap(find.byKey(Key('btn_sign_up')));
      await tester.pumpAndSettle();
    });

    testWidgets('Failed registration shows error message',
        (WidgetTester tester) async {
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: 'email',
        password: 'password',
      )).thenThrow(FirebaseAuthException(
          code: 'email-already-in-use', message: 'Email already in use'));

      await tester.pumpWidget(MaterialApp(home: RegisterPage()));
      await tester.enterText(find.byKey(Key('tf_email')), 'test@example.com');
      await tester.enterText(find.byKey(Key('tf_password')), 'password');
      await tester.enterText(find.byKey(Key('tf_fullname')), 'John Doe');
      await tester.enterText(find.byKey(Key('tf_username')), 'johndoe');
      await tester.enterText(find.byKey(Key('tf_phone')), '1234567890');
      await tester.tap(find.byKey(Key('btn_sign_up')));
      await tester.pumpAndSettle();
    });

    // Add more tests as needed for other scenarios and edge cases.
  });
}
