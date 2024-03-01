import 'package:flutter/material.dart';
import 'package:thapar_pyqs/screens/home.dart';
import 'dart:io';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:thapar_pyqs/utils/http_client.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const HomePage(),
        theme: ThemeData(colorScheme: lightColorScheme),
        darkTheme: ThemeData(colorScheme: darkColorScheme),
        themeMode: ThemeMode.system,
      );
    });
  }
}
