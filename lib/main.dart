import 'package:flutter/material.dart';
import 'package:music_quiz/pages/question_page.dart';
import 'package:music_quiz/pages/settings_page.dart';
import 'pages/genre_selection.dart';
import 'pages/home.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() => runApp(ProviderScope(child: MyApp(),));

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget current_window = QuestionPage();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: current_window
    );
  }
}