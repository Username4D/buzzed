import 'package:riverpod/riverpod.dart';

class GenreNotifier extends Notifier<List<String>> {
  @override
  List<String> build() {
    final List<String> defaultState = ['Pop', 'Rock', 'Classic', 'EDM', 'Pop', 'Rock', 'Classic', 'EDM', 'Pop', 'Rock', 'Classic', 'EDM'];
    return(defaultState);
  }

  void addGenre(String name) {
    print(state);
    final List<String> newGenre = [name]; 
    state = state + newGenre;
  }
}

final GenreNotifierProvider = NotifierProvider<GenreNotifier, List<String>>((){
  return GenreNotifier();
});