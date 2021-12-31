import 'package:flutter/material.dart';
import "package:firebase_core/firebase_core.dart";

import '../constants/constants.dart';
import '../screens/language_collection_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(backgroundColor: colorTheme),
        floatingActionButtonTheme:
            const FloatingActionButtonThemeData(backgroundColor: colorTheme),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(colorTheme),
          ),
        ),
      ),
      title: "ngerti",
      home: const LanguageCollectionScreen(),
    );
  }
}
