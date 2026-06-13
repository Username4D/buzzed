import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_quiz/data/genre_provider.dart';



class GenreSelectionPage extends StatefulWidget {
  const GenreSelectionPage({super.key});

  @override
  State<GenreSelectionPage> createState() => _GenreSelectionPageState();
}

class _GenreSelectionPageState extends State<GenreSelectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 60, right: 60),
            child: GenreOptions(),
          ),
        ),
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
    print(genres);
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
              child: ListView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                primary: true,
                children: genres.map((e) => GenreButton(genreName: e.name,)).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GenreButton extends StatelessWidget {
  GenreButton({
    super.key, 
    this.genreName = 'Rock'});

  String genreName = 'Rock';
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 150,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FilledButton(
          style: Theme.of(context).filledButtonTheme.style,
          onPressed: () {
            print("Wow");
          },
          child: Text(
            genreName
            ),
          ),
        ),
      );
  }
}

