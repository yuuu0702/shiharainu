import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shiharainu/shared/utils/app_logger.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shiharainu/app.dart';
import 'firebase_options.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      FlutterError.onError = (details) {
        AppLogger.error(
          'Flutter error',
          name: 'Main',
          error: details.exception,
          stackTrace: details.stack,
        );
      };

      runApp(const ProviderScope(child: App()));
    },
    (error, stack) {
      AppLogger.error(
        'Unhandled exception',
        name: 'Main',
        error: error,
        stackTrace: stack,
      );
    },
  );
}
