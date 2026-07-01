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
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Logo(),
        SizedBox(
          height: 30,
        ),
        TextButton(
          onPressed: () => {
            ref.read(appStateProvider.notifier).changePage('genreSelection')
          },
          style: ButtonStyle(
            textStyle: WidgetStatePropertyAll(Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white)),
            backgroundColor: WidgetStatePropertyAll(Colors.black),
            foregroundColor: WidgetStatePropertyAll(Colors.white),
            overlayColor: WidgetStatePropertyAll(const Color.fromARGB(16, 255, 255, 255)),
          ),
          child: Text("Start"),
        ),
        SizedBox(
          height: 10,
        ),
        TextButton(
          onPressed: () => {
            ref.read(appStateProvider.notifier).changePage('settingsPage')
          },
          style: ButtonStyle(
            textStyle: WidgetStatePropertyAll(Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white)),
            backgroundColor: WidgetStatePropertyAll(Colors.black),
            foregroundColor: WidgetStatePropertyAll(Colors.white),
            overlayColor: WidgetStatePropertyAll(const Color.fromARGB(16, 255, 255, 255)),
          ),
          child: Text("Settings"),
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