import 'package:bmeducators/students/quiz_ExamMode_Screen.dart';
import 'package:bmeducators/students/quiz_screen.dart';
import 'package:bmeducators/students/reviseMode.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'dart:math' as math;

import '../../Models/QuizModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/QuizToPerformModel.dart';
import 'my_Statistics.dart';

class quizMainmenuScreen extends StatefulWidget {
  const quizMainmenuScreen({Key? key}) : super(key: key);

  @override
  State<quizMainmenuScreen> createState() => _quizMainmenuScreenState();
}

class _quizMainmenuScreenState extends State<quizMainmenuScreen> {

  List<quizToPerformModel> pendingQuizesList=[];
  List<dynamic> completedQuizes=[];

  late List<quizModel> quizesList;
  bool isLoading = true;
  bool hasData = false;
  String email = "";
  String myFamily = "";
  String mode = "";
  String revise = "";

  late SharedPreferences pref;
  String isTranslation = "en";

  Future init() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      email = pref.getString("email")!;
      myFamily = pref.getString("myFamily")!;

    });
    getDataForTranslation();

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getQuizes();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child:Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     InkWell(
                       onTap: (){
                         Navigator.pop(context);

                       },
                       child: Icon(
                            Icons.arrow_back_ios, color: Colors.blue,),
                     ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width*0.3,
                          child: FittedBox(
                            child: Text(
                              "Quizzes",
                              style: TextStyle(fontFamily: "Poppins", fontSize: 28),
                            ),
                          )
                        ),
                        InkWell(
                          onTap: (){
                            Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        my_StatisticsScreen()));
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width*0.4,
                            height: MediaQuery.of(context).size.height*0.07,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Material(
                                elevation: 4,
                                color: Colors.blue[900],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FittedBox(
                                    child: Row(
                                      children: const [
                                        Icon(Icons.bar_chart,color: Colors.white,),
                                        Text(
                                          " Progress ",
                                          style: TextStyle(
                                              fontFamily: "Poppins",color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  )
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(thickness: 2,),
                    SizedBox(height: 30,),


                     !isLoading?
                     Container(
                         child:
                         hasData
                             ? ListView.builder(
                           reverse: true,
                           physics: const NeverScrollableScrollPhysics(),
                           shrinkWrap: true,
                           padding: const EdgeInsets.symmetric(
                               horizontal: 0, vertical: 10),
                           itemBuilder: (context, index) {
                             return containerItem(index);
                           },
                           itemCount: pendingQuizesList.length,
                         )
                             : Container(
                               width: MediaQuery.of(context).size.width,
                               height: MediaQuery.of(context).size.height * 0.4,
                               child: Center(
                                 child: const Text(
                           "No Quiz to show",
                           style: TextStyle(
                                   fontFamily: "PoppinRegular",
                                   fontSize: 20,
                                   color: Colors.blue),
                         ),
                               ),
                             ) ,
                       ):
                      Container
    (
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height * 0.3,

    child: Center(
    child: LoadingAnimationWidget.discreteCircle(
    color: Colors.blueAccent,
    size: 40,
    )),
    ),
                   
                  ],
                ),
              ),
            )),
    );
  }

  Widget containerItem(int i) {
    String status = "Pending";
    if(completedQuizes.contains(pendingQuizesList[i].id)) {
      status = "   Done  ";
    }
    // var d = DateTime.fromMicrosecondsSinceEpoch(int.parse(quizesList[i].date));
    // var a = DateFormat('dd-MM-yyyy').format(d);
    // var t = DateFormat('hh:mm').format(d);
    return InkWell(
      onTap: () async {
        if(mode == "Exam" && status =="Pending"){

          bool isContinue = false ;
          List<int> t  = [];

          print(pref.containsKey("selectedOptions${pendingQuizesList[i].timestamp}"));

          if(pref.containsKey("selectedOptions${pendingQuizesList[i].timestamp}")){
            print("contains");
            print("selectedOptions${pendingQuizesList[i].timestamp}");
            List<String>? temp = pref.getStringList("selectedOptions${pendingQuizesList[i].timestamp}");
            temp?.forEach((element) {
              t.add(int.parse(element));
            });
            t.forEach((element) {
              if(element != 0){
                isContinue = true;
              }
            });
            print(t);
          }
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) =>
              quiz_ExamMode_Screen(quiz: pendingQuizesList[i],
                isLanguageTranslation: isTranslation, isShuffle: isContinue, selecteddataList: t, completedQuizes: completedQuizes,) ));
        }
        else {
          if(status == "   Done  " && revise == "true"){
            print(revise);
            Navigator.pushReplacement(
                context, MaterialPageRoute(
                builder: (context) =>
                    reviseModeScreen(
                      quizToPerform: pendingQuizesList[i], isLanguageTranslation: isTranslation,)));

          }


          else if(status == "   Done  " && revise == "false"){
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Your Revise Mode is Closed By Admin.")));
          }
          else if(mode == "Study"){
            Navigator.pushReplacement(
                context, MaterialPageRoute(
                builder: (context) =>
                    quizScreen(
                      quizToPerform: pendingQuizesList[i], isLanguageTranslation: isTranslation, completedQuiz: completedQuizes,)));


          }}

      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Material(
          borderRadius: BorderRadius.circular(10),
          elevation: 5,
          clipBehavior: Clip.antiAlias,
          child: Container(
            color: Colors.blue.withOpacity(0.2),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
            height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width * 0.9,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                miniItem("Quiz #","  "+ (i+1).toString()+ "  " ),
                VerticalDivider(thickness: 2,),
                miniItem(" Mode ", " "+mode+" "),
                VerticalDivider(thickness: 2,),

                miniItem(" Total "," "+ pendingQuizesList[i].questions.length.toString()+" "),

                VerticalDivider(thickness: 2,),
                miniItem("Status", status)

              ],
            )
          ),
        ),
      ),
    );
  }

  Future<void> getQuize() async {

    await init();
    print(email);
    var querySnapshot = await FirebaseFirestore.instance.collection("students").
    doc(email).collection("Pending").get().then((value) => {
      value.docs.forEach((element) {
        quizToPerformModel m  = quizToPerformModel(
            id: element['id'],
            questions: element['questions'],
            mode: element['mode'], timestamp: element['timestamp'], status: element['status']);
        pendingQuizesList.add(m);
      })});

    if( pendingQuizesList.length>0){
      isLoading = false;
      hasData = true;
    }
    getDataForTranslation();
    setState(() {

    });
  }


  Future<void> getQuizes() async {
    await init();
    print(myFamily);

    await FirebaseFirestore.instance.collection("admin").
    doc("data").collection("QuestionBank")
        .doc("Families").collection(myFamily).get(GetOptions(source: Source.server)).then((value) => {
      value.docs.forEach((element) {
        print(element['id']);
        quizToPerformModel m  = quizToPerformModel(
            id: element['id'],
            questions: element['questions'],
            mode: 'Exam', timestamp: element['timestamp'], status:'Pending');
        pendingQuizesList.add(m);


      })});
  }
  Future<void> getDataForTranslation() async{


  await FirebaseFirestore.instance.collection("admin").doc(
  "data").collection("students").doc(
  "allStudents").collection("allStudents")
      .doc(email).get().then((value) {

     isTranslation = value['translation'];
     mode = value['mode'];
     revise = value['revise'];
     print(isTranslation);
  });
  try{
  await FirebaseFirestore.instance.collection("students").
  doc(email).collection("completedQuizes").doc("quizes").get().then((value) {
    completedQuizes = value['completedQuizes'];
  }).catchError((onError){
    print("error");
  });

  }on FirebaseException catch(e) {

    }
  print(completedQuizes);

  isLoading = false;

  if( pendingQuizesList.length > 0){
    hasData = true;
  }


  setState(() {

  });

  }

  miniItem(String name,String value){
    return     Container(
      width: MediaQuery.of(context).size.width * 0.15,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
          FittedBox(child: Text(name,style: TextStyle(fontFamily: "Poppins",)),),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
          FittedBox(child:Text(value,style: TextStyle(fontFamily: "Poppins",color: name == " Mode "?Colors.green : name == "Status" ?Colors.lightBlue:Colors.deepOrange,)))],

      ),
    );
  }
}
