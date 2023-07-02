
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../Models/QuizModel.dart';
import 'dart:math' as math;

import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/QuizModelForAdmin.dart';
import 'Created_quiz_Detail.dart';
import 'createQuiz.dart';

class Admin_quiz_MainmenuScreen extends StatefulWidget {
  const Admin_quiz_MainmenuScreen({Key? key}) : super(key: key);

  @override
  State<Admin_quiz_MainmenuScreen> createState() => _Admin_quiz_MainmenuScreenState();
}

class _Admin_quiz_MainmenuScreenState extends State<Admin_quiz_MainmenuScreen> {

  List<quizModelForAdmin> pendingQuizesList=[];
  late List<quizModel> quizesList;
  bool isLoading = true;
  bool hasData = false;
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
                  SizedBox(height: 30,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Quizes",
                        style: TextStyle(fontFamily: "Poppins", fontSize: 30),
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      create_quiz()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            elevation: 10,
                            color: Colors.orange,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                              child: Row(
                                children: const [
                                  Icon(Icons.create_new_folder_outlined,color: Colors.lightBlue,),
                                  Text(
                                    " Create Quiz ",
                                    style: TextStyle(
                                        fontFamily: "Poppins", fontSize: 14),
                                  ),
                                ],
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
                  hasData
                      ? ListView.builder(
                    reverse: true,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () async {
                          Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      created_quiz_detail(quiz: pendingQuizesList[index], quizno: (index+1).toString(),)));
                        },
                        child: containerItem(index),
                      );
                    },
                    itemCount: pendingQuizesList.length,
                  )
                      : const Text(
                    "No Quiz to show",
                    style: TextStyle(
                        fontFamily: "PoppinRegular",
                        fontSize: 20,
                        color: Colors.blue),
                  ):

                  Container(
                    height: MediaQuery.of(context).size.height*0.4,
                    margin: const EdgeInsets.only(bottom: 120),
                    child: Center(
                      child: Center(
                        child: Stack(
                          children: [

                            const SizedBox(
                                width: 50,
                                height: 50,

                                child: CircularProgressIndicator()),
                            SizedBox(
                                width: 50,
                                height: 50,

                                child: Center(
                                  child: Transform(
                                    alignment: Alignment.center,
                                    transform: Matrix4.rotationY(math.pi),
                                    child: const SizedBox(
                                      width:30,
                                      height: 30,

                                      child: CircularProgressIndicator(


                                      ),
                                    ),
                                  ),
                                )),

                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30,),

                ],
              ),
            ),
          )),
    );
  }

  Widget containerItem(int i) {
    // var d = DateTime.fromMicrosecondsSinceEpoch(int.parse(quizesList[i].date));
    // var a = DateFormat('dd-MM-yyyy').format(d);
    // var t = DateFormat('hh:mm').format(d);

    return Padding(
      padding: const EdgeInsets.only(bottom: 15,right: 0,left: 0),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        elevation: 10,
        clipBehavior: Clip.antiAlias,
        child: Container(
            color: Color(0xff00aeff).withOpacity(0.4),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
            height: MediaQuery.of(context).size.height * 0.1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Quiz #",style: TextStyle(fontFamily: "Poppins"),),
                    Text((i+1).toString(),style: TextStyle(fontFamily: "Poppins",color: Colors.deepOrange,fontSize: 16),),
                  ],
                ),
                VerticalDivider(thickness: 2,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Mode",style: TextStyle(fontFamily: "Poppins"),),
                    Text(pendingQuizesList[i].mode,style: TextStyle(color: Colors.green,fontFamily: "Poppins",fontSize: 16),),
                  ],
                ),
                VerticalDivider(thickness: 2,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Questions",style: TextStyle(fontFamily: "Poppins"),),
                    Text(pendingQuizesList[i].questions.length.toString(),style: TextStyle(fontFamily: "Poppins",fontSize: 16),),
                  ],
                ),
                VerticalDivider(thickness: 2,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Students",style: TextStyle(fontFamily: "Poppins"),),
                    Text(pendingQuizesList[i].students.length.toString(),style: TextStyle(fontFamily: "Poppins",fontSize: 18,color: Colors.blue),),
                  ],
                )
              ],
            )
        ),
      ),
    );
  }

  Future<void> getQuizes() async {

    await init();
    print(email);
    var querySnapshot = await FirebaseFirestore.instance.collection("admin").
    doc("data").collection("quizes").get().then((value) => {
      value.docs.forEach((element) {
        quizModelForAdmin m  = quizModelForAdmin(
            id: element['id'],
            questions: element['questions'],
            mode: element['mode'], students: element['students'], timestamp: element['timestamp']);


        pendingQuizesList.add(m);
        print(pendingQuizesList.length);
      })

    });


    if( pendingQuizesList.length>0){
      isLoading = false;
      hasData = true;
    }
    setState(() {

    });

  }
}
