import 'package:flutter/material.dart';

class studentProgress extends StatefulWidget {
  const studentProgress({Key? key}) : super(key: key);

  @override
  State<studentProgress> createState() => _studentProgressState();
}

class _studentProgressState extends State<studentProgress> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Text("My Progress",style: TextStyle(fontFamily: "Poppins",fontSize: 20),)
            ],
          ),
        ),
    );
  }
}
