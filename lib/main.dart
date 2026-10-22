import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'design_tokens.dart';
import 'home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const LoquitoPhoneApp());
}

class LoquitoPhoneApp extends StatelessWidget {
  const LoquitoPhoneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'El loquito',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: LoquitoTokens.cork,
        colorScheme: ColorScheme.fromSeed(
          seedColor: LoquitoTokens.catGreen,
          brightness: Brightness.dark,
        ),
      ),
      builder: (context, child) {
        final esMovil = !kIsWeb &&
            (defaultTargetPlatform == TargetPlatform.android ||
                defaultTargetPlatform == TargetPlatform.iOS);

        final contenido = Material(
          type: MaterialType.transparency,
          child: child,
        );

        if (esMovil) return contenido;

        return ColoredBox(
          color: Colors.black,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: contenido,
            ),
          ),
        );
      },
      home: const Scaffold(
        backgroundColor: LoquitoTokens.cork,
        body: SafeArea(
          bottom: false,
          child: LoquitoHomeScreen(),
        ),
      ),
    );
  }
}