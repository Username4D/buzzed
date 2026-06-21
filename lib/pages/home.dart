import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_quiz/main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

    @override
    State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
          backgroundColor: Colors.white,
                body: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: SizedBox(
                      width: 600,
                      height: 400,
                      child: MenuColumn(),
                    ),
                  ),
            )
            
        );
    }

}

class MenuColumn extends ConsumerWidget {
  const MenuColumn({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Logo(),
        Spacer(
          flex: 1
        ),
        Expanded(
          flex: 1,
          child: TextButton(
            onPressed: () => {
              ref.read(appStateProvider.notifier).changePage('genreSelection')
            },
            child: Text("Start"),
          ),
        ),
        Expanded(
          flex: 1,
          child: TextButton(
            onPressed: () => {
              ref.read(appStateProvider.notifier).changePage('settingsPage')
            },
            child: Text("Settings"),
          ),
        )
      ]
    );
  }
}

class Logo extends StatelessWidget {
  const Logo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset('assets/logo.svg');
  }
}