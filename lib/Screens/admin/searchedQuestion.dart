import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../Models/question.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'editQuestionDialog.dart';

class searchedQuestion extends StatefulWidget {
  late List<QuestionModel> allquestionList;
  late List<QuestionModel> searchedquestionList;
  String searchText;
  searchedQuestion({Key? key,required this.allquestionList,required this.searchText,required this.searchedquestionList}) : super(key: key);

  @override
  State<searchedQuestion> createState() => _searchedQuestionState();
}

class _searchedQuestionState extends State<searchedQuestion> {
  late List<QuestionModel> questioList =[];
  bool isEndloading = false;



  @override
  void initState() {
    super.initState();
    questioList.addAll(widget.searchedquestionList);
    setState(() {

      isEndloading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
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
                "Searched Question",
                style: TextStyle(fontFamily: "Poppins", fontSize: 25),
              ),
              SizedBox(height: 20,),
               Visibility(
                 visible: widget.searchText != "",
                 child: Material(
                   borderRadius: BorderRadius.circular(10),
                   color: Colors.green.withOpacity(0.3),
                   child: Row(
                     mainAxisSize: MainAxisSize.min,
                     children: [
                       Text(
                       "    "+ widget.searchText ,
                        style: TextStyle(fontFamily: "Poppins", fontSize: 20,color: Colors.blue),
              ),
                       Text("           "),
                       InkWell(
                           onTap: (){
                             widget.searchText= "";
                             questioList.clear();
                             questioList.addAll(widget.allquestionList);
                             setState(() {

                             });
                           },
                           child: Icon(Icons.close)),
                       Text(" "),

                     ],
                   ),
                 ),
               ),
              isEndloading
                  ? ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(10),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                        elevation: 2,
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Icon(
                                    Icons.edit, color: Colors.grey[200],),
                                ),
                                Image.network(
                                  questioList[index].image, width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.6,
                                  height: MediaQuery
                                      .of(context)
                                      .size
                                      .height * 0.1,
                                ),
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
                                )
                              ],
                            )
                            ,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Icon(
                                    Icons.edit, color: Colors.transparent,),
                                ),
                                Container(
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
                                InkWell(
                                  onTap: (){
                                    _showDeleteDialog(context, questioList[index]);
                                  },

                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Icon(Icons.delete_outline_outlined,
                                      color: Colors.red,),
                                  ),
                                )
                              ],
                            )

                          ],
                        )
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
            ],
          ),
        ));
  }


  Future<void> _showEditDialog(BuildContext context, QuestionModel q) {
    return showDialog(
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
                    },
                      child: const Text("Yes", style: TextStyle(
                          color: Colors.grey, fontFamily: "Poppins")),),
                  ],
                )
        )
    );


  }
}