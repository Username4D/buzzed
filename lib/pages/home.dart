import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

    @override
    State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
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

class MenuColumn extends StatelessWidget {
  const MenuColumn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
              print("Start")
            },
            child: Text("Start"),
          ),
        ),
        Expanded(
          flex: 1,
          child: TextButton(
            onPressed: () => {
              print("Settings")
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
    return Expanded(
      flex: 3,
      child: SizedBox(
        height: 200,
        child: ColoredBox(
          color: Colors.blueGrey,
          child: Center(
            child: Text(
              "Buzzer",
              textScaler: TextScaler.linear(2),
          ),
        ),
        ),
      ),
    );
  }
}