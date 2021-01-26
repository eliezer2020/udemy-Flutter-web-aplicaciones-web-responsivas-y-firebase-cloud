import 'package:flutter/material.dart';

class Unknowpage extends StatelessWidget {
  final String routname;

  const Unknowpage({Key key, this.routname}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final parsedName = routname.substring(1);
    return Scaffold(
      body: Center(
        child: Text(
          "404 $parsedName not found",
          textScaleFactor: 8,
        ),
      ),
    );
  }
}
