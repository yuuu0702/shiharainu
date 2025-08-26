import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GamificationPage extends HookConsumerWidget {
  const GamificationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ランキング・バッジ'),
      ),
      body: const Center(
        child: Text(
          'ゲーミフィケーションページ',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}