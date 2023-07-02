
import 'package:bmeducators/Screens/admin/student_statistics_Screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


import '../../Models/QuizModelForAdmin.dart';
import '../../Models/question.dart';
import '../../Models/studentModel.dart';
import 'admin_Screen.dart';

class created_quiz_detail extends StatefulWidget {
  quizModelForAdmin quiz;
  String quizno;
  created_quiz_detail({Key? key,required this.quiz,required this.quizno}) : super(key: key);

  @override
  State<created_quiz_detail> createState() => _created_quiz_detailState();
}

class _created_quiz_detailState extends State<created_quiz_detail> {
  String mode = "Study";


  List<QuestionModel> questionsList = [];
  List<QuestionModel> questionsListFromBank = [];
  List<studentModel> studentsList = [];
  List<studentModel> selectedStudentsList = [];

  String date = "";

  @override
  void initState() {

    // TODO: implement initState
    super.initState();
    widget.quiz.questions.forEach((element) {
      QuestionModel q = QuestionModel(
          image: element['image'],
          statement: element['statement'],
          optionA: element['optionA'],
          option2: element['option2'],
          optionC: element['optionC'],
          answer: element['answer']);
      questionsList.add(q);
    });

    widget.quiz.students.forEach((element) {
      studentModel st = studentModel(
          id: element['id'],
          name: element['name'],
          contact: element['contact'],
          profileImage: element['profileImage'],
          dateofBirth: element['dateofBirth'],
          email: element['email'],
          dni: element['dni'],
          address: element['address'],
          education: element['education'],
          language: element['language'], accessDate: element['accessDate'], translation: element['translation'], token: element['token'], mode:element['mode'], licenseType:element['licenseType'], revise: element['revise']);
      selectedStudentsList.add(st);

      DateFormat format = DateFormat("dd-MM-yy");
      date = format.format(DateTime.fromMillisecondsSinceEpoch(int.parse(widget.quiz.timestamp)));

      setState(() {

      });


    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                InkWell(
                  onTap: (){
                    Navigator.pop(context);

                  },
                  child: const Icon(
                    Icons.close,
                    color: Colors.blue,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30,),
                    Text(
                      "Quiz No ${widget.quizno}",
                      style: TextStyle(fontFamily: "Poppins", fontSize: 25),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Mode: ",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 16,),
                            ),
                            Text(
                              widget.quiz.mode,
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 16,
                                  color: Colors.purpleAccent),
                            ),

                          ],
                        ),
                        Row(
                          children: [
                            Text("Total Questions:",style: TextStyle(fontFamily: "Poppins",fontSize: 18),),
                            Text(" ${questionsList.length}  ",style: TextStyle(fontFamily: "Poppins",fontSize: 20,color: Colors.purpleAccent),),
                          ],
                        )

                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Created on: ${date}",style: TextStyle(fontFamily: "PoppinRegular",fontSize: 15),),

                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("Students:",style: TextStyle(fontFamily: "Poppins",fontSize: 18),),
                            Text(" ${selectedStudentsList.length}  ",style: TextStyle(fontFamily: "Poppins",fontSize: 20,color: Colors.purpleAccent),),
                          ],
                        ),
                      ],
                    ),

                    Divider(thickness: 2),

                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20,),
                    Text(
                      "Questions",
                      style: TextStyle(fontFamily: "Poppins", fontSize: 25,color: Colors.blue),
                    ),
                    Divider(thickness: 3,endIndent: 230,),
                    SizedBox(height: 10,),
                  ],
                ),

                ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),

                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () async {},
                      child: Material(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Q${index+1}-  ${questionsList[index].statement}",
                                style: TextStyle(fontFamily: "Poppins",color: Colors.teal),
                              ),
                              Text(
                                " 1)  ${questionsList[index].optionA}",
                                style: TextStyle(fontFamily: "PoppinRegular",color: questionsList[index].answer == questionsList[index].optionA?Colors.orange:Colors.black),
                              ),
                              Text(" 2)  ${questionsList[index].option2}", style: TextStyle(fontFamily: "PoppinRegular",color: questionsList[index].answer == questionsList[index].option2?Colors.orange:Colors.black),),
                              Text(" 3)  ${questionsList[index].optionC}", style: TextStyle(fontFamily: "PoppinRegular",color: questionsList[index].answer == questionsList[index].optionC?Colors.orange:Colors.black),),
                              Divider(
                                thickness: 4,
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: questionsList.length,
                ),
                SizedBox(height: 30,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Students",
                      style: TextStyle(fontFamily: "Poppins", fontSize: 25,color: Colors.blue),
                    ),
                    Divider(thickness: 3,endIndent: 230,)
                  ],
                ),
                ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(10),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () async {
                        Navigator.pushReplacement(
                            context, MaterialPageRoute(builder: (context) => student_statistics_screen(student: studentsList[index])));

                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          elevation: 2,
                          child: ListTile(
                            tileColor: Colors.grey[100],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(selectedStudentsList[index].profileImage),
                              radius: 25,
                            ),
                            title: Text(
                              selectedStudentsList[index].name,
                              style: const TextStyle(fontSize: 17, fontFamily: "Poppins"),
                            ),
                            subtitle: Text(
                              "Age:  "+  selectedStudentsList[index].dateofBirth,
                              style: const TextStyle(fontSize: 15),
                            ),
                            horizontalTitleGap: 10,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10),

                          ),
                        ),
                      ),
                    );
                  },
                  itemCount:selectedStudentsList.length,
                )
              ]),
            ),
          ),
        ),
      );
  }


  void update() {
    setState(() {});
  }
}
