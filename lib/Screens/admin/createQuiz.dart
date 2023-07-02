
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;



import '../../Models/QuizModelForAdmin.dart';
import '../../Models/QuizToPerformModel.dart';
import '../../Models/question.dart';
import '../../Models/studentModel.dart';
import 'admin_Screen.dart';

class create_quiz extends StatefulWidget {
  const create_quiz({Key? key}) : super(key: key);

  @override
  State<create_quiz> createState() => _create_quizState();
}

class _create_quizState extends State<create_quiz> {
  String mode = "";
  String error = "";
  var modes = ["","Study", "Exam"];


  List<QuestionModel> questionsList = [];
  List<QuestionModel> questionsListFromBank = [];
  List<studentModel> studentsList = [];
  List<studentModel> selectedStudentsList = [];

  @override
  void initState() {
    getQuestions();
    getStudents();
    // TODO: implement initState
    super.initState();
  }

  Future<bool> willpop() async {
    return (await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Row(
            mainAxisAlignment:
            MainAxisAlignment.start,
            children: [
              Text("Do you want to close this Quiz?",
                style: const TextStyle(fontFamily: "PoppinRegular"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text( "No",
                  style: const TextStyle(fontFamily: "Poppins")),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text("Yes",
                  style: const TextStyle(
                      color: Colors.grey, fontFamily: "Poppins")),
            ),
          ],
        )));
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: willpop,
      child: Scaffold(
          body: SafeArea(
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.blue,
                    )),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Create |",
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
                                  "Mode        ",
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 16,
                                      color: Colors.orange),
                                ),
                                DropdownButton(
                                  value: mode,
                                  icon: Icon(Icons.arrow_drop_down),
                                  iconSize: 30,
                                  onChanged: (String? v) {

                                    error = "";

                                    setState(() {
                                      mode = v!;
                                    });
                                  },
                                  items: modes.map<DropdownMenuItem<String>>((String v) {
                                    return DropdownMenuItem<String>(
                                      value: v,
                                      child: Text(
                                        v,
                                        style: TextStyle(fontFamily: "PoppinRegular"),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  error = "";
                                  setState(() {

                                  });
                                  addStudents(context);
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Material(
                                  elevation: 4,
                                  color: Colors.lightBlue,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: const [
                                        Icon(
                                          Icons.add_circle,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          " Add Students   ",
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: 14,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("${selectedStudentsList.length}  Students Selected      ",style: TextStyle(fontFamily: "Poppins",fontSize: 15),)
                          ],
                        ),
                        Divider(thickness: 2),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  error = "";
                                  setState(() {

                                  });
                                    addDialog(context);

                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Material(
                                    elevation: 4,
                                    color: Colors.deepOrange,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: const [
                                          Icon(
                                            Icons.add_circle,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            " Add Question",
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 14,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  error = "";

                                  setState(() {
                                    selectfromBankDialog(context);
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Material(
                                    elevation: 4,
                                    color: Colors.teal,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: const [
                                          Icon(
                                            Icons.add_circle,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            " Select from Bank   ",
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 14,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                            ],
                          ),
                        )
                      ],
                    )),
                ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  padding: const EdgeInsets.all(10),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () async {},
                      child: Material(
                        elevation: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Q1-  ${questionsList[index].statement}",
                              style: TextStyle(fontFamily: "Poppins"),
                            ),
                            Text(
                              " 1-  ${questionsList[index].optionA}",
                              style: TextStyle(fontFamily: "PoppinRegular"),
                            ),
                            Text(" 2-  ${questionsList[index].option2}"),
                            Text(" 3-  ${questionsList[index].optionC}"),
                            Divider(
                              thickness: 4,
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: questionsList.length,
                )
              ]),
              Visibility(
                visible: error !="",
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30,horizontal: 20),
                  child: Text("* $error",style: TextStyle(fontFamily: "Poppins",color: Colors.red,fontSize: 22),),
                ),
              )
            ],
          ),
        ),
      ),
          bottomNavigationBar: BottomAppBar(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 10, 10),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Cancel",
                              style: TextStyle(
                                  color: Colors.blue, fontFamily: 'Poppins'),
                            )),
                      )),
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 20, 10),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:mode != "" && selectedStudentsList.length>0 && questionsList.length>0
                                    ? Colors.orangeAccent
                                    : Colors.transparent),
                            onPressed: () async {

                              String timestamp = DateTime
                                  .now()
                                  .millisecondsSinceEpoch
                                  .toString();


                              quizToPerformModel q  = quizToPerformModel(
                                  id: timestamp,
                                  questions: questionsList,
                                  mode: mode, timestamp: timestamp, status: ''
                                  'Pending');

                            //   List<dynamic> item = [
                            //     a,
                            //     mode
                            //
                            //   ];
                            //   questionsList.forEach((element) {
                            //     item.add(element);
                            //   });
                            //
                            // selectedStudentsList.forEach((element) async {
                            //   print(element.email);
                            // });
                              if(mode != "" && selectedStudentsList.length >0 && questionsList.length >0){

                                selectedStudentsList.forEach((element) async {

                                  await FirebaseFirestore.instance.collection("students").
                                  doc(element.email).collection("Pending").doc(timestamp).set(q.toMap());

                                });


                                quizModelForAdmin q1  = quizModelForAdmin(
                                    id: timestamp,
                                    questions: questionsList,
                                    students: selectedStudentsList,
                                    mode: mode, timestamp: timestamp);
                                await FirebaseFirestore.instance.collection("admin").
                                doc("data").collection("quizes").doc(timestamp).set(q1.toMap());

                                Navigator.pushReplacement(
                                    context, MaterialPageRoute(builder: (context) => adminScreen()));

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(content: Text("Quiz Created")));

                              }
                              if(mode == ""){
                                error = "Select Mode";
                                setState(() {

                                });
                              }

                             else if(selectedStudentsList.length == 0){
                                error = "Select Students";
                                setState(() {

                                });
                              }
                             else if(questionsList.length == 0){
                                error = "Select Questions";
                                setState(() {

                                });
                              }
                             else{
                               error = "";
                               setState(() {

                               });
                              }
                              print(selectedStudentsList.length);
                              if(selectedStudentsList.length == 0){
                                // ScaffoldMessenger.of(context)
                                //     .showSnackBar(SnackBar(content: Text("Select atleast 1 Student")));

                              }


                              // await FirebaseFirestore.instance.collection("students").
                              // doc(selectedStudentsList[0].email).collection("Pending").doc(a).
                              // set({a:item},SetOptions(merge: true));



                            },
                            child: const Text(
                              "Post",
                              style: TextStyle(
                                  color: Colors.white, fontFamily: 'Poppins'),
                            )),
                      )),
                ],
              ),
            ),
          )),
    );
  }

  Future<void> addDialog(BuildContext context) {
    final TextEditingController _questioController = TextEditingController();
    final TextEditingController _opt1Controller = TextEditingController();
    final TextEditingController _opt2Controller = TextEditingController();
    final TextEditingController _opt3Controller = TextEditingController();
    final TextEditingController _opt4Controller = TextEditingController();

    final ImagePicker imagePicker = ImagePicker();
    late XFile imageFile;
    String _imageUrl = "";
    int answer = 0;
    bool isImagePicked = false;

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (thisLowerContext, innerSetState) {
            return Dialog(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Material(
                              color: Colors.grey[100],
                              child: Icon(
                                Icons.close_rounded,
                                size: 30,
                              )),
                          Text(
                            "      Add New Question",
                            style:
                                TextStyle(fontFamily: "Poppins", fontSize: 17),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                          onTap: () {},
                          child: Icon(
                            Icons.add_a_photo_outlined,
                            size: 70,
                            color: Colors.blue,
                          )),
                      SizedBox(
                        height: 40,
                      ),
                      TextField(
                        controller: _questioController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          labelText: "Statement",
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.orange[100]),
                        child: ListTile(
                          dense: true,
                          contentPadding:
                              const EdgeInsets.only(left: 15, right: 10),
                          horizontalTitleGap: 0,
                          visualDensity:
                              const VisualDensity(horizontal: 0, vertical: -4),
                          title: TextField(
                            controller: _opt1Controller,
                            decoration: InputDecoration(
                              labelText: "Option A",
                            ),
                          ),
                          trailing: answer == 1
                              ? CircleAvatar(
                                  foregroundImage:
                                      AssetImage("assets/tick.jpg"),
                                  radius: 15,
                                )
                              : InkWell(
                                  onTap: () {
                                    innerSetState(() {
                                      answer = 1;
                                    });
                                  },
                                  child: CircleAvatar(
                                    foregroundImage:
                                        AssetImage("assets/cross.jpg"),
                                    radius: 15,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue[100]),
                        child: ListTile(
                          dense: true,
                          contentPadding:
                              const EdgeInsets.only(left: 15, right: 10),
                          horizontalTitleGap: 0,
                          visualDensity:
                              const VisualDensity(horizontal: 0, vertical: -4),
                          title: TextField(
                            controller: _opt2Controller,
                            decoration: InputDecoration(
                              labelText: "Option 2",
                            ),
                          ),
                          trailing: answer == 2
                              ? CircleAvatar(
                                  foregroundImage:
                                      AssetImage("assets/tick.jpg"),
                                  radius: 15,
                                )
                              : InkWell(
                                  onTap: () {
                                    innerSetState(() {
                                      answer = 2;
                                    });
                                  },
                                  child: CircleAvatar(
                                    foregroundImage:
                                        AssetImage("assets/cross.jpg"),
                                    radius: 15,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.red[100]),
                        child: ListTile(
                          dense: true,
                          contentPadding:
                              const EdgeInsets.only(left: 15, right: 10),
                          horizontalTitleGap: 0,
                          visualDensity:
                              const VisualDensity(horizontal: 0, vertical: -4),
                          title: TextField(
                            controller: _opt3Controller,
                            decoration: InputDecoration(
                              labelText: "Option C",
                            ),
                          ),
                          trailing: answer == 3
                              ? CircleAvatar(
                                  foregroundImage:
                                      AssetImage("assets/tick.jpg"),
                                  radius: 15,
                                )
                              : InkWell(
                                  onTap: () {
                                    innerSetState(() {
                                      answer = 3;
                                    });
                                  },
                                  child: CircleAvatar(
                                    foregroundImage:
                                        AssetImage("assets/cross.jpg"),
                                    radius: 15,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.green[100]),
                        child: ListTile(
                          dense: true,
                          contentPadding:
                              const EdgeInsets.only(left: 15, right: 10),
                          horizontalTitleGap: 0,
                          visualDensity:
                              const VisualDensity(horizontal: 0, vertical: -4),
                          title: TextField(
                            controller: _opt4Controller,
                            decoration: InputDecoration(
                              labelText: "Option D",
                            ),
                          ),
                          trailing: answer == 4
                              ? CircleAvatar(
                                  foregroundImage:
                                      AssetImage("assets/tick.jpg"),
                                  radius: 15,
                                )
                              : InkWell(
                                  onTap: () {
                                    innerSetState(() {
                                      answer = 4;
                                    });
                                  },
                                  child: CircleAvatar(
                                    foregroundImage:
                                        AssetImage("assets/cross.jpg"),
                                    radius: 15,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      InkWell(
                        onTap: () async {

                          print(answer);
                          if(answer == 0){
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text("Select Correct Answer")));

                          }
                          else{
                          List a = [
                            _opt1Controller.text + "",
                            _opt2Controller.text + "",
                            _opt3Controller.text + "",
                            _opt4Controller.text + ""
                          ];

                          QuestionModel q = QuestionModel(
                              image: "",
                              statement: _questioController.text,
                              optionA: _opt1Controller.text,
                              option2: _opt2Controller.text,
                              optionC: _opt3Controller.text,
                              answer: a[answer - 1]);

                          questionsList.add(q);
                          innerSetState(() {});
                          Navigator.pop(context);
                          update();
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text("saved")));
                        }},
                        child: Material(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          elevation: 6,
                          color: Colors.blue,
                          child: Container(
                            height: 40,
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: const Text(
                              'Save Question',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontFamily: "Poppins"),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  Future<void> selectfromBankDialog(BuildContext context) {
    List<QuestionModel> tempList = [];
    tempList.addAll(questionsList);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (thisLowerContext, innerSetState) {
            return Dialog(
              child: Scaffold(
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.06,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
                          child: Autocomplete<QuestionModel>(
                            optionsMaxHeight: 10,
                            optionsViewBuilder: (context, Function onSelected,
                                Iterable<QuestionModel> options) {
                              return Align(
                                alignment: Alignment.topLeft,
                                child: Material(
                                  elevation: 10,
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width - 70,
                                    child: ListView.separated(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (context, index) {
                                        QuestionModel option = options.elementAt(index);
                                        return ListTile(
                                          title: Text(
                                            option.statement,
                                            style: const TextStyle(
                                                fontFamily: "PoppinRegular"),
                                          ),
                                          subtitle: Text(option.answer),
                                          onTap: () {
                                            if (tempList.any((element) =>
                                            element.statement ==
                                                option.statement)) {
                                              tempList.removeWhere((element) =>
                                              element.statement ==
                                                  option);
                                              questionsList.removeWhere((element) =>
                                              element.statement ==
                                                  questionsListFromBank[index].statement);

                                              innerSetState(() {});
                                            } else {
                                              tempList.add(option);
                                              innerSetState(() {});
                                            }
                                          },
                                        );
                                      },
                                      separatorBuilder: (context, index) =>
                                      const Divider(
                                        height: 0,
                                      ),
                                      itemCount: options.length,
                                    ),
                                  ),
                                ),
                              );
                            },
                            onSelected: (selectedString) {
                              print(selectedString);
                            },
                            optionsBuilder: (TextEditingValue texteditingvalue) {
                              if (texteditingvalue.text.isEmpty) {
                                return const Iterable<QuestionModel>.empty();
                              } else {

                                return questionsListFromBank.where((element) =>
                                    element.statement.toLowerCase().contains(
                                        texteditingvalue.text.toLowerCase())).toList();
                              }
                            },
                            fieldViewBuilder:
                                (context, controller, focusmode, onEditingComplete) {
                              return TextField(
                                onTapOutside: (p){
                                  controller.text = "";
                                },
                                onTap: (){

                                },
                                onSubmitted: (s){

                                },
                                onChanged: (s) {},
                                style: TextStyle(
                                    fontFamily: "PoppinRegular", color: Colors.grey[600]),
                                controller: controller,
                                focusNode: focusmode,
                                onEditingComplete: onEditingComplete,
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.only(left: 20),
                                    suffixIcon: IconButton(
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      onPressed: () {

                                      },
                                      icon: const Icon(Icons.search_outlined,color: Colors.lightBlueAccent,),
                                    ),
                                    label: const Text(
                                      "Search Question",
                                      style: TextStyle(
                                          color: Colors.orange,
                                          fontFamily: "PoppinRegular"),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    )),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Question Bank",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 20,
                            color: Colors.blue),
                      ),
                      Divider(
                        thickness: 3,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        padding: const EdgeInsets.all(0),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () async {
                              if (tempList.any((element) =>
                                  element.statement ==
                                  questionsListFromBank[index].statement)) {
                                tempList.removeWhere((element) =>
                                    element.statement ==
                                    questionsListFromBank[index].statement);
                                questionsList.removeWhere((element) =>
                                    element.statement ==
                                    questionsListFromBank[index].statement);

                                innerSetState(() {});
                              } else {
                                tempList.add(questionsListFromBank[index]);
                                innerSetState(() {});
                              }
                            },
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Material(
                                    elevation: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Q1-  ${questionsListFromBank[index].statement}",
                                            style:
                                                TextStyle(fontFamily: "Poppins"),
                                          ),
                                          Text(
                                            " 1-  ${questionsListFromBank[index].optionA}",
                                            style: TextStyle(
                                                fontFamily: "PoppinRegular"),
                                          ),
                                          Text(
                                              " 2-  ${questionsListFromBank[index].option2}"),
                                          Text(
                                              " 3-  ${questionsListFromBank[index].optionC}"),
                                             Divider(
                                            thickness: 4,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Material(
                                    elevation: 2,
                                    color: tempList.any((element) =>
                                            element.statement ==
                                            questionsListFromBank[index]
                                                .statement)
                                        ? Colors.yellow
                                        : Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Q1-  ${questionsListFromBank[index].statement}",
                                            style:
                                                TextStyle(fontFamily: "Poppins"),
                                          ),
                                          Text(
                                            " 1-  ${questionsListFromBank[index].optionA}",
                                            style: TextStyle(
                                                fontFamily: "PoppinRegular"),
                                          ),
                                          Text(
                                              " 2-  ${questionsListFromBank[index].option2}"),
                                          Text(
                                              " 3-  ${questionsListFromBank[index].optionC}"),
                                          Divider(
                                            thickness: 4,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        itemCount: questionsListFromBank.length,
                      ),
                    ],
                  ),
                ),
                bottomNavigationBar: BottomAppBar(
                  child:                       InkWell(
                    onTap: () {
                      questionsList.clear();
                      questionsList.addAll(tempList);
                      Navigator.pop(context);
                      update();
                    },
                    child: Material(
                      elevation: 6,
                      color: Colors.blue,
                      child: Container(
                        height: 40,
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: const Text(
                          'Confirm',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontFamily: "Poppins"),
                        ),
                      ),
                    ),
                  )
                  ,
                ),
              ),
            );
          });
        });
  }

  Future<void> addStudents(BuildContext context) {
    List<studentModel> tempList = [];
    tempList.addAll(selectedStudentsList);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (thisLowerContext, innerSetState) {
            return Dialog(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Students",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 20,
                          color: Colors.blue),
                    ),
                    Divider(
                      thickness: 3,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(10),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () async {

                            if (tempList.any((element) =>
                                element.email == studentsList[index].email)) {
                              tempList.removeWhere((element) =>
                                  element.email == studentsList[index].email);
                              selectedStudentsList.removeWhere((element) =>
                                  element.email == studentsList[index].email);

                              innerSetState(() {});
                            } else {
                              tempList.add(studentsList[index]);
                              innerSetState(() {});
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Material(
                              elevation: 2,
                              child: ListTile(
                                tileColor: tempList.any((element) =>
                                element.email ==
                                    studentsList[index]
                                        .email)
                                    ? Colors.yellow
                                    : Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      studentsList[index].profileImage),
                                  radius: 25,
                                ),
                                title: Text(
                                  studentsList[index].name,
                                  style: const TextStyle(
                                      fontSize: 17, fontFamily: "Poppins"),
                                ),
                                subtitle: Text(
                                  "Age:  " + studentsList[index].dateofBirth,
                                  style: const TextStyle(fontSize: 15),
                                ),
                                horizontalTitleGap: 10,
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: studentsList.length,
                    ),
                    InkWell(
                      onTap: () {
                        selectedStudentsList.clear();
                        selectedStudentsList.addAll(tempList);
                        Navigator.pop(context);
                        update();
                      },
                      child: Material(
                        elevation: 6,
                        color: Colors.blue,
                        child: Container(
                          height: 40,
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: const Text(
                            'Confirm',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontFamily: "Poppins"),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          });
        });
  }

  Future<void> getStudents() async {
    var data = await FirebaseFirestore.instance
        .collection("admin")
        .doc("data")
        .collection("students")
        .doc("allStudents")
        .collection("allStudents")
        .get(const GetOptions(source: Source.server));

    if (data.docs.isNotEmpty) {
      print("exisr");
      studentsList =
          List.from(data.docs.map((doc) => studentModel.fromSnapshot(doc)));

      setState(() {});
    } else {
      setState(() {});
    }
  }

  Future<void> getQuestions() async {
    var data = await FirebaseFirestore.instance
        .collection('questions')
        .get(const GetOptions(source: Source.server));

    if (data.docs.isNotEmpty) {
      print("exisr");
      setState(() {
        questionsListFromBank =
            List.from(data.docs.map((doc) => QuestionModel.fromSnapshot(doc)));
      });
    }
  }

  void update() {
    setState(() {});
  }
}
