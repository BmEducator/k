// import 'package:educator/Screens/services_Screen/license_screen.dart';
// import 'package:educator/Screens/videos_Lecture_Scree.dart';
// import 'package:educator/Screens/widgets/tiktokVideo_Item.dart';
import 'dart:io';

import 'package:bmeducators/services_Screen/license_screen.dart';
import 'package:bmeducators/students/accessDeniedScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../students/login_Screen.dart';
import '../students/main_menuScreen.dart';
import '../utilis/videos_Lecture_Scree.dart';
import 'admin/admin_Screen.dart';
// import 'students/login_Screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'students/main_menuScreen.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({Key? key}) : super(key: key);

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {

  var li = [
    'https://vt.tiktok.com/ZSLde5Ue4/?t=1',
    'https://vt.tiktok.com/ZSLde5Ue4/?t=1'
  ];
  List<String> tiktokUrls =[];

  String name = "Login";

  late SharedPreferences pref;
  @override
  void initState() {
    getTiktoks();
    super.initState();
    init();
  }
  Future init() async {
    pref = await SharedPreferences.getInstance();
    if(pref.containsKey("name")){
    setState(() {
      name = pref.getString("name")!;
    });}
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: SafeArea(
          child: Column(
            children: [

              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            width: 70,
                            child: Text("")),

                        Image.asset("assets/textlogo.png",width: MediaQuery.of(context).size.width * 0.42,),
                        StreamBuilder(
                          stream: FirebaseAuth.instance.authStateChanges(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.active) {
                              // Checking if the snapshot has any data or not
                              if (snapshot.hasData) {
                                 return InkWell(
                                  onTap: (){
                                   if(name == "Login"){
                                     Navigator.pushReplacement(
                                         context, MaterialPageRoute(
                                         builder: (context) =>
                                             loginScreen()));
                                   }
                                   else {
                                     Navigator.pushReplacement(
                                         context, MaterialPageRoute(
                                         builder: (context) =>
                                             mainMenu(isfromLogin: false, checkUpdate: false,)));
                                   }
                                  },
                                  child: Center(
                                    child: Material(
                                        elevation: 4,
                                        color: Colors.green[300],
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20)),
                                        child: Container(
                                            width: MediaQuery.of(context).size.width * 0.2,
                                            height: MediaQuery.of(context).size.height* 0.035,
                                            padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                                            child:FittedBox(
                                              child: Text(
                                                name,
                                                style: const TextStyle(
                                                    fontFamily: "PoppinRegular",color: Colors.white),
                                              ),
                                            )
                                        )),
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Container(
                                    width: 80,
                                    child: Material(
                                        elevation: 4,
                                        color: Colors.green[300],
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20)),
                                        child:  Container(
                                            width: MediaQuery.of(context).size.width * 0.25,
                                            height: MediaQuery.of(context).size.height* 0.035,
                                            padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
                                            child:FittedBox(
                                              child: Text(
                                                "  Login ",
                                                style: const TextStyle(
                                                    fontFamily: "PoppinRegular",color: Colors.white),
                                              ),
                                            )
                                        )));
                              }
                            }
                            // means connection to future hasnt been made yet
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return  Center(
                                child: InkWell(
                                  onTap: (){

                                  },
                                  child: Container(
                                      width: 80,
                                      child: Material(
                                          elevation: 4,
                                          color: Colors.green[300],
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20)),
                                          child:  Container(
                                              width: MediaQuery.of(context).size.width * 0.25,
                                              height: MediaQuery.of(context).size.height* 0.035,
                                              padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
                                              child:FittedBox(
                                                child: Text(
                                                  " Login ",
                                                  style: const TextStyle(
                                                      fontFamily: "PoppinRegular",color: Colors.white),
                                                ),
                                              )
                                          ))),
                                ),
                              );
                            }

                            return InkWell(
                              onTap: (){
                                Navigator.pushReplacement(
                                    context, MaterialPageRoute(builder: (context) => loginScreen()));

                              },
                              child: Container(
                                  width: MediaQuery.of(context).size.width * 0.2,
                                  height: MediaQuery.of(context).size.height* 0.035,
                                  child: Material(
                                      elevation: 4,
                                      color: Colors.green[300],
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20)),
                                      child:  Container(
                                          width: MediaQuery.of(context).size.width * 0.25,
                                          height: MediaQuery.of(context).size.height* 0.035,
                                          padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
                                          child:FittedBox(
                                            child: Text(
                                              " Login ",
                                              style: const TextStyle(
                                                  fontFamily: "PoppinRegular",color: Colors.white),
                                            ),
                                          )
                                      ))),
                            );
                          },
                        ),
                      ])),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35,vertical: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width*0.45,
                            child: FittedBox(
                                child: Text("Our Services",style: TextStyle(fontFamily: "Poppins",fontSize: 23,letterSpacing:1),))),
                        SizedBox(height: 15,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            serviceContainer("license","License"),
                            serviceContainer("language","Language Course  "),

                          ],
                        ),
                        SizedBox(height: 14,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            serviceContainer("passport","Nationality"),

                          ],
                        ),
                        SizedBox(height: 20,)


                      ],
                    ),
                  ),
                  Divider(thickness: 4),


                  Container(
                    width: MediaQuery.of(context).size.width*0.3,
                    child: Padding(padding: EdgeInsets.symmetric(horizontal: 20),child:
                    FittedBox(child: Text("Trend",style: TextStyle(fontFamily: "Poppins",fontSize: 24),)),
                    ),
                  )
                  ,  SizedBox(
                    height: 10,
                  ),

                ],

              ),

              // SizedBox(
              //   height: 400,
              // child:   ListView.builder(
              //     scrollDirection: Axis.horizontal,
              //     itemCount: 60,
              //     itemBuilder:(BuildContext context,int i) => Card(
              //       child: Card(
              //         child:videoLectureScreen(url: 'https://www.tiktok.com/@Scout2015/video/6718335390845095173'),
              //       ),
              //     )),),

              Visibility(
                visible: tiktokUrls.length !=0,
                child: Container(
                  height: 300,
                  child: GridView.count(
                    shrinkWrap: true,
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 20),
                    scrollDirection: Axis.horizontal,
                    crossAxisCount: 1,
                    childAspectRatio: (1 / 0.7),
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 5,
                    children: List.generate(
                      tiktokUrls.length,
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
                                    child: Platform.isIOS?
                                    videoLectureScreen(url: tiktokUrls[i]):

                                    Stack(
                                      alignment: Alignment.center,
                                        children:[

                                          videoLectureScreen(url:tiktokUrls[i]),
                                          InkWell(
                                            onTap: (){

                                              launchUrl(Uri.parse(tiktokUrls[i]),mode: LaunchMode.externalApplication
                                              );
                                              // Navigator.pushReplacement(
                                              //     context,
                                              //     MaterialPageRoute(builder: (context) => videoLectureScreen(url: tiktokUrls[i])));

                                            },
                                            child: Container(
                                              width:500,
                                              height:500,
                                              color: Colors.transparent,
                                            ),
                                          ),
                                        ]),
                                  )

                              ),
                            ));
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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
            if(name == "License") {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => license_screen()));
            }


            // Navigator.pushReplacement(
              //     context,
              //     MaterialPageRoute(builder: (context) => license_screen()));
              //

          },
          child:  Container(
            decoration: BoxDecoration(
                color:Colors.blue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(color: Colors.blueAccent.withOpacity(0.3),
                      spreadRadius: 7,
                      blurRadius: 10,
                      offset: Offset(0, 2)
                  ),
                ]),
            width: MediaQuery.of(context).size.width*0.38,
            height:MediaQuery.of(context).size.height*0.15,
            child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Image.asset
                  ("assets/${image}.png",
                  width: MediaQuery.of(context).size.width*0.35,
                  height: 130,
                  fit: BoxFit.scaleDown,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                width: MediaQuery.of(context).size.width*0.38,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)
                  ),
                    color: Colors.blue.withOpacity(0.8),

                ),
                height: 28,
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
              ),
          ));

  }

  Future<void> getTiktoks() async {

    DatabaseReference ref = FirebaseDatabase.instance.ref().child("admin").child("mytiktoks").
    child("urls");

    DatabaseEvent event = await ref.once();

    if(event.snapshot.exists){
      event.snapshot.children.forEach((element) {
        tiktokUrls.add( element.value.toString());

      });
    }
    setState(() {

    });
    // tiktokUrls = temp.cast<String>();
  }


}
