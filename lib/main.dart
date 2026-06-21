import 'package:flutter/material.dart';
import 'package:music_quiz/pages/genre_selection.dart';
import 'package:music_quiz/pages/home.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_quiz/pages/settings_page.dart';

class AppStateNotifier extends Notifier<Map<String, dynamic>> {
  Map<String, dynamic> siteMap = {'mainMenu': () => HomeScreen(key: UniqueKey(),), 'genreSelection': () => GenreSelectionPage(key: UniqueKey(),), 'settingsPage': () => SettingsPage(key: UniqueKey()), };

  @override
  Map<String, dynamic> build() {
    var defaultState = <String,dynamic>{};
    defaultState['currentPage'] = HomeScreen();
    return defaultState;
  }

  void changePage(String page) {
    print(siteMap[page]);
    if (siteMap[page] != null) {
      print(siteMap[page]());
      state = {...state, 'currentPage': siteMap[page]()};
    }
  }
}

final appStateProvider = NotifierProvider(() {
  return AppStateNotifier();
});

void main() => runApp(ProviderScope(child: MyApp(),));

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ref.watch(appStateProvider)['currentPage']
    );
  }
}

