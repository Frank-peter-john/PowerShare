import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:powershare/screens/authentication/login.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'screens/themes/theme_constants.dart';
import 'screens/themes/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider<ThemeProvider>(
      create: (_) => ThemeProvider()..initialize(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, provider, child) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Rento',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: provider.themeMode,
        home: const LoginScreen(),
      );
    });
  }
}
