import 'package:flutter/material.dart';
import "package:firebase_core/firebase_core.dart";

import '../constants/constants.dart';
import '../screens/language_collection_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBK7qXy_4doGyAmKfKwqcaykCXFbgpxj3w",
      appId: "1:830261894266:web:a106209319cf886c9eefc3",
      messagingSenderId: "830261894266",
      projectId: "ngerti-83bcd",
      authDomain: "ngerti-83bcd.firebaseapp.com",
      storageBucket: "ngerti-83bcd.appspot.com",
    ),
  );

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
