import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:memoiree/Screen/HomePage.dart';
import 'package:memoiree/Screen/LoginPage.dart';
import 'package:memoiree/Utilities/AuthService.dart';
import 'package:mockito/mockito.dart';

class MockUserCredential extends Mock implements UserCredential {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String? email,
    required String? password,
  }) =>
      super.noSuchMethod(
          Invocation.method(#signInWithEmailAndPassword, [email, password]),
          returnValue: Future.value(MockUserCredential()));
}
// class MockUserCredential extends Mock implements UserCredential {}

void main() {
  group('LoginPage Widget Tests', () {
    final MockFirebaseAuth mockFirebaseAuth = MockFirebaseAuth();
    final AuthService authService = AuthService(mockFirebaseAuth);

    testWidgets('LoginPage renders properly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginPage()));

      expect(find.byKey(Key('tf_email')), findsOneWidget);
      expect(find.byKey(Key('tf_password')), findsOneWidget);
      expect(find.byKey(Key('btn_sign_in')), findsOneWidget);
      expect(find.byKey(Key('btn_sign_up')), findsOneWidget);
    });

    test('signIn returns Success when login is successful, go to Home Page',
        () async {
      when(mockFirebaseAuth.signInWithEmailAndPassword(
              email: 'test@example.com', password: 'password'))
          .thenAnswer((_) async => MockUserCredential());

      final result = await authService.signIn(
        email: 'test@example.com',
        password: 'password',
      );
      print(result);

      expect(result, 'Success');
    });

    testWidgets('Successful login navigates to HomePage',
        (WidgetTester tester) async {
      when(mockFirebaseAuth.signInWithEmailAndPassword(
              email: 'test@example.com', password: 'password'))
          .thenAnswer((_) async => MockUserCredential());

      final result = await authService.signIn(
        email: 'test@example.com',
        password: 'password',
      );
      print(result);

      expect(result, 'Success');
      await tester.pumpWidget(MaterialApp(home: LoginPage()));
      await tester.enterText(find.byKey(Key('tf_email')), 'test@example.com');
      await tester.enterText(find.byKey(Key('tf_password')), 'password');
      await tester.tap(find.byKey(Key('btn_sign_in')));
      await tester.pumpAndSettle();
    });

    testWidgets('Failed login shows error message',
        (WidgetTester tester) async {
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: 'email',
        password: 'password',
      )).thenThrow(FirebaseAuthException(
        code: 'wrong-password',
        message: 'Wrong password provided for that user.',
      ));

      await tester.pumpWidget(MaterialApp(home: LoginPage()));
      await tester.enterText(find.byKey(Key('tf_email')), 'test@example.com');
      await tester.enterText(
          find.byKey(Key('tf_password')), 'incorrect_password');
      await tester.tap(find.byKey(Key('btn_sign_in')));
      await tester.pumpAndSettle();

      expect(
          find.text('Wrong password provided for that user.'), findsOneWidget);
    });
  });
}
