import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class MatchSettingsNotifier extends Notifier<Map<String, dynamic>> {
  @override
  Map<String, dynamic> build() {
    var defaultMap = {
      'roundsAmount': 3,
      'redKeybind': 'r',
      'blueKeybind': 'b'
    };
    return defaultMap;
  }

  void changeSetting({String settingName = '', dynamic newValue}) {
    state[settingName] = newValue;
  }

  void resetSettings() {
    state = build();
  }
}

final MatchSettingsNotifierProvider = NotifierProvider<MatchSettingsNotifier, Map<String, dynamic>>((){
  return MatchSettingsNotifier();
});