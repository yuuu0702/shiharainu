import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shiharainu/app.dart';

void main() {
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}