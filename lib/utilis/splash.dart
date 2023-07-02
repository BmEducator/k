import 'dart:async';


import 'package:bmeducators/Screens/admin/admin_Screen.dart';
import 'package:bmeducators/Screens/homeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/studentModel.dart';
import '../mainScreen.dart';
import '../students/accessDeniedScreen.dart';
import '../students/main_menuScreen.dart';


class SplashScreen extends StatefulWidget {
  String type;

  SplashScreen({Key? key,required this.type}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late Timer timers;
  String type = "";


  late SharedPreferences pref;
  String isAdmin = "false";

  Future init() async{
    pref = await SharedPreferences.getInstance();
    if(pref.containsKey("name")) {
      String? n = pref.getString("name");
      if(n == "admin"){
        isAdmin = "true";

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => adminScreen()));
      }
      else{
        getUserDetail();
      }


    }
    else{
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainScreen()));

    }
  }
  @override
  void initState(){

    init();
    super.initState();
    //

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xff00aeff),
        backgroundColor: Color(0xff111336),

        body: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors:[
                      Color(0xff0033cc),
                      Color(0xff111336),

                    ] ,

                    begin: Alignment.topRight,
                    end: Alignment.bottomCenter
                )
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Image.asset("assets/splashlogofull.png",),
                  )),
                  AnimationLimiter(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: AnimationConfiguration.toStaggeredList(
                        duration: const Duration(milliseconds:1000),
                        childAnimationBuilder: (widget) => SlideAnimation(
                          horizontalOffset: 200.0,
                          verticalOffset: -52,
                          child: SlideAnimation(
                            child: widget,
                          ),
                        ),
                        children:  [
                          Container(

                              width: MediaQuery.of(context).size.width*0.45,
                              child: FittedBox(child: Text("empowering people",style: TextStyle(fontFamily: "PoppinRegular",fontSize: 18,color: Colors.white),)))

                        ],
                      ),
                    ),
                  )
                  // SizedBox(width: 150, height: 150, child: Orbit()),
                  ,SizedBox(height: 150,)
                ],
              ),
            ),
          ),
        ));
  }


  Future<void> getUserDetail() async {
    print("getting");

    var accessDate = "null";
    String type = "";

    String email = pref.getString("email")!;

    if(widget.type == "home"){
          var today = DateTime.now();
          int  todaytimestamp  = today.millisecondsSinceEpoch;
          var accessTimestamp;
          var tdy = DateFormat('dd-MM-yyyy').format(today);

      DatabaseReference ref = FirebaseDatabase.instance.ref().child("students").child(email.substring(0,email.indexOf("@"))).
      child("accessLimit").child("limit");

      DatabaseEvent event = await ref.once();

      if(event.snapshot.exists){
        print(event.snapshot.value.toString());
        print(event.snapshot.children.first.value.toString());
        String accessTimestamp = event.snapshot.children.first.value.toString();
        if(accessTimestamp != ""){
          var d = DateTime.fromMillisecondsSinceEpoch(int.parse(accessTimestamp));
          accessDate = DateFormat('dd-MM-yyyy').format(d);
        }
        print(accessTimestamp);
        print("----");
        if(accessTimestamp  == null || accessTimestamp== ""){
          type = "mainMenu";
        }
        else if(accessDate == tdy){
          type = "blocked";
        }
        else if(todaytimestamp > (int.parse(accessTimestamp))){
          type = "blocked";

        }
        else{
          type = "mainMenu";
        }
      }
      else{
        print("none");
        type = "mainMenu";
      }//   try{
    //     await FirebaseDatabase.instance.ref().child("students").child(email.substring(0,email.indexOf("@"))).
    //   child("accessLimit").child("limit").get().then((DataSnapshot snapshot) {
    //
    //     String temp = "";
    //     snapshot.children.forEach((element) {
    //
    //       temp = element.children.first.value.toString();
    //
    //     });
    //     // var d = DateTime.fromMillisecondsSinceEpoch(int.parse(temp));
    //     // accessDate = DateFormat('dd-MM-yyyy').format(d);
    //     print(temp);
    //
    //   });
    //   }on FirebaseException catch  (e) {
    // print('Failed with error code: ${e.code}');
    // print(e.message);
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => accessDeniedScreen()));
    //   }
    //
    }

    // if(widget.type == "home") {
    //   if(isAdmin == "false" || isAdmin == ""){
    //     var lastupdate = pref.getString("lastUpdateAccessTime");
    //     var access = "";
    //     var today = DateTime.now();
    //     print(access);
    //     var tdy = DateFormat('dd-MM-yyyy').format(today);
    //
    //     if(access == "blocked"){
    //       type = "blocked";
    //
    //     }
    //     else if(lastupdate != tdy ) {
    //       print("updated from firestore");
    //       String? email = pref.getString("email");
    //       String accessDate = "";
    //
    //       await FirebaseFirestore.instance.collection(
    //           "admin").doc(
    //           "data").collection("students").doc(
    //           "allStudents").collection("allStudents")
    //           .doc(email).get().then((value) {
    //         print(value["accessDate"]);
    //         accessDate = value["accessDate"];
    //
    //       });
    //
    //       if(accessDate!="") {
    //         var d = DateTime.fromMillisecondsSinceEpoch(
    //             int.parse(accessDate));
    //         var a = DateFormat('dd-MM-yyyy').format(d);
    //         pref.setString("lastUpdateAccessTime", tdy);
    //         access = a;
    //         pref.setString("accessDate", a);
    //       }
    //       else{
    //         type = "mainMenu";
    //
    //       }
    //     }
    //
    //     if(access == tdy ){
    //       print("blocked");
    //       pref.setString("accessDate", "blocked");
    //
    //     }
    //
    //     if(access != "blocked" && access != tdy){
    //       type = "mainMenu";
    //     }
    //
    //   else{
    //     type = "admin";
    //     }
    //   }
    //
    // }
    // else{
    //   Navigator.pushReplacement(
    //       context, MaterialPageRoute(builder: (context) => MainScreen()));
    // }
    //
    // print("tim");
    timers = Timer.periodic(const Duration(seconds: 2), (timer) async {
      print(type);

      if(type == "blocked"){
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => accessDeniedScreen()));
      }

      else if(type == "mainMenu") {
        Navigator.pushReplacement(
            context, MaterialPageRoute(
            builder: (context) => mainMenu(isfromLogin: false, checkUpdate: true,)));
      }
      else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainScreen()));

      }

    });

  }
}





