import 'package:bmeducators/Screens/admin/admin_Screen.dart';
import 'package:bmeducators/Screens/admin/questionBank.dart';
import 'package:bmeducators/Screens/admin/searchScreen.dart';
import 'package:bmeducators/Screens/admin/searchedQuestion.dart';
import 'package:bmeducators/Screens/admin/quiz_numbers_screen.dart';
import 'package:bmeducators/Screens/homeScreen.dart';
import 'package:bmeducators/students/main_menuScreen.dart';
import 'package:bmeducators/students/quiz_Mainmenu.dart';
import 'package:bmeducators/students/video_lectures_forStudents.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../Models/question.dart';

class multipleCourses extends StatefulWidget {
  bool isAdmin;
  String type;
  multipleCourses({Key? key,required this.isAdmin,required this.type}) : super(key: key);

  @override
  State<multipleCourses> createState() => _multipleCoursesState();
}

class _multipleCoursesState extends State<multipleCourses> {

  List<String> familiesList = [];
  late SharedPreferences pref;
  bool isLoading = false;

  Future init() async{
    pref = await SharedPreferences.getInstance();

    if(widget.isAdmin){
      familiesList = [
        'Permiso AM',
        'Permiso A1-A2',
        'Permiso B',
        'Permiso C',
        'Permiso D',
        'Permiso C+E',
        'CAP',
        'Curso de Taxi Barcelona',
      ];
    }else {
      familiesList = pref.getStringList("myCourses")!;
    }setState(() {

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    init();
    super.initState();
  }

  Future<bool> willpop() async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => mainMenu(isfromLogin: false , checkUpdate: false)));
    return  true;

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: willpop,
        child:Scaffold(
            body: SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15,15, 10, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[

                              InkWell(
                                  onTap:(){
                                    Navigator.pushReplacement(
                                        context, MaterialPageRoute(builder: (context) => mainMenu(isfromLogin: false, checkUpdate: false)));
                                  },
                                  child: Icon(Icons.arrow_back_ios)),


                            ],
                          ),
                        ),

                        SizedBox(
                          height: 20,
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Select Course",
                                style: TextStyle(fontFamily: "Poppins", fontSize: 28,letterSpacing: 1),
                              ),

                            ],
                          ),
                        ),
                        SizedBox(height: 20,),
                        isLoading?
                        Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          margin: EdgeInsets.only(bottom: 100),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                        width: 70,
                                        height: 70,
                                        child: CircularProgressIndicator()),
                                    Container(
                                        width: 70,
                                        height: 70,
                                        child: Center(
                                          child: Transform(
                                            alignment: Alignment.center,
                                            transform: Matrix4.rotationY(math.pi),
                                            child: Container(
                                              width: 40,
                                              height: 40,
                                              child: CircularProgressIndicator(),
                                            ),
                                          ),
                                        )),
                                  ],
                                ),
                                SizedBox(height: 20,),
                              ],
                            ),
                          ),
                        ) :Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          width: MediaQuery.of(context).size.width,
                          child: GridView.count(
                            shrinkWrap: true,
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                            physics: NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            childAspectRatio: (1 / 0.9),
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 5,
                            children: List.generate(
                              familiesList.length,
                                  (int i) {
                                return AnimationConfiguration.staggeredGrid(
                                    position: i,
                                    duration: const Duration(milliseconds: 375),
                                    columnCount: 2,
                                    child: ScaleAnimation(
                                        child: FadeInAnimation(
                                            child: Padding(
                                                padding: const EdgeInsets.all(5.0),
                                                child:serviceContainer(familiesList[i][0], familiesList[i], 1)
                                            ))
                                    ));
                              },
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ))

    );
  }

  serviceContainer(String char, String name, int i) {
    return InkWell(
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        splashColor: Colors.grey,
        onTap: () {
        if(widget.type == "video"){
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Video_Lectures_students(family: name)));

        }
          else{
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => quizMainmenuScreen(myCourse: name)));
        }},
        child: Container(
          width: MediaQuery.of(context).size.width * 0.32,
          height: MediaQuery.of(context).size.height * 0.15,
          decoration: BoxDecoration(
              color:Colors.blue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(color: Colors.blueAccent.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: Offset(0, 12)
                ),
              ]),
          child: Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            color: Colors.white,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    width: MediaQuery.of(context).size.width * 0.38,
                    height: 28,
                    color:Colors.blue.withOpacity(0.8),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        name,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Poppins",
                            fontSize: 14,
                            letterSpacing: 1),
                      ),
                    )),
                i < familiesList.length
                    ? Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Text(
                      char,
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 30,
                          color: Colors.black.withOpacity(0.2)),
                    ),
                  ),
                )
                    : InkWell(
                    onTap: () {

                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Center(
                          child: Icon(
                            Icons.add,
                            color: Colors.lightBlue,
                            size: 50,
                          )),
                    ))
              ],
            ),
          ),
        ));
  }


}
