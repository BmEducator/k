import 'package:bmeducators/Screens/admin/admin_Screen.dart';
import 'package:bmeducators/Screens/admin/questionBank.dart';
import 'package:bmeducators/Screens/admin/questionPank_categories.dart';
import 'package:bmeducators/Screens/admin/searchScreen.dart';
import 'package:bmeducators/Screens/admin/searchedQuestion.dart';
import 'package:bmeducators/Screens/admin/quiz_numbers_screen.dart';
import 'package:bmeducators/Screens/admin/videoScreenAdmin.dart';
import 'package:bmeducators/Screens/homeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../Models/question.dart';
import 'createQuiz.dart';

class taxi_subcategories extends StatefulWidget {
  String type;
   taxi_subcategories({Key? key,required this.type}) : super(key: key);

  @override
  State<taxi_subcategories> createState() => _taxi_subcategoriesState();
}

class _taxi_subcategoriesState extends State<taxi_subcategories> {

  List<List<String>> familiesList = [
    ['B1', 'Bloque 1'],
    ['B2', 'Bloque 2'],
    ['C', 'Cap'],
    ['Other', 'others'],
  ];
  String searchText = "";
  late List<QuestionModel> questionList =[];
  late SharedPreferences pref;
  bool isLoading = false;

  Future init() async{
    pref = await SharedPreferences.getInstance();

  }

  @override
  void initState() {
    // TODO: implement initState
    // getfamilies();
    super.initState();
  }

  Future<bool> willpop() async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => questionPankCategories(type: widget.type,)));
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
                                        context, MaterialPageRoute(builder: (context) => adminScreen()));
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
                                "Taxi Subcategories",
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
                                                child:serviceContainer(familiesList[i][0], familiesList[i][1], 1)
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
            Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) =>
                        adminVideoScreen(family: name,)));
          }
          else{
          if(char == "CTB"){

          }
          {
            Navigator.pushReplacement(
                context, MaterialPageRoute(
                builder: (context) => quizNoScreen(familyName: name)));
          }}


        },
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

  // Future<void> _showCreateDialog() {
  //   TextEditingController controller = TextEditingController();
  //   return showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           contentPadding: EdgeInsets.zero,
  //           content: SingleChildScrollView(
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 InkWell(
  //                   onTap: () {
  //                     Navigator.pop(context);
  //                   },
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(8.0),
  //                     child: const Icon(Icons.close),
  //                   ),
  //                 ),
  //                 const SizedBox(
  //                   height: 10,
  //                 ),
  //                 Container(
  //                     margin:
  //                         EdgeInsets.symmetric(horizontal: 15, vertical: 10),
  //                     width: MediaQuery.of(context).size.width * 0.9,
  //                     padding: EdgeInsets.symmetric(horizontal: 10),
  //                     decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(10),
  //                         color: Colors.red[100]),
  //                     child: TextField(
  //                       controller: controller,
  //                       decoration: InputDecoration(
  //                         labelText: " Add Family Name",
  //                       ),
  //                     )),
  //                 Padding(
  //                   padding: const EdgeInsets.all(40.0),
  //                   child: Material(
  //                     borderRadius: const BorderRadius.all(Radius.circular(8)),
  //                     elevation: 6,
  //                     color: Colors.blue,
  //                     child: InkWell(
  //                       onTap: () async {
  //                         List<String> urlslist = [];
  //                         // urlslist.addAll(widget.urls);
  //                         familiesList.add(controller.text);
  //                         await FirebaseFirestore.instance
  //                             .collection("admin")
  //                             .doc("data")
  //                             .collection("families")
  //                             .doc("families")
  //                             .set({
  //                           'families': FieldValue.arrayUnion(familiesList)
  //                         });
  //
  //
  //                         setState(() {
  //
  //                         });
  //                         Navigator.pop(context);
  //
  //                         ScaffoldMessenger.of(context).showSnackBar(
  //                             SnackBar(content: Text("Family Added")));
  //                         // Navigator.pushReplacement(
  //                         //     context, MaterialPageRoute(builder: (context) => myTiktoks()));
  //                       },
  //                       child: Container(
  //                         height: 40,
  //                         width: double.infinity,
  //                         alignment: Alignment.center,
  //                         child: const Text(
  //                           'Save',
  //                           style: TextStyle(
  //                               color: Colors.white,
  //                               fontSize: 17,
  //                               fontFamily: "Poppins"),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }

  // Future<void> getfamilies() async {
  //   await init();
  //
  //   List<String> temp = [
  //   'Permiso AM',
  //   'Permiso A1-A2',
  //   'Permiso B',
  //   'Permiso C',
  //   'Permiso D',
  //   'Permiso C+E',
  //   'CAP',
  //   'Curso de Taxi Barcelona'];
  //
  //   familiesList.addAll(temp);
  //  // try {
  //  //   print("cache");
  //  //   await FirebaseFirestore.instance
  //  //       .collection("admin")
  //  //       .doc("data")
  //  //       .collection("families")
  //  //       .doc("families").get(GetOptions(source: Source.cache)).then((value) =>
  //  //   {
  //  //
  //  //     temp.addAll(value["families"])
  //  //   });
  //  //
  //  //   familiesList = temp.cast<String>();
  //  // }on FirebaseException catch(e){
  //  //   print("notExist");
  //  //   print("f from cache");
  //  //   await FirebaseFirestore.instance
  //  //       .collection("admin")
  //  //       .doc("data")
  //  //       .collection("families")
  //  //       .doc("families").get(GetOptions(source: Source.server)).then((value) =>
  //  //   {
  //  //     temp.addAll(value["families"])
  //  //   });
  //  //
  //  //   familiesList = temp.cast<String>();
  //  //
  //  //
  //  // }catch (e){
  //  //
  //  // }
  //
  //
  //
  //
  //
  //   //
  //   //
  //   // if(pref.containsKey("families")){
  //   //
  //   //   familiesList = pref.getStringList("families")!;
  //   //
  //   //   if(familiesList.length == 0){
  //   //     print("from server");
  //   //     await FirebaseFirestore.instance
  //   //         .collection("admin")
  //   //         .doc("data")
  //   //         .collection("families")
  //   //         .doc("families").get(GetOptions(source: Source.server)).then((value) =>
  //   //     {
  //   //       temp.addAll(value["families"])
  //   //     });
  //   //
  //   //     setState(() {});
  //   //     familiesList = temp.cast<String>();
  //   //
  //   //     pref.setStringList("families",familiesList)!;
  //   //
  //   //     //
  //   //     //
  //   //     //
  //   //     // if (doc.exists ) {
  //   //     //   print("cache");
  //   //     //   temp.addAll(doc.get("families"));
  //   //     // } else {
  //   //     //   print("no cache");
  //   //     //
  //   //     // var doc =    await FirebaseFirestore.instance.
  //   //     // collection("admin").doc("data").
  //   //     // collection("families").doc("families").get(GetOptions(source: Source.server));
  //   //     // print("server");
  //   //     // temp.addAll(doc.get("families"));
  //   //
  //   //
  //   //   }
  //   //   else{
  //   //     print("cache");
  //   //   }
  //   // }
  //   // else{
  //   //     print("from server");
  //   //     await FirebaseFirestore.instance
  //   //         .collection("admin")
  //   //         .doc("data")
  //   //         .collection("families")
  //   //         .doc("families").get(GetOptions(source: Source.server)).then((value) =>
  //   //     {
  //   //       temp.addAll(value["families"])
  //   //     });
  //   //
  //   //     setState(() {});
  //   //     familiesList = temp.cast<String>();
  //   //
  //   //     pref.setStringList("families",familiesList)!;
  //   //
  //   // }
  //
  // isLoading = false;
  //   setState(() {
  //   }
  //
  //
  //
  //   );
  //
  //
  //
  //
  //
  // }

  Future<void> getQuestions() async {
    var data = await FirebaseFirestore.instance
        .collection('questions')
        .get(const GetOptions(source: Source.cache));

    if (data.docs.isNotEmpty) {
      print("exisr");
      setState(() {
        questionList =
            List.from(data.docs.map((doc) => QuestionModel.fromSnapshot(doc)));
        // isEndLoading = true;
        print(questionList[0].statement);
      });
    }
  }
}
