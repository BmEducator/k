import 'package:bmeducators/Screens/admin/add_tikto_screen.dart';
import 'package:bmeducators/Screens/admin/classes_schedule.dart';
import 'package:bmeducators/Screens/admin/myTiktoks.dart';
import 'package:bmeducators/Screens/admin/questionPank_categories.dart';
import 'package:bmeducators/Screens/admin/quizesAll_Scree.dart';
import 'package:bmeducators/Screens/admin/usersScreen.dart';
import 'package:bmeducators/Screens/admin/videoScreenAdmin.dart';
import 'package:bmeducators/Screens/homeScreen.dart';
import 'package:bmeducators/mainScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../utilis/navigation_drawer.dart';
import 'add_Question_screen.dart';



class adminScreen extends StatefulWidget {
  const adminScreen({Key? key}) : super(key: key);

  @override
  State<adminScreen> createState() => _adminScreenState();
}

class _adminScreenState extends State<adminScreen> {

  // ['lectures.jpeg',"Quizes"],

  List<List<String>> itemList = [
    ['users.jpeg','Users'],
    ['questions.jpeg',"Question Bank"],
    ['classes.png',"Classes"],
    ['lectures.jpeg',"Video Lectures"],
    ['tiktok.png',"TikTok"],
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) =>
                      MainScreen()));
          return true;
        },
      child: Scaffold(
          body: SingleChildScrollView(
            child: Stack(
              children:
              [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                  children: [


                    SizedBox(
                      height: 40
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width *0.8,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: const Text(
                          "Admin Panel",
                          style: TextStyle(fontFamily: "Poppins",fontSize: 24),
                        ),
                      ),
                    ),

                    Divider(thickness: 4,),

                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),

                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: GridView.count(
                        shrinkWrap: true,
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 20),
                        scrollDirection: Axis.vertical,
                        crossAxisCount: 2,
                        childAspectRatio: (1/ 0.9),
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 5,
                        children: List.generate(
                          itemList.length,
                              (int i) {
                            return AnimationConfiguration.staggeredGrid(
                                position: i,
                                duration: const Duration(
                                    milliseconds: 375),
                                columnCount: 2,
                                child: ScaleAnimation(
                                  child: FadeInAnimation(
                                      child:Padding(
                                        padding: const EdgeInsets.all(5.0),
                                      child: serviceContainer(itemList[i][0], itemList[i][1]),
                                      )

                                  ),
                                ));
                          },
                        ),
                      ),
                    )
                    ]),
                ),
                NavigationDrawer()

              ]
            ),
          )

      ),
    );
  }

  serviceContainer(String image,String name) {
    return
      InkWell(
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          splashColor: Colors.grey,
          onTap: () {
            if(name == "Users"){
              Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) =>
                          usersSreen()));
            }
            else if(name == "Question Bank"){
              Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) =>
                          questionPankCategories(type: 'quiz',)));
            }
            else if(name == "Classes"){
              Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) =>
                          classes_Schedule()));
            }

            else if(name == "TikTok"){
              Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) =>
                          myTiktoks()));
            }
            else if(name == "Video Lectures"){
              Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) =>
                          questionPankCategories(type: 'video',)));

            }
            else if(name == "Quizes"){
              Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) =>
                          Admin_quiz_MainmenuScreen()));
            }
          },
          child: Container(
            child: Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
                elevation: 10,
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      "assets/${image}",
                      width: MediaQuery.of(context).size.width * 0.35
                      ,height:MediaQuery.of(context).size.height*0.1,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      height: 25,
                      width: MediaQuery.of(context).size.width*0.5,
                      color: Colors.blue.withOpacity(0.7),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          name,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Poppins",fontSize: 14,
                              letterSpacing: 1),
                        ),
                      ),
                    )
                  ],
                )),
          ));

  }

}
