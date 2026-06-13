import 'package:flutter_riverpod/flutter_riverpod.dart';

class GenreNotifier extends Notifier<List<Genre>> {
  @override
  List<Genre> build() {
    final List<Genre> defaultState = [];
    return(defaultState);
  }

  void addGenre(String name, String spotifyLink) {
    final List<Genre> newGenre = [Genre(name, spotifyLink)]; 
    state = state + newGenre;
  }

  void removeGenre(Genre genre) {
    var newList = List<Genre>.from(state);
    newList.remove(genre);
    state = newList;
  }
}

final genreNotifierProvider = NotifierProvider<GenreNotifier, List<Genre>>((){
  return GenreNotifier();
});

class Genre {
  String name = 'Pop';
  String spotifyLink = '';

  Genre(this.name, this.spotifyLink);

  void changeName({String name = 'Pop'}) {
    this.name = name;
  }
  void changeLink({String spotifyLink = ''}) {
    this.spotifyLink = spotifyLink;
  }
}