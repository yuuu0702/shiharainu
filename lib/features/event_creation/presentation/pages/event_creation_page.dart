import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EventCreationPage extends HookConsumerWidget {
  const EventCreationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('イベント作成'),
      ),
      body: const Center(
        child: Text(
          'イベント作成ページ',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}