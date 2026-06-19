import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_quiz/data/match_settings_provider.dart';
import 'package:music_quiz/data/match_state_provider.dart';

class QuestionPage extends ConsumerStatefulWidget {
  const QuestionPage({super.key});
  
  @override
  ConsumerState<QuestionPage> createState() {
    return QuestionPageState();
  }
}

class QuestionPageState extends ConsumerState<QuestionPage> {
  String focusedSide = 'none';
  final FocusNode _focusNode = FocusNode();
  

  @override
  void initState() {
    _focusNode.requestFocus();
    //ref.read(MatchStateProvider.notifier).changeState(parameterName: 'scoreRed', newValue: 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: KeyboardListener(
          focusNode: _focusNode,
          onKeyEvent: (value) {
            if (!ref.read(MatchStateProvider)['hasBuzzered']) {
              if (value.character == 'r') {
                setState(() {
                  focusedSide = 'red';
                });
              }
              if (value.character == 'b') {
                setState(() {
                  focusedSide = 'blue';
                });
              }
              ref.read(MatchStateProvider.notifier).changeState(parameterName: 'hasBuzzered', newValue: true);
            }
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                children: [
                  SidePage(
                    side: 'red', 
                    isFocused: focusedSide == 'none' ? 'none' : focusedSide == 'red' ? 'this' : 'other', 
                    constraints: constraints,
                    onAnimationEnd: () {
                      if (ref.read(MatchStateProvider)['hasConfirmedGuess']) {
                        print('AnimationFinished');
                        ref.read(MatchStateProvider.notifier).startRound();
                        setState(() {
                          focusedSide = 'none';
                        });
                      }
                    },
                  ),
                  Expanded(
                    child: AnimatedSize(
                      duration: Durations.short2,
                      //alignment: focusedSide == 'blue' ? Alignment.centerRight : Alignment.centerLeft,
                      child: ColoredBox(
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '${ref.watch(MatchStateProvider)['scoreRed']}   :   ${ref.watch(MatchStateProvider)['scoreBlue']}',
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                            !ref.watch(MatchStateProvider)['hasBuzzered'] ?
                            TextButton(
                              style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(const Color.fromARGB(255, 255, 255, 255)), foregroundColor: WidgetStatePropertyAll(const Color.fromARGB(255, 112, 112, 112)), overlayColor: WidgetStatePropertyAll(const Color.fromARGB(10, 112, 112, 112))),
                              onPressed: () {
                                print('skip');
                              },
                              child: Text(
                                'Skip'
                              ),
                            )
                            :
                            SizedBox()
                          ],
                        ),
                      ),
                    ),
                  ),
                  SidePage(
                    side: 'blue',
                    isFocused: focusedSide == 'none' ? 'none' : focusedSide == 'blue' ? 'this' : 'other',
                    constraints: constraints,
                    onAnimationEnd: () {
                      if (ref.read(MatchStateProvider)['hasConfirmedGuess']) {
                        print('AnimationFinished');
                        ref.read(MatchStateProvider.notifier).startRound();
                        setState(() {
                          focusedSide = 'none';
                        });
                      }
                    },  
                  ),
                ]
              );
            }
          ),
        ),
      ),
    );
  }
}

class SidePage extends ConsumerStatefulWidget {
  final String side;
  final String isFocused;
  final BoxConstraints constraints; // none, this, other
  const SidePage({super.key, required this.side, required this.isFocused, required this.constraints, required this.onAnimationEnd});
  final Function onAnimationEnd;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return SidePageState();
  }
}

class SidePageState extends ConsumerState<SidePage> {
  
  @override
  Widget build(BuildContext context,) {
    return AnimatedContainer(
      duration: Durations.short2,
      width: widget.constraints.maxWidth * (ref.watch(MatchStateProvider)['hasConfirmedGuess'] ? 00.2 : (widget.isFocused == 'this' ? 0.6 : 0.2)),
      height: double.infinity,
      onEnd: () {
        widget.onAnimationEnd();
      },
      child: Container(
        color: widget.side == 'red' ? Colors.red : Colors.blue,
        child: Center(
          child: SizedBox(
            width: 400,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.isFocused == 'this' ? 
              [
                Text(
                  widget.side == 'blue' ? 'Team blue' : 'Team Red',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white),
                ),
                SizedBox(height: 20,),
                PostGuessScreen(side: widget.side)
              ]
              :
              [
                Text(
                  widget.side == 'blue' ? 'Team blue' : 'Team Red',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.white),
                ),
              ]
              ,
            ),
          ),
        ),
      ),
    );
  }
}

class PostGuessScreen extends ConsumerStatefulWidget {
  const PostGuessScreen({super.key, required this.side});
  final String side;
  @override
  ConsumerState<PostGuessScreen> createState() => _PostGuessScreenState();
}

class _PostGuessScreenState extends ConsumerState<PostGuessScreen> {
  bool solutionRevealed = false;

  @override
  Widget build(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        !solutionRevealed ? 
        TextButton(
          
          style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.white), foregroundColor: WidgetStatePropertyAll(widget.side == 'red' ? Colors.red : Colors.blue), overlayColor: WidgetStatePropertyAll(const Color.fromARGB(19, 112, 112, 112))),
          onPressed: () {
            setState(() {
              solutionRevealed = true;
            });
          },
          child: Text(
            'Reveal Solution?'
          ),
        )
        :
        Text(
          'Solution',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
        ),
        SizedBox(height: 30,),
        Text(
          'Guessed correctly?',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
        ),
        SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              hoverColor: Color.fromARGB(30, 255, 255, 255),
              splashColor: Color.fromARGB(50, 255, 255, 255),
              highlightColor: Color.fromARGB(50, 255, 255, 255),
              onPressed: () {
                if (!ref.read(MatchStateProvider)['hasConfirmedGuess']) {
                  ref.read(MatchStateProvider.notifier).muteStateInt(parameterName: widget.side == 'red' ? 'scoreRed' : 'scoreBlue', mute: 1);
                }
                ref.read(MatchStateProvider.notifier).changeState(parameterName: 'hasConfirmedGuess', newValue: true);
              },
              icon: Icon(Icons.check, color: Colors.white, size: 40,),
            ),
            SizedBox(width: 20,),
            IconButton(
              hoverColor: Color.fromARGB(30, 255, 255, 255),
              splashColor: Color.fromARGB(50, 255, 255, 255),
              highlightColor: Color.fromARGB(50, 255, 255, 255),
              onPressed: () {
                if (!ref.read(MatchStateProvider)['hasConfirmedGuess']) {
                  ref.read(MatchStateProvider.notifier).muteStateInt(parameterName: widget.side == 'red' ? 'scoreRed' : 'scoreBlue', mute: -1);
                  
                }
                ref.read(MatchStateProvider.notifier).changeState(parameterName: 'hasConfirmedGuess', newValue: true);
              },
              icon: Icon(Icons.close, color: Colors.white, size: 40,),
            ),
          ]
        )
      ],
    );
  }
}

class QuestionPageHost extends ConsumerWidget {

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        ref.watch(MatchStateProvider)['currentQuestionPage'],
        (ref.watch(MatchStateProvider)['round'] == ref.watch(MatchSettingsNotifierProvider)['roundsAmount'] + 1 ? WinScreen() : ref.watch(MatchStateProvider)['timer'])
      ],
    );
  }
}

class WinScreen extends ConsumerStatefulWidget {
  const WinScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return WinScreenState();
  }
}



class WinScreenState extends ConsumerState {
  late Timer _timer;
  bool delayFinished = false;
  String winnerSide = 'Red';
  late Map<String, dynamic> state;
  @override
  void initState() {
    winnerSide = ref.read(MatchStateProvider)['scoreRed'] > ref.read(MatchStateProvider)['scoreBlue'] ? 'Red' : 'Blue';
    state = ref.read(MatchStateProvider);
    _timer = Timer(
      Durations.extralong4,
      () {
        setState(() {
          delayFinished = true;
        });
      }
    );
  }

  @override   
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Align(
          alignment: AlignmentGeometry.bottomCenter,
          child: AnimatedContainer(
            duration: Durations.extralong4,
            curve: Curves.easeIn,
            width: constraints.maxWidth,
            height: delayFinished ? constraints.maxHeight : 0,
            child: ColoredBox(
              color: winnerSide == 'Red' ? Colors.redAccent : Colors.blueAccent,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Winner: $winnerSide',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white, fontSize: 100),
                    ),
                    Text(
                      '${state['scoreRed']} : ${state['scoreBlue']}',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.white,)
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}