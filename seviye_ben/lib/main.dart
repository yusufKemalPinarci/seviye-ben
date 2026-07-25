import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'services/local_store.dart';
import 'utils/app_theme.dart';
import 'utils/text_scale.dart';
import 'views/screens/app_gate.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Hive.initFlutter();
  await LocalStore.init();
  FlutterNativeSplash.remove();
  runApp(const ProviderScope(child: SeviyeBenApp()));
}

class SeviyeBenApp extends StatelessWidget {
  const SeviyeBenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SeviyeBen',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      builder: (context, child) {
        final media = MediaQuery.of(context);
        return MediaQuery(
          data: media.copyWith(
            textScaler: TextScalePolicy.clampScaler(media.textScaler),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const AppGate(),
    );
  }
}
