import 'package:flutter_riverpod/flutter_riverpod.dart';

class GenreNotifier extends Notifier<List<Genre>> {
  @override
  List<Genre> build() {
    final List<Genre> defaultState = [];
    return(defaultState);
  }

  void addGenre(String name, String folderPath) {
    final List<Genre> newGenre = [Genre(name, folderPath)]; 
    state = state + newGenre;
  }

  void removeGenre(Genre genre) {
    var newList = List<Genre>.from(state);
    newList.remove(genre);
    state = newList;
  }

  void changeGenreName(Genre genre, String name) {
    String path = genre.folderPath;
    state.remove(genre);
    state = [...state, Genre(name, path)];
  }

  void changeGenrePath(Genre genre, String path) {
    String name = genre.name;
    state.remove(genre);
    state = [...state, Genre(name, path)];
  }
}

final genreNotifierProvider = NotifierProvider<GenreNotifier, List<Genre>>((){
  return GenreNotifier();
});

class Genre {
  String name = 'Pop';
  String folderPath = '';

  Genre(this.name, this.folderPath);

  void changeName({String name = 'Pop'}) {
    this.name = name;
  }
  void changePath({String folderPath = ''}) {
    this.folderPath = folderPath;
  }
}