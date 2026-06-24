import 'package:flutter/material.dart';

class CustomErrorWidget extends StatefulWidget {
  const CustomErrorWidget({
    super.key, required this.error, required this.onProceed
  });
  final CustomError error;
  final Function onProceed;
  @override
  State createState() {
    return CustomErrorWidgetState();
  }
}

class CustomErrorWidgetState extends State<CustomErrorWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: ColoredBox(
        color: const Color.fromARGB(100, 0, 0, 0),
        child: Center(
          child: SizedBox(
            width: 300,
            height: 150,
            child: ColoredBox(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ColoredBox(
                      color: Colors.blue,
                      child: Padding(
                        padding: EdgeInsetsGeometry.all(10),
                        child: Text(
                          widget.error.errorName,
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.error.errorDescription,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      style: TextButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                      child: Text(widget.error.proceedActionName),
                      onPressed: () {
                        widget.onProceed();
                      },
                    ),
                  )
                ],
              ),
            ),
          )
        ),
      ),
    );
  }
}

class CustomError {
  CustomError({required this.errorName, required this.errorDescription, required this.proceedActionName});
  final String errorName;
  final String errorDescription;
  final String proceedActionName;
}