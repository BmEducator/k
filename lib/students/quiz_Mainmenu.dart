import 'dart:math';

import 'package:bmeducators/students/quiz_ExamMode_Screen.dart';
import 'package:bmeducators/students/quiz_screen.dart';
import 'package:bmeducators/students/reviseMode.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'dart:math' as math;

import '../../Models/QuizModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/QuizToPerformModel.dart';
import 'my_Statistics.dart';

class quizMainmenuScreen extends StatefulWidget {
  String myCourse;
   quizMainmenuScreen({Key? key,required this.myCourse}) : super(key: key);

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
  List<String> myCourses = [];
  List<quizModel> quizesResultList =[];

  late SharedPreferences pref;
  String isTranslation = "en";

  Future init() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      email = pref.getString("email")!;
      myFamily = widget.myCourse;
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
                physics: ClampingScrollPhysics(),
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
                            late List<dynamic> allquestions =[];
                            late List<dynamic> questionListforQuiz =[];

                            pendingQuizesList.forEach((element) {
                              element.questions.forEach((element) {
                                allquestions.add(element);
                              });
                            });
                            Random random = new Random();
                            int randomNumber = 0;
                            print(allquestions.length);
                            //

                            for(int i =0 ;i<30;i++){
                              randomNumber = random.nextInt(allquestions.length);
                              print(randomNumber);
                              questionListforQuiz.add(allquestions[randomNumber]);
                              if(i == 29){
                                quizToPerformModel qt = quizToPerformModel(
                                    id: "Random",
                                    questions:questionListforQuiz,
                                    mode: mode,
                                    status: "Pending",
                                    timestamp: DateTime.now().millisecondsSinceEpoch.toString());
                                _showModeDialog(context, qt, "Random");
                                pendingQuizesList.add(qt);
                                print(qt.questions.length);
                              }
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width*0.4,
                            height: MediaQuery.of(context).size.height*0.07,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Material(
                                elevation: 4,
                                color: Colors.orange[900],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FittedBox(
                                    child: Row(
                                      children: const [
                                        Icon(PhosphorIcons.diceFiveBold,color: Colors.white,),
                                        Text(
                                          " Random ",
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
                             ? Container(
                           child: GridView.count(
                             physics: NeverScrollableScrollPhysics(),
                             shrinkWrap: true,
                             padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                             scrollDirection: Axis.vertical,
                             crossAxisCount: 3,
                             childAspectRatio: (1 /1),
                             crossAxisSpacing: 15,
                             mainAxisSpacing: 20,
                             children: List.generate(
                               pendingQuizesList.length,
                                   (int i) {
                                 return containerItem(i);
                               },
                             ),
                           ),
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

  Widget cotainerItem(int i) {
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
                isLanguageTranslation: isTranslation, isShuffle: isContinue, selecteddataList: t, completedQuizes: completedQuizes, mode: "Exam"'',) ));
        }
        else {
          if(status == "   Done  " && revise == "true"){

            _showReviseDialog(context, pendingQuizesList[i], status, i);

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
                miniItem("Status", status)

              ],
            )
          ),
        ),
      ),
    );
  }
  Widget containerItem(int i) {

    String status = "Pending";


    int mistakes = -1;
    quizesResultList.forEach((element) {
      if(pendingQuizesList[i].id == element.id){
        mistakes = element.mistakes.length;
        print("has");
      }
      else{
        print("no");
      }
    });

    return Container(

        child: InkWell(
          onTap: () async {
            if(mistakes == -1){
              _showModeDialog(context, pendingQuizesList[i], status);

            }
            else {
              if(mistakes != -1 && revise == "true"){
                _showReviseDialog(context,pendingQuizesList[i],status,i);
              }
              else if(revise == "false"){
                print("revise is off");
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Your Revision Mode is Closed By Admin.")));

              }}

          },
          child: Container(

            decoration: BoxDecoration(
                color: mistakes > 3 ? Colors.red[500]
                    :
                mistakes == 0? Colors.green[500]:
                mistakes == -1? Colors.white:
                Colors.orangeAccent,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(color: mistakes > 3 ? Colors.red.withOpacity(0.5)
                      :
                mistakes == 0 ?  Colors.green.withOpacity(0.3):
                  mistakes == -1?    Colors.black.withOpacity(0.2):
                      Colors.orangeAccent.withOpacity(0.7),
                      spreadRadius: 3,
                      blurRadius: 4,
                      offset: Offset(0, 2)
                  ),
                ]),

              alignment: Alignment.center,
              // color:status == "   Done  "? Color(0xff00aeff).withOpacity(0.7) :Color(0xff00aeff).withOpacity(0.2),
              child:  Text((i+1).toString(),style: TextStyle(
                  fontFamily: "Poppins",color: mistakes == -1 ?Colors.deepOrange:Colors.white,
                  fontSize: 22),),


          ),
        )
    );
  }



  Future<void> getQuizes() async {
    await init();
    print(myFamily);

    await FirebaseFirestore.instance.collection("admin").
    doc("data").collection("QuizBank")
        .doc("Families").collection(myFamily).get(GetOptions(source: Source.server)).then((value) => {
      value.docs.forEach((element) {
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
  await FirebaseFirestore.instance.collection("students").
  doc(email).collection("quizesProgress")
      .get().then((query) => {
    query.docs.forEach((element) {
      Map dst = element.data();
      dst.forEach((key, value) {
        quizModel q = quizModel(
            id: value[0],
            date: value[1],
            totalQuestions: value[2],
            correct: value[3],
            time:value[4],
            mistakes: [],
            mode: value[5]);

        for(int i =6;i< value.length ;i++){
          q.mistakes.add(value[i]);
        }
        quizesResultList.add(q);
        print(quizesResultList[0].id);
        setState(() {

        });
      }
      );
    })
  });
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


  Future<void> _showReviseDialog(BuildContext context,
      quizToPerformModel quiz,
      String status,
      int i ,

      ) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                    child: const Text(
                      "You have already Completed this Quiz",
                      style: TextStyle(fontFamily: "Poppins"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushReplacement(new MaterialPageRoute(
                                builder: (context) =>
                                    reviseModeScreen(
                                      quizToPerform: quiz, isLanguageTranslation: isTranslation,)));

                          },
                          child: Card(
                            elevation: 10,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.cached,
                                    size: 30,
                                    color: Colors.purple,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text("Revise",
                                      style: TextStyle( fontFamily: "Poppins"))
                                ],
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _showModeDialog(context, quiz, status);
                          },
                          child: Card(
                            elevation: 10,
                            child: Container(
                              padding: const EdgeInsets.all(10),

                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.repeat_on_outlined,
                                    color: Colors.green,
                                    size: 30,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(" Redo ",
                                      style: TextStyle(
                                          fontFamily: "Poppins"))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _showModeDialog(BuildContext context,
      quizToPerformModel quiz,String status) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                    child: const Text(
                      "Select Mode",
                      style: TextStyle(fontFamily: "Poppins"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Visibility(
                          visible: mode == "Both" || mode == "Study",
                          child: InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context, MaterialPageRoute(
                                  builder: (context) =>
                                      quizScreen(
                                        quizToPerform: quiz, isLanguageTranslation: isTranslation, completedQuiz: completedQuizes,)));

                            },
                            child: Card(
                              elevation: 10,
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      PhosphorIcons.student,
                                      size: 30,
                                      color: Colors.purple,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text("Study",
                                        style: TextStyle( fontFamily: "Poppins"))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: mode == "Both" || mode == "Exam",

                          child: InkWell(
                            onTap: () {
                              // bool isContinue = false ;
                              // List<int> t  = [];


                              // if(pref.containsKey("selectedOptions${quiz.timestamp}")){
                              //   List<String>? temp = pref.getStringList("selectedOptions${quiz.timestamp}");
                              //   temp?.forEach((element) {
                              //     t.add(int.parse(element));
                              //   });
                              //   t.forEach((element) {
                              //     if(element != 0){
                              //       isContinue = true;
                              //     }
                              //   });
                              //   print(t);
                              // }
                              if(status == "Random"){
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) =>
                                        quiz_ExamMode_Screen(
                                          quiz: quiz,
                                          isLanguageTranslation: isTranslation,
                                          isShuffle: false,
                                          selecteddataList: [],
                                          completedQuizes: completedQuizes,
                                          mode: "Random",)));
                              }
                              else {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) =>
                                        quiz_ExamMode_Screen(quiz: quiz,
                                          isLanguageTranslation: isTranslation,
                                          isShuffle: false,
                                          selecteddataList: [],
                                          completedQuizes: completedQuizes,
                                          mode: "Exam",)));
                              }
                            },
                            child: Card(
                              elevation: 10,
                              child: Container(
                                padding: const EdgeInsets.all(20),

                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      PhosphorIcons.exam,
                                      color: Colors.green,
                                      size: 30,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(" Exam ",
                                        style: TextStyle(
                                            fontFamily: "Poppins"))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }


}
