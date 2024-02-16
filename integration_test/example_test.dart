import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/firebase_options.dart';
import 'package:my_app/main.dart';
import 'package:patrol/patrol.dart';

void main() {
  patrolTest(
    'counter state is the same after going to home and switching apps',
    ($) async {
      await $.pumpWidgetAndSettle(const MyApp());

      expect($('0'), findsOneWidget);
      expect($('1'), findsNothing);

      // tap increment fab
      await $(#fab).tap();

      expect($('0'), findsNothing);
      expect($('1'), findsOneWidget);

      if (!Platform.isMacOS) {
        await $.native.pressHome();
      }
    },
  );

  patrolTest(
    'user is able to log in',
    ($) async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      await $.pumpWidgetAndSettle(const MyApp());

      expect($(#login_button), findsOneWidget);
      await $(#login_button).tap();

      await $.pumpWidgetAndSettle(const MyApp());

      expect($(#successful_login_container), findsNothing);
      expect($(#loader), findsOneWidget);

      await $.pumpWidgetAndSettle(const MyApp());

      expect($(#successful_login_container), findsOneWidget);
      expect($(#loader), findsNothing);

      expect($(#does_not_exist), findsOneWidget);

      if (!Platform.isMacOS) {
        await $.native.pressHome();
      }
    },
  );
}
