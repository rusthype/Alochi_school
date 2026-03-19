import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/app.dart';
import 'features/auth/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();
  await container.read(authProvider.notifier).fetchMe();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const AlochiMaktabApp(),
    ),
  );
}
