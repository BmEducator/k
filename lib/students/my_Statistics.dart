import 'package:bmeducators/students/quiz_ExamMode_Screen.dart';
import 'package:bmeducators/students/quiz_screen.dart';
import 'package:bmeducators/students/reviseMode.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models/QuizModel.dart';
import 'package:intl/intl.dart';

import '../Models/QuizToPerformModel.dart';
import '../Models/notificationMode.dart';
import '../Models/studentModel.dart';

class my_StatisticsScreen extends StatefulWidget {


  my_StatisticsScreen({Key? key})
      : super(key: key);

  @override
  State<my_StatisticsScreen> createState() =>
      _my_StatisticsScreenState();
}

class _my_StatisticsScreenState extends State<my_StatisticsScreen> {
  late studentModel student;
  late List<quizModel> quizesList = [];
  bool isLoading = true;
  bool hasData = false;
  late List<quizToPerformModel> mistakesQuizesList = [];

  String email = "";

  late SharedPreferences pref;

  Future init() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      email = pref.getString("email")!;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getResults();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               Padding(
                 padding: const EdgeInsets.all(10.0),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: <Widget>[
                         IconButton(
                             onPressed: () {
                               Navigator.pop(context);
                             },
                             icon: const Icon(
                               Icons.arrow_back_ios,
                               color: Colors.blue,
                             )),
                       ],
                     ),
                     const SizedBox(
                       height: 10,
                     ),
                     Container(
                       width: MediaQuery.of(context).size.width * 0.5,
                       child: FittedBox(child: Text(
                         "  My Progress  ",
                         style: const TextStyle(fontFamily: "Poppins", fontSize: 28,color: Colors.blue),
                       ),),
                     ),
                     Divider(thickness: 4,),
                     const SizedBox(
                       height: 10,
                     ),
                   ],
                 ),
               ),
                !isLoading
                    ? Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      hasData
                          ?
                      // AnimationLimiter(
                      //   child: ListView.builder(
                      //     shrinkWrap: true,
                      //     reverse: true,
                      //     physics: NeverScrollableScrollPhysics(),
                      //     padding: const EdgeInsets.all(8.0),
                      //     itemCount: quizesList.length,
                      //     itemBuilder: (BuildContext context, int index) {
                      //       return AnimationConfiguration.staggeredList(
                      //         position: index,
                      //         duration: const Duration(milliseconds: 175),
                      //         child: SlideAnimation(
                      //           horizontalOffset: 100,
                      //
                      //           child: FadeInAnimation(
                      //               child: InkWell(
                      //                 onTap: () async {
                      //                   // Navigator.pushReplacement(
                      //                   //     context, MaterialPageRoute(builder: (context) => ));
                      //                 },
                      //                 child: containerItem(index),
                      //               )
                      //           ),
                      //         ),
                      //       );
                      //     },
                      //   ),
                      // )
                      Container(
                        child: GridView.count(
                          shrinkWrap: true,
                          padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                          scrollDirection: Axis.vertical,
                          crossAxisCount: 3,
                          childAspectRatio: (1 /1),
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 20,
                          children: List.generate(
                            mistakesQuizesList.length,
                                (int i) {
                              return cotainerItem(i);
                            },
                          ),
                        ),
                      )
                          : Center(
                        child: Column(
                          children: [
                            SizedBox(height: MediaQuery.of(context).size.height * 0.2,),
                            Icon(Icons.hourglass_empty_outlined,size: 40,color: Colors.red,),
                            const Text(
                              "Nothing to show",
                              style: TextStyle(
                                  fontFamily: "PoppinRegular",
                                  fontSize: 20,
                                  color: Colors.blue),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
                    :  Container
                  (
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.5,

                  child: Center(
                      child: LoadingAnimationWidget.discreteCircle(
                        color: Colors.blueAccent,
                        size: 50,
                      )),
                ),
              ],
            )),
      ),
    );
  }

  Widget containerItem(int i) {
    var d = DateTime.fromMicrosecondsSinceEpoch(int.parse(quizesList[i].date));
    var a = DateFormat('dd-MM-yyyy').format(d);
    var t = DateFormat('hh:mm').format(d);

    String date;

    DateTime now = DateTime.now();

    Duration  duration = now.difference(d);
    String days = duration.inDays.toString();
    int diff = int.parse(days);

    if( diff == 1){
      date = "Yesterday";
    }
    else if( diff == 0 ) {
      date = "Today";
    }
    else{
      date = a.toString();

    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        elevation: 5,
        clipBehavior: Clip.antiAlias,
        child: Container(
          color: Colors.blue.withOpacity(0.2),
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.21,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const Text(
                        "   Family",
                        style: TextStyle(fontFamily: "PoppinRegular"),
                      ),
                      const Text(
                        "01",
                        style: TextStyle(fontFamily: "Poppins"),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: Column(
                      children: [
                        const Text(
                          "Test#",
                          style: TextStyle(fontFamily: "PoppinRegular"),
                        ),
                        Text(
                          (i + 1).toString(),
                          style: const TextStyle(fontFamily: "Poppins"),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      const Text(
                        "Date",
                        style: TextStyle(fontFamily: "PoppinRegular"),
                      ),
                      Text(
                        date,
                        style: const TextStyle(fontFamily: "Poppins"),
                      ),
                      Text(
                        t.toString(),
                        style: const TextStyle(fontFamily: "Poppins"),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(
                thickness: 2,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.timer_outlined,
                          ),
                          const Text(
                            " Time",
                            style: TextStyle(fontFamily: "PoppinRegular"),
                          ),
                        ],
                      ),
                      Text(
                        quizesList[i].time.toString(),
                        style: const TextStyle(fontFamily: "Poppins",fontSize: 16,color: Colors.purpleAccent),
                      ),
                    ],
                  ),
                  Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(5),
                    color: quizesList[i].mistakes.length > 3 ? Colors.red[500]
                        : quizesList[i].mistakes.length == 0?
                    Colors.green[500]:
                        Colors.orangeAccent,
                    child: InkWell(
                      onTap: () {
                        _showMistakesDialog(context, i, quizesList[i]);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: Column(
                          children: [
                            const Text(
                              "Result",
                              style: TextStyle(fontFamily: "PoppinRegular"),
                            ),
                            Text(
                              "${quizesList[i].mistakes.length} Wrong",
                              style: const TextStyle(fontSize: 14,
                                  fontFamily: "Poppin", color: Colors.white),
                            ),
                            Text(
                              "${quizesList[i].totalQuestions} Total",
                              style: const TextStyle(fontFamily: "Poppin",color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      const Text(
                        "Mode",
                        style: TextStyle(fontFamily: "PoppinRegular"),
                      ),
                      Text(
                        quizesList[i].mode,
                        style: TextStyle(fontFamily: "Poppins",fontSize: 16,color: Colors.blueAccent),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }




  Future<void> getQizesResults() async {

    await init();
    print(email);

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
              mistakes: [], mode: value[5]);

          for(int i =6;i< value.length ;i++){
            q.mistakes.add(value[i]);
          }
          quizesList.add(q);
        }

        );

      })
    });

    quizesList.sort((quizModel a, quizModel v) => a.id.compareTo(v.id));


    if (quizesList.isNotEmpty) {
      print("exisr");
      setState(() {
        isLoading = false;
        hasData = true;
        print(quizesList.length);
      });
    } else {
      print("dsf");
      hasData = false;
      setState(() {
        isLoading = false;
      });
    }
  }


  Future<void> getResults() async {

    await init();
    DocumentSnapshot snap = await FirebaseFirestore.instance.collection("students").
    doc(email).collection("allMistakes").doc("mistakes").get();
    if (snap.exists) {
      List<dynamic> questions = snap['questions'];
      print(questions.length);
      List<QuestionModel> list = questions.cast<QuestionModel>();
      print(list.length);
      List<dynamic> questionforQuiz = [];

      int multiplesOf30 = (list.length / 30).ceil();

      print("mutliples of 30 $multiplesOf30");

      for(int i = 0 ; i < multiplesOf30; i++){
        quizToPerformModel m  = quizToPerformModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            questions:[],
            mode: 'Errors',
            timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
            status:'Pending');
        mistakesQuizesList.add(m);
      }

      int no = 0;
      for(int i = 1 ; i <= questions.length ; i++) {
        print("i == $i");
        print("no == $no");
        mistakesQuizesList[no].questions.add(questions[i-1]);
        if(i%30 == 0){
          no++;
        }
      }
    }

    if (mistakesQuizesList.isNotEmpty) {
      setState(() {
        isLoading = false;
        hasData = true;
      });
    } else {
      hasData = false;
      setState(() {
        isLoading = false;
      });
    }


    // await init();
    // var data = await FirebaseFirestore.instance
    //     .collection("students")
    //     .doc(email)
    //     .collection("quizes")
    //     .get(const GetOptions(source: Source.server));
    //
    // if (data.docs.isNotEmpty) {
    //   print("exisr");
    //   quizesList =
    //       List.from(data.docs.map((doc) => quizModel.fromSnapshot(doc)));
    //
    //   setState(() {
    //     isLoading = false;
    //     hasData = true;
    //     print(quizesList.length);
    //   });
    // } else {
    //   print("dsf");
    //   hasData = false;
    //   setState(() {
    //     isLoading = false;
    //   });
    // }

  }
  Future<void> _showMistakesDialog(BuildContext context, int i, quizModel q) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              contentPadding: EdgeInsets.zero,
              content: Scaffold(
                body: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: const Icon(Icons.close),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Center(
                          child: Text(
                            "Mistakes",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                color: Colors.red,
                                fontSize: 24),
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      Visibility(
                        visible: q.mistakes.length > 0,
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(10),
                          itemBuilder: (context, index) {
                            String stat = q.mistakes[index];
                            String t = stat.substring(0,stat.indexOf("~"));

                            String  ans = stat.substring(stat.indexOf("~")+1,stat.length);

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Material(
                                  elevation: 2,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        " ${index + 1}-  ${t}",
                                        style: const TextStyle(
                                            fontFamily: "PoppinRegular",
                                            fontSize: 16),
                                      ),
                                      SizedBox(height: 20,),
                                      Text(
                                        "Answer:   ",
                                        style: const TextStyle(
                                          fontFamily: "PoppinRegular",
                                        ),
                                      ),
                                      SizedBox(
                                        width:MediaQuery.of(context).size.width *0.6,
                                        child: Text(
                                          ans,
                                          style: const TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: 16,color: Colors.blue),
                                        ),
                                      ),
                                    ],
                                  )),
                            );
                          },
                          itemCount: q.mistakes.length,
                        ),
                      ),
                    ],
                  ),
                ),
              ));
        });
  }

  Widget cotainerItem(int i) {


    return Padding(
        padding: const EdgeInsets.only(bottom: 5,right: 0,left: 0),
        child: Material(
          borderRadius: BorderRadius.circular(10),
          elevation: 10,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () async {
              _showModeDialog(context, mistakesQuizesList[i], "");

            },
            child: Container(
                color: Colors.red[500],
                // color:status == "   Done  "? Color(0xff00aeff).withOpacity(0.7) :Color(0xff00aeff).withOpacity(0.2),
                padding: const EdgeInsets.symmetric(vertical:10, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Quiz #",style: TextStyle(fontFamily:
                        "PoppinRegular",fontSize: 14,
                            color:Colors.white),),
                        Text((mistakesQuizesList[i].questions.length).toString(),style: TextStyle(
                            fontFamily: "Poppins",color:Colors.white,
                            fontSize: 15),),

                      ],
                    ),




                  ],
                )
            ),
          ),
        )
    );
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
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                    child: const Text(
                      "Select Mode",
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
                                      quizToPerform: quiz, isLanguageTranslation: "false",)));

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
                                  Text("Revise",
                                      style: TextStyle( fontFamily: "Poppins"))
                                ],
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            bool isContinue = false ;
                            List<int> t  = [];

                            Navigator.pushReplacement(
                                context, MaterialPageRoute(builder: (context) =>
                                quiz_ExamMode_Screen(quiz: quiz,
                                  isLanguageTranslation: "false",
                                  isShuffle: isContinue,
                                  selecteddataList: t,
                                  completedQuizes: [], mode:"Retry",) ));

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
                                  Text(" Retry ",
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

}
