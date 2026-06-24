import 'dart:io';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_quiz/data/genre_provider.dart';
import 'package:music_quiz/data/match_settings_provider.dart';
import 'package:music_quiz/main.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({
    super.key
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [Padding(
          padding: const EdgeInsets.all(60.0),
          child: Center(
            child: Column( 
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Text(
                      'Settings',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ),
                ),
                CustomSeperator(),
                SectionHeader(sectionTitle: 'Genres:',),
                // CustomSeperator(),
                Padding(
                  padding: const EdgeInsetsGeometry.only(left: 20, right: 20),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 200, minHeight: 0,),
                  
                    child: SingleChildScrollView(
                      primary: true,
                      scrollDirection: Axis.vertical,
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: ref.watch(genreNotifierProvider).map(((e) => GenreTile(genre: e,))).toList(),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                    child: TextButton(
                      style: ButtonStyle(
                        textStyle: WidgetStatePropertyAll(Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white)),
                        backgroundColor: WidgetStatePropertyAll(Colors.black),
                        foregroundColor: WidgetStatePropertyAll(Colors.white),
                        overlayColor: WidgetStatePropertyAll(const Color.fromARGB(16, 255, 0255, 0255)),
                      ),
                      onPressed: () {
                        ref.read(genreNotifierProvider.notifier).addGenre('', '');
                        print('NewGenre');
                      },
                      child: Text('Add Genre'),
                    ),
                  ),
                ),
                CustomSeperator(),
                SectionHeader(sectionTitle: 'Match Settings:',),
                SliderSetting(settingName: 'roundsAmount', displaySettingName: 'Amount of Rounds: ',),
                KeybindSetting(settingName: 'blueKeybind', displaySettingName: 'Blue buzzer keybind:',),
                KeybindSetting(settingName: 'redKeybind', displaySettingName: 'Red buzzer keybind:',),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 60,
            height: 60,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black,),
              onPressed: () {
                ref.read(appStateProvider.notifier).changePage('mainMenu');
              },
            ),
          ),
        )
        ]
      ),
    );
  } 
}

class SectionHeader extends StatelessWidget {
  String sectionTitle = '';

  SectionHeader({super.key, this.sectionTitle = ''});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(16.0),
      child: Center(
        child: Text(
          sectionTitle,
          style: Theme.of(context).textTheme.displaySmall,
        ),
      ),
    );
  }
}

class GenreTile extends ConsumerWidget {
  Genre genre;
  GenreTile({super.key, required this.genre});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Container(
        child: ColoredBox(
          color: const Color.fromARGB(255, 255, 255, 255),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
              SizedBox(
                height: 50,
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          cursorColor: Colors.black,
                          onChanged: (value) {
                            ref.read(genreNotifierProvider.notifier).changeGenreName(genre, value);
                          },
                          decoration: InputDecoration(
                            hintText: 'Genre Name',
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 2
                              )
                            )
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          genre.folderPath,
                        ),
                      ),
                    ),
                    SizedBox(
                      child: IconButton(
                        style: ButtonStyle(
                          textStyle: WidgetStatePropertyAll(Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white)),
                          backgroundColor: WidgetStatePropertyAll(Colors.black),
                          foregroundColor: WidgetStatePropertyAll(Colors.white),
                          overlayColor: WidgetStatePropertyAll(const Color.fromARGB(16, 255, 0255, 0255)),
                        ),
                        onPressed: () async {
                          Future<String?> result = FilesystemPicker.open(context: context, rootDirectory: Directory('C:/'), fsType: FilesystemType.folder);
                          ref.read(genreNotifierProvider.notifier).changeGenrePath(genre, await result ?? '');
                        },
                        icon: Icon(Icons.folder),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      child: IconButton(
                        style: ButtonStyle(
                          textStyle: WidgetStatePropertyAll(Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white)),
                          backgroundColor: WidgetStatePropertyAll(Colors.black),
                          foregroundColor: WidgetStatePropertyAll(Colors.white),
                          overlayColor: WidgetStatePropertyAll(const Color.fromARGB(16, 255, 0255, 0255)),
                        ),
                        onPressed: () {
                          ref.read(genreNotifierProvider.notifier).removeGenre(genre);
                        },
                        icon: Icon(Icons.close),
                      ),
                    )
                  ],
                ),
              )
            ),
          ),
      ),
    );
  }
}

class CustomSeperator extends StatelessWidget {
  const CustomSeperator({ 
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 3,
        child: ColoredBox(color: const Color.fromARGB(26, 71, 71, 71)),
      ),
    );
  }
}

class SliderSetting extends ConsumerStatefulWidget{
  String settingName = '';
  String displaySettingName = '';

  SliderSetting({
    super.key, this.settingName = '', this.displaySettingName = ''
  });

  @override
  ConsumerState<SliderSetting> createState() => _SliderSettingState(settingName: settingName, displaySettingName: displaySettingName);
}

class _SliderSettingState extends ConsumerState<SliderSetting> {
  String settingName = '';
  String displaySettingName = '';
  int settingValue = 1;

  _SliderSettingState({this.settingName = '', this.displaySettingName = ''});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.only(left: 52, right: 52, top: 12, bottom: 12),
      child: Row(
        children: [
          Flexible(
            child: Center(
              child: Align(
                alignment: AlignmentGeometry.centerLeft,
                child: Text(
                  widget.displaySettingName,
                  style: Theme.of(context).textTheme.bodyLarge,
                )
              ),
            ),
          ),
          Flexible(
            child: Center(
              child: Slider(
                activeColor: Colors.black,
                inactiveColor: Colors.grey,
                thumbColor: const Color.fromARGB(255, 0, 0, 0),
                value: settingValue.toDouble(),
                min: 1,
                max: 15,
                divisions: 8,
                onChanged: (double value) {
                  setState(() {
                    settingValue = value.toInt();
                  });
                  ref.read(MatchSettingsNotifierProvider.notifier).changeSetting(settingName: settingName, newValue: value);
                },
              ),
            )
          ),
          SizedBox(
            width: 40,
            child: Center(
              child: Text(
                ref.watch(MatchSettingsNotifierProvider)[settingName].toInt().toString()
              ),
            ),
          )
        ]
      ),
    );
  }
}

class KeybindSetting extends ConsumerStatefulWidget{
  String settingName = '';
  String displaySettingName = '';

  KeybindSetting({
    super.key, this.settingName = '', this.displaySettingName = ''
  });

  @override
  ConsumerState<KeybindSetting> createState() => _KeybindSettingState(settingName: settingName, displaySettingName: displaySettingName);
}

class _KeybindSettingState extends ConsumerState<KeybindSetting> {
  String settingName = '';
  String displaySettingName = '';
  int settingValue = 1;

  _KeybindSettingState({this.settingName = '', this.displaySettingName = ''});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.only(left: 52, right: 52, top: 12, bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: Align(
                alignment: AlignmentGeometry.centerLeft,
                child: Text(
                  widget.displaySettingName,
                  style: Theme.of(context).textTheme.bodyLarge,
                )
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: KeybindButton(initialCharacter: ref.watch(MatchSettingsNotifierProvider)[settingName],),
          )
        ]
      ),
    );
  }
}

class KeybindButton extends ConsumerStatefulWidget {
  String settingName = '';
  String initialCharacter = '';

  KeybindButton({
    super.key, this.settingName = '', this.initialCharacter = ''
  });

  @override
  ConsumerState<KeybindButton> createState() => _KeybindButtonState(settingName: settingName, character: initialCharacter);
}

class _KeybindButtonState extends ConsumerState<KeybindButton> {
  bool isAwaitingInput = false;
  final FocusNode _focusNode = FocusNode();
  String character = '';
  String buttonStateText = '';
  String settingName = '';

  _KeybindButtonState({
    this.settingName = '', this.character = ''
  });

  @override
  void initState() {
    buttonStateText = character;
    print(character);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: (value) {
        if (isAwaitingInput) {
          if (value is KeyDownEvent) {
            print(value);
            setState(() {
              isAwaitingInput = false;
              if (value.character != null) {
                setState(() {
                  character = value.character.toString();
                  buttonStateText = character;
                });
                ref.read(MatchSettingsNotifierProvider.notifier).changeSetting(settingName: settingName, newValue: character);
              }
              else {
                buttonStateText = character;
              }
            });
          }
        }
      },
      child: TextButton(
        style: ButtonStyle(
          textStyle: WidgetStatePropertyAll(Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white)),
          backgroundColor: WidgetStatePropertyAll(Colors.black),
          foregroundColor: WidgetStatePropertyAll(Colors.white),
          overlayColor: WidgetStatePropertyAll(const Color.fromARGB(16, 255, 0255, 0255)),
        ),
        onPressed: () {
          setState(() {
            isAwaitingInput = true;
            buttonStateText = 'Press any key or escape to cancel';
          });
          _focusNode.requestFocus();
        },
        child: Text(
          buttonStateText,
        ),
      ),
    );
  }
}

