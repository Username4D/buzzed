import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:music_quiz/data/music_provider.dart';
import 'package:music_quiz/main.dart';
import 'package:music_quiz/ui_elements/error_widget.dart';
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
    defaultState['errorWidget'] = null;
    defaultState['isPaused'] = false;
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
    defaultState['errorWidget'] = null;
    defaultState['isPaused'] = false;
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
    if (state['possibleSongs'].length <= 0) {
      state = {...state, 'isPaused': true};
      showError(
        CustomError(
          errorName: 'Too few playable audiofiles', 
          errorDescription: 'This could be due to files getting moved or being corrupted/not able to be played, or just not enough files being in the directory.', 
          proceedActionName: 'Go home'
        ),
        () {
          ref.read(musicProvider.notifier).up();
          ref.read(appStateProvider.notifier).changePage('mainMenu');
          state['audioPlayer'].stop();
        }
      );
    }
    AudioPlayer player = AudioPlayer(playerId: UniqueKey().toString());
    File selectedSong = state['possibleSongs'][rng.nextInt(state['possibleSongs'].length)];
    player.play(DeviceFileSource(selectedSong.path), position: Duration(seconds: 30));
    List subtracted = state['possibleSongs'];
    subtracted.remove(selectedSong);
    state = {...state, 'audioPlayer': player, 'currentSong': selectedSong, 'possibleSongs': subtracted};
  }

  void showError(CustomError error, Function onProceed) {
    state = {...state, 'errorWidget': CustomErrorWidget(
      error: error,
      onProceed: () {
        state = {...state, 'errorWidget': null};
        onProceed(); 
      },
    )};
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
  late AudioPlayer countdownSfx;
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
    super.initState();
    startTimer();
    countdownSfx = AudioPlayer();
    countdownSfx.play(AssetSource('countdown.wav'));
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