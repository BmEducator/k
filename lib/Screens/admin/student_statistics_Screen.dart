import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../Models/QuizModel.dart';
import 'package:intl/intl.dart';

import '../../Models/studentModel.dart';
import 'edit_student_Screen.dart';

class student_statistics_screen extends StatefulWidget {
  studentModel student;

  student_statistics_screen({Key? key, required this.student})
      : super(key: key);

  @override
  State<student_statistics_screen> createState() =>
      _student_statistics_screenState();
}

class _student_statistics_screenState extends State<student_statistics_screen> {
  late studentModel student;
  late List<quizModel> quizesList = [];
  bool isLoading = true;
  bool hasData = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    student = widget.student;

    getQuizesResults();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: SafeArea(
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.blue,
                            size: 25,
                          )),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: InkWell(
                          onTap: (){
                            _showEditDialog(context, widget.student);
                          },
                          child: Material(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.amber,
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("      Edit Profile      ",style: TextStyle(fontFamily: "PoppinRegular",color: Colors.black,fontSize: 14),),
                              )),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "   " + student.name,
                    style: const TextStyle(fontFamily: "Poppins", fontSize: 28),
                  ),
                  Divider(thickness: 4,),
                  const SizedBox(
                    height: 10,
                  ),
                  hasData

                      ?
                  AnimationLimiter(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(8.0),
                      itemCount: quizesList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 675),
                          child: SlideAnimation(
                            verticalOffset: 44.0,
                            child: FadeInAnimation(
                                child: InkWell(
                                  onTap: () async {
                                    // Navigator.pushReplacement(
                                    //     context, MaterialPageRoute(builder: (context) => ));
                                  },
                                  child: containerItem(index),
                                )
                            ),
                          ),
                        );
                      },
                    ),
                  )
                      : Center(
                    child: Column(
                      children: [
                        SizedBox(height: 200,),
                        Icon(Icons.hourglass_empty_outlined,size: 40,color: Colors.red,),
                        SizedBox(height: 30,),
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

            )),

    );
  }

  Widget containerItem(int i) {
    var d = DateTime.fromMicrosecondsSinceEpoch(int.parse(quizesList[i].date));
    var a = DateFormat('dd-MM-yyyy').format(d);
    var t = DateFormat('hh:mm').format(d);

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
          height: MediaQuery.of(context).size.height * 0.23,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const Text(
                        "Family",
                        style: TextStyle(fontFamily: "PoppinRegular"),
                      ),
                      const Text(
                        "44",
                        style: TextStyle(fontFamily: "Poppins"),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40),
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
                        a.toString(),
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
              const SizedBox(
                height: 10,
              ),
              const Divider(
                thickness: 2,
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: Row(
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
                              "Time",
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
                      color: quizesList[i].mistakes.length > 3
                          ? Colors.red[500]
                          : Colors.green[500],
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
                                    fontFamily: "Poppins", color: Colors.white),
                              ),
                              Text(
                                "${quizesList[i].totalQuestions} Total",
                                style: const TextStyle(fontFamily: "Poppins",color: Colors.white),
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getQuizesResults() async {
    print(student.email);

    await FirebaseFirestore.instance.collection("students").
    doc(student.email).collection("quizesProgress")
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
// 
//
//     var data = await FirebaseFirestore.instance
//         .collection("students")
//         .doc(student.email)
//         .collection("quizes")
//         .get(const GetOptions(source: Source.server));

    if (quizesList.isNotEmpty) {
      // print("exisr");
      // quizesList =
      //     List.from(data.docs.map((doc) => quizModel.fromSnapshot(doc)));


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
                      InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const Icon(Icons.close),
                        ),
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
                      q.mistakes.length > 0?
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
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
                                    Text(
                                      "Answer:   ",
                                      style: const TextStyle(
                                        fontFamily: "PoppinRegular",color: Colors.blueGrey,fontSize: 12,
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
                      ):
                          Center(
                            child: Text("No Mistake.....",style: TextStyle(fontSize: 17),),
                          )

                    ],
                  ),
                ),
              ));
        });
  }

  Future<void> _showEditDialog(BuildContext context, studentModel std) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(

              contentPadding: EdgeInsets.zero,
              content: editStudentScreen(student: std, accessLimit: widget.student.accessDate,));
        });
  }
}
