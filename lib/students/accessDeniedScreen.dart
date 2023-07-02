import 'package:bmeducators/Models/studentModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class accessDeniedScreen extends StatefulWidget {
  const accessDeniedScreen({Key? key}) : super(key: key);

  @override
  State<accessDeniedScreen> createState() => _accessDeniedScreenState();
}

class _accessDeniedScreenState extends State<accessDeniedScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                SizedBox(height: 40,),
                Image.asset("assets/noaccess.png"),
                SizedBox(height: 40,),
                Text("Access Denied", style: TextStyle(fontFamily: "Poppins",
                    fontSize: 25,
                    color: Colors.lightBlueAccent),),
                SizedBox(height: 10,),

                Container(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      "You have no longer access to use BMEducators' services.. Kindly contact Administration to continue....",
                      textAlign: TextAlign.center
                      ,
                      style: TextStyle(
                          fontFamily: "PoppinRegular", fontSize: 20),)),
              ],
            ),
          )),
    );
  }

}