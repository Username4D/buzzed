import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FadeablePlayer {
  AudioPlayer audioPlayer = AudioPlayer();
  double volume = 1.0;
  late final AnimationController animController;
  late Animation<double> animation;
  bool hasStarted = false;

  void initState() {
    animController = AnimationController(
      value: 1.0,
      duration: Durations.medium3,
      vsync: ExternalTickerProvider(),
    );
    animation = Tween<double>(begin: 0, end: 1).animate(animController)
      ..addListener(() {
        volume = animation.value;
        audioPlayer.setVolume(animation.value);
      });
    audioPlayer.setVolume(volume);
  }

  void up() {
    animController.forward(from: volume);
  }

  void down() {
    animController.reverse(from: volume);
  }

  void start() {
    if (!hasStarted) {
      hasStarted = true;
      audioPlayer.play(AssetSource('menu.wav'));
      audioPlayer.setVolume(volume);
    }
  }
}

class ExternalTickerProvider implements TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) {
    return Ticker(onTick);
  }
}

class MusicNotifier extends Notifier<FadeablePlayer> {
  @override
  FadeablePlayer build() {
    return FadeablePlayer();
  }

  void up() {
    state.up();
  }

  void down() {
    state.down();
  }

  void start() {
    state.initState();
    state.start();
  }
}

final NotifierProvider<MusicNotifier, FadeablePlayer> musicProvider = NotifierProvider<MusicNotifier, FadeablePlayer>(() {
  return MusicNotifier();
});