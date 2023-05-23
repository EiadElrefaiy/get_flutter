import 'package:flutter/material.dart';

class FullScreen extends StatefulWidget {
  final String image;
  FullScreen({Key? key, required this.image}) : super(key: key);

  @override
  State<FullScreen> createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottomOpacity: 0.0,
        elevation: 0.0,
        backgroundColor: Colors.black,
        ),
      body:
       Container(
        color: Colors.black,
        width: double.infinity,
        height: MediaQuery.of(context).size.height - AppBar().preferredSize.height,
        child: 
            InteractiveViewer(
            panEnabled: false, // Set it to false to prevent panning. 
            //boundaryMargin: EdgeInsets.all(80),
            minScale: 1,
            maxScale: 4, 
              child: Image.network(
                  widget.image,
                fit: BoxFit.contain,
                ),
            ),
      ),
    );
  }
}