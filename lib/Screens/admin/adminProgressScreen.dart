import 'package:flutter/material.dart';

class adminProgressScreen extends StatefulWidget {
  const adminProgressScreen({Key? key}) : super(key: key);

  @override
  State<adminProgressScreen> createState() => _adminProgressScreenState();
}

class _adminProgressScreenState extends State<adminProgressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text("Progress"),

              ],
            ),
          ),
        ),
    );
  }
}
