import 'package:flutter/material.dart';

class ProgressView extends StatefulWidget {
  ProgressView({Key? key}) : super(key: key);

  @override
  State<ProgressView> createState() => _ProgressViewState();
}

class _ProgressViewState extends State<ProgressView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(
          color: Color.fromARGB(255,255,150,102) ,
        ),
        ),
    );
  }
}