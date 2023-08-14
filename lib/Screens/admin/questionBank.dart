import 'dart:io';

import 'package:bmeducators/Screens/admin/add_Question_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../Models/question.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'editQuestionDialog.dart';

class questionBank extends StatefulWidget {
  const questionBank({Key? key}) : super(key: key);

  @override
  State<questionBank> createState() => _questionBankState();
}

class _questionBankState extends State<questionBank> {
  late List<QuestionModel> questioList;

  bool isEndLoading = false;

  @override
  void initState() {
    super.initState();
    getQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 35, 10, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(onPressed: () {
                      Navigator.pop(context);
                    },
                        icon: const Icon(
                          Icons.arrow_back_ios, color: Colors.blue,)),
                  ],
                ),
              ),

              const Text(
                "Question Bank",
                style: TextStyle(fontFamily: "Poppins", fontSize: 25),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    addQuestio(is4Option: true,)));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          elevation: 4,
                          color: Colors.blue[900],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: const [
                                Icon(Icons.add_circle,color: Colors.white,),
                                Text(
                                  " Add New Question   ",
                                  style: TextStyle(
                                      fontFamily: "Poppins", fontSize: 14,color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],),
              ),

              Divider(thickness: 4,),

              SizedBox(
                height: 10,
              ),
              isEndLoading
                  ? ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                    child: Material(
                      color: Colors.grey[200],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: 20,
                          child: Text("   ${index+1}",style: TextStyle(color: Colors.blue),),),
                          Column(children: [
                            Visibility(
                              visible: questioList[index].image != "",
                              child: Image.network(
                                questioList[index].image, width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.6,
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height * 0.1,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.7,

                              child: Text(questioList[index].statement
                                , style: TextStyle(
                                    fontFamily: "PoppinRegular"),
                                maxLines: 2,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],),

                          Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  _showEditDialog(
                                      context, questioList[index]);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Icon(
                                    Icons.edit, color: Colors.blue,),
                                ),
                              ),

                              InkWell(
                                onTap: () async {
                                  //
                                  // DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
                                  //
                                  //
                                  // if(Platform.isAndroid){
                                  //   AndroidDeviceInfo info = await deviceInfoPlugin.androidInfo;
                                  //
                                  //   print(info.model);
                                  // }
                                  // else if(Platform.isIOS){
                                  //   IosDeviceInfo data =await deviceInfoPlugin.iosInfo;
                                  //   print(data.utsname.machine);
                                  // }

                                  _showDeleteDialog(context, questioList[index]);
                                },

                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Icon(Icons.delete_outline_outlined,
                                    color: Colors.red,),
                                ),
                              )
                            ],
                          ),


                        ],
                      ),
                    ),



                  );
                },
                itemCount: questioList.length,
              )
                  : Container(
                margin: EdgeInsets.symmetric(horizontal: 0, vertical: 150),
                child: Center(
                  child: Center(
                    child: Stack(
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
                  ),
                ),
              ),

              SizedBox(height: 130,),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(onPressed: (){
          Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) =>
                      addQuestio(is4Option: true,)));

        },
        child: Icon(Icons.add,),

        ),
    );
  }

  Future<void> getQuestions() async {
    var data = await FirebaseFirestore.instance
        .collection('questions')
        .get(const GetOptions(source: Source.server));

    if (data.docs.isNotEmpty) {
      print("exisr");
      setState(() {
        questioList =
            List.from(data.docs.map((doc) => QuestionModel.fromSnapshot(doc)));
        isEndLoading = true;
      });
    }
  }

  Future<void> _showEditDialog(BuildContext context, QuestionModel q) {
    return showDialog(
      barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(

              contentPadding: EdgeInsets.zero,
              content: editQuestion(questionModel: q));
        });
  }

  Future<void>? _showDeleteDialog(BuildContext context, QuestionModel q) async {
    return (
        await showDialog(context: context,
        builder: (context)
    =>
        AlertDialog(
          content: const Text("Do you want to delete?",
            style: TextStyle(fontFamily: "PoppinRegular"),),
          actions: [
            TextButton(onPressed: () {
              Navigator.pop(context);
            },
              child: const Text(
                  "No", style: TextStyle(fontFamily: "Poppins")),),
            TextButton(onPressed: () {
              FirebaseFirestore.instance.collection("questions").doc(q.statement).delete();
              questioList.removeWhere((element) => element.statement == q.statement);
              setState(() {

              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("Question Deleted")));
            },
              child: const Text("Yes", style: TextStyle(
                  color: Colors.grey, fontFamily: "Poppins")),),
          ],
        )
    )
    );


  }
}