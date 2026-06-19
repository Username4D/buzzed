import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_quiz/pages/question_page.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class MatchState extends Notifier<Map<String, dynamic>> {
  @override
  Map<String, dynamic> build() {
    Map<String, dynamic> defaultState = <String, dynamic>{};
    defaultState['round'] = 1;
    defaultState['scoreRed'] = 0;
    defaultState['scoreBlue'] = 0;
    defaultState['currentQuestionPage'] = QuestionPage();
    defaultState['youtubeUrl'] = '';
    defaultState['playlistUrl'] = '';
    defaultState['hasBuzzered'] = false;
    defaultState['hasConfirmedGuess'] = false;
    defaultState['oldQuestionPage'] = null;
    defaultState['timer'] = TimerPopup(round: 1,);
    defaultState['canBuzzer'] = false;
    return defaultState;
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