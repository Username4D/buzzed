import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:path/path.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_quiz/pages/question_page.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class MatchState extends Notifier<Map<String, dynamic>> {
  late Random rng;

  @override
  Map<String, dynamic> build() {
    Map<String, dynamic> defaultState = <String, dynamic>{};
    rng = Random();
    defaultState['round'] = 0;
    defaultState['scoreRed'] = 0;
    defaultState['scoreBlue'] = 0;
    defaultState['currentQuestionPage'] = QuestionPage();
    defaultState['currentSong'];
    defaultState['genrePath'] = '';
    defaultState['hasBuzzered'] = false;
    defaultState['hasConfirmedGuess'] = false;
    defaultState['oldQuestionPage'] = null;
    defaultState['timer'] = null;
    defaultState['canBuzzer'] = false;
    defaultState['possibleSongs'] = [];
    defaultState['audioPlayer'] = AudioPlayer(playerId: UniqueKey().toString());
    return defaultState;

  }

  void defaultState() {
    Map<String, dynamic> defaultState = <String, dynamic>{};
    defaultState['round'] = 0;
    defaultState['scoreRed'] = 0;
    defaultState['scoreBlue'] = 0;
    defaultState['currentQuestionPage'] = QuestionPage();
    defaultState['currentSong'];
    defaultState['genrePath'] = '';
    defaultState['hasBuzzered'] = false;
    defaultState['hasConfirmedGuess'] = false;
    defaultState['oldQuestionPage'] = null;
    defaultState['timer'] = null;
    defaultState['canBuzzer'] = false;
    defaultState['possibleSongs'] = [];
    state = defaultState;
  }

  void setPlaylistUrl({String playlistUrl = ''}) {
    state = {...state, 'playlistUrl': playlistUrl};
  }

  void startRound() {
    state = {...state, 'oldQuestionPage' : state['currentQuestionPage'],};
    state = {...state, 'currentQuestionPage' : QuestionPage(), 'round': state['round'] + 1, 'hasBuzzered': false, 'hasConfirmedGuess': false, 'timer': TimerPopup(key: UniqueKey(), round: state['round'] + 1,), 'canBuzzer': false};
    print('nextRound');
  }

  void changeState({required String parameterName, required dynamic newValue}) {
    state = {...state, parameterName: newValue};
  }

  void muteStateInt({required String parameterName, required int mute}) {
    state = {...state, parameterName: mute + state[parameterName]};
  }

  void scanPossibleSongs() {
    Directory genreDir = Directory(state['genrePath']);
    List possibleFiles = genreDir.listSync();
    possibleFiles = possibleFiles.whereType<File>().toList();
    List audioFiles = [];
    for (File possibleFile in possibleFiles) {
      if (context.extension(possibleFile.path) == '.wav') {
        audioFiles.add(possibleFile);
      }
    }
    print(audioFiles);
    changeState(parameterName: 'possibleSongs', newValue: audioFiles);
  }

  void getNewAudio() {
    AudioPlayer player = AudioPlayer(playerId: UniqueKey().toString());
    File selectedSong = state['possibleSongs'][rng.nextInt(state['possibleSongs'].length)];
    player.play(DeviceFileSource(selectedSong.path), position: Duration(seconds: 30));
    state = {...state, 'audioPlayer': player};
  }
}

final MatchStateProvider = NotifierProvider<MatchState, Map<String, dynamic>>(() {
  return MatchState();
});

class TimerPopup extends ConsumerStatefulWidget {
  const TimerPopup({super.key, required this.round});
  final int round;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return TimerPopupState();
  }
}

class TimerPopupState extends ConsumerState<TimerPopup> {
  int count = 3;
  late Timer _timer;

  void startTimer() {
    _timer = Timer(
      Duration(seconds: 1),
      () {
        setState(() {
          count -= 1;
        });

        if (count > 0) {
          startTimer();
          print('timer');
        } else {
          ref.read(MatchStateProvider.notifier).changeState(parameterName: 'canBuzzer', newValue: true);
          ref.read(MatchStateProvider.notifier).getNewAudio();
        }
      }
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    print(count);
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return count > 0 ?
    ColoredBox(
      color: Color.fromARGB(count > 0 ? 166 : 0, 0, 0, 0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              count.toString(),
              style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Color.fromARGB(count > 0 ? 255 : 0, 255, 255, 255)),
            ),
            Text(
              'Round ${widget.round.toString()}',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Color.fromARGB(count > 0 ? 255 : 0, 255, 255, 255)),
            ),
          ],
        ),
      ),
    )
    :
    SizedBox(
      width: 0,
      height: 0,
    );
  }
}