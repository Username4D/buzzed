import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_quiz/data/genre_provider.dart';
import 'package:music_quiz/data/match_state_provider.dart';
import 'package:music_quiz/main.dart';


class GenreSelectionPage extends ConsumerStatefulWidget {
  const GenreSelectionPage({super.key});

  @override
  ConsumerState<GenreSelectionPage> createState() => _GenreSelectionPageState();
}

class _GenreSelectionPageState extends ConsumerState<GenreSelectionPage> {
  @override
  void initState() {
    print(ref.read(genreNotifierProvider));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 60, right: 60),
                child: GenreOptions(),
              ),
            ),
          ),
          Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 60,
            height: 60,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black,),
              onPressed: () {
                ref.read(appStateProvider.notifier).changePage('mainMenu');
              },
            ),
          ),
        )
        ],
      ),
    );
  }
}

class GenreOptions extends ConsumerWidget {
  const GenreOptions({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final genres = ref.watch(genreNotifierProvider);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'Select Genre:',
                textScaler: TextScaler.linear(1),
                style: Theme.of(context).textTheme.displayLarge,
                ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              height: 150,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                primary: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: genres.map((e) => GenreButton(genreName: e.name, genre: e,)).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GenreButton extends ConsumerWidget {
  const GenreButton({
    super.key, 
    required this.genreName,
    required this.genre});

  final Genre genre;
  final String genreName;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: 150,
      height: 150,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FilledButton(
          style: FilledButton.styleFrom(backgroundColor: Colors.black),
          onPressed: () {
            ref.read(MatchStateProvider.notifier).defaultState();
            ref.read(MatchStateProvider.notifier).changeState(parameterName: 'genrePath', newValue: genre.folderPath);
            ref.read(MatchStateProvider.notifier).scanPossibleSongs();
            ref.read(MatchStateProvider.notifier).startRound();
            ref.read(appStateProvider.notifier).changePage('questionPage');
          },
          child: Text(
            genreName
            ),
          ),
        ),
      );
  }
}

