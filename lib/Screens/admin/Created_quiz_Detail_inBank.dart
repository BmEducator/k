
import 'dart:io';

import 'package:bmeducators/Models/QuizToPerformModel.dart';
import 'package:bmeducators/Screens/admin/quizPreview.dart';
import 'package:bmeducators/Screens/admin/quiz_numbers_screen.dart';
import 'package:bmeducators/Screens/admin/student_statistics_Screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'dart:math' as math;


import '../../Models/QuizModelForAdmin.dart';
import '../../Models/QuizModelForBank.dart';
import '../../Models/question.dart';
import '../../Models/studentModel.dart';
import 'admin_Screen.dart';
import 'editQuestionDialog.dart';

class quizDetailInBank extends StatefulWidget {
  quizModelForBank  quiz;
  int quizno;
  String familyname;
  quizDetailInBank({Key? key,required this.quiz,required this.quizno,required this.familyname}) : super(key: key);

  @override
  State<quizDetailInBank> createState() => _quizDetailInBankState();
}

class _quizDetailInBankState extends State<quizDetailInBank> {
  String mode = "Study";
 bool isCreating = false;

  List<QuestionModel> questionsList = [];

  final ImagePicker imagePicker = ImagePicker();
  bool isImagePicked = false;
  String _imageUrl = "";
  var imageFile;
  List<String> questionsWithImagePicked = [];


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
  }

  @override
  Widget build(BuildContext context) {
    return !isCreating? Scaffold(
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
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Quiz No ${widget.quizno}",
                            style: TextStyle(fontFamily: "Poppins", fontSize: 25),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(new MaterialPageRoute<Null>(
                                  builder: (BuildContext context) {
                                    return new previewQuiz(
                                        questionList: questionsList,
                                        isLanguageTranslation: "false",

                                        isShuffle: true,
                                        selecteddataList: [], newlyAddedQuestion:questionsWithImagePicked,);
                                  },
                                  fullscreenDialog: true));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Material(
                                elevation: 4,
                                color: Colors.grey[200],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: const [
                                      Text(
                                        "   Preview  ",
                                        style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 14,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),


                        ],
                      ),
                    ),

                    Divider(thickness: 2),

                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Questions",
                          style: TextStyle(fontFamily: "Poppins", fontSize: 20,color: Colors.blue),
                        ),
                        InkWell(
                          onTap: () {

                            setState(() {

                            });
                            var f =  addDialog(context);
                            print(f);

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
                                      "   Add Question  ",
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 12,
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
                    Divider(thickness: 3,endIndent: 230,),
                    SizedBox(height: 10,),
                  ],
                ),

                ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),

                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Stack(
                        children: [
                          Material(
                            elevation: 4,
                            color: Colors.grey[200],
                            child: Padding(
                              padding: const EdgeInsets.all(0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Visibility(
                                    visible:questionsList[index].image != "" && !questionsWithImagePicked.contains(questionsList[index].statement),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,

                                      children: [
                                        Image.network(questionsList[index].image,
                                          height: MediaQuery.of(context).size.height * 0.13,
                                          errorBuilder: (BuildContext context,Object exception,StackTrace? stackTrace){
                                            return CircularProgressIndicator();
                                          },
                                          loadingBuilder: (BuildContext context, Widget child,
                                              ImageChunkEvent? loadingProgress) {
                                            if (loadingProgress == null) return child;
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value: loadingProgress.expectedTotalBytes != null
                                                    ? loadingProgress.cumulativeBytesLoaded /
                                                    loadingProgress.expectedTotalBytes!
                                                    : null,
                                              ),
                                            );
                                            },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible:questionsWithImagePicked.contains(questionsList[index].statement) && questionsList[index].image != "",
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,

                                      children: [
                                        Image.file(File(questionsList[index].image),
                                          height: MediaQuery.of(context).size.height * 0.13,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width ,
                                    child:  ListTile(
                                      dense: true,
                                      contentPadding: EdgeInsets.symmetric(horizontal: 5),
                                      horizontalTitleGap: -10,
                                      leading: Text("Q${index+1})  ",style: TextStyle(fontFamily: "Poppins"),),
                                      title: Text(
                                          questionsList[index].statement,
                                        style: TextStyle(fontFamily: "Poppins"),
                                      ),

                                    )),

                                  Container(
                                      width: MediaQuery.of(context).size.width ,
                                      padding: EdgeInsets.zero,
                                      child:  ListTile(
                                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                        dense: true,
                                        visualDensity: VisualDensity(horizontal: 0,vertical: -4),
                                        horizontalTitleGap: -15,
                                        leading: Text("a) ",style: TextStyle(fontFamily: "Poppins",color: Colors.blue),),
                                        title: Text(
                                          questionsList[index].optionA,
                                          style: TextStyle(fontFamily: "PoppinRegular"),
                                        ),

                                      )),
                                  Container(
                                      width: MediaQuery.of(context).size.width ,
                                      padding: EdgeInsets.zero,
                                      child:  ListTile(
                                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                        dense: true,
                                        visualDensity: VisualDensity(horizontal: 0,vertical: -4),
                                        horizontalTitleGap: -15,
                                        leading: Text("b) ",style: TextStyle(fontFamily: "Poppins",color: Colors.blue),),
                                        title: Text(
                                          questionsList[index].option2,
                                          style: TextStyle(fontFamily: "PoppinRegular"),
                                        ),

                                      )),
                                  Container(
                                      width: MediaQuery.of(context).size.width ,
                                      padding: EdgeInsets.zero,
                                      child:  ListTile(
                                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                        dense: true,
                                        visualDensity: VisualDensity(horizontal: 0,vertical: -4),
                                        horizontalTitleGap: -15,
                                        leading: Text("c) ",style: TextStyle(fontFamily: "Poppins",color: Colors.blue),),
                                        title: Text(
                                          questionsList[index].optionC,
                                          style: TextStyle(fontFamily: "PoppinRegular"),
                                        ),

                                      )),

                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            right: 10,
                            top: 5,
                            child: InkWell(
                                onTap: (){
                                  _showEditDialog(context, questionsList[index],index);

                                },
                                child: Icon(Icons.mode_edit_outline_outlined,color: Colors.blueGrey,)),
                          ),

                          Positioned(
                            right: 10,
                            bottom: 5,
                            child: InkWell(
                                onTap: (){
                                    _showDeleteDialog(context, questionsList[index],index);
                                },
                                child: Icon(Icons.delete_outline,color: Colors.red,)),
                          ),

                        ],
                      ),
                    );
                  },
                  itemCount: questionsList.length,
                ),
                SizedBox(height: 30,),

              ]),
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
                              backgroundColor: Colors.orangeAccent),
                          onPressed: () async {
                            isCreating = true;
                            setState(() {

                            });
                            List<QuestionModel> tempList = [];

                            if(questionsWithImagePicked.isNotEmpty){
                              for(int i= 0;i<questionsList.length;i++){
                                if(questionsWithImagePicked.contains(questionsList[i].statement) ){

                                  if(questionsList[i].image !=""){
                                    print(questionsList[i].statement);
                                    String url = await uploadImage(questionsList[i].image);
                                    tempList.add(QuestionModel(image: url, statement: questionsList[i].statement,

                                        optionA: questionsList[i].optionA, option2: questionsList[i].option2,
                                        optionC: questionsList[i].optionC, answer: questionsList[i].answer));

                                  }
                                  else {
                                    String url = "";
                                    tempList.add(QuestionModel(image: url, statement: questionsList[i].statement,

                                        optionA: questionsList[i].optionA, option2: questionsList[i].option2,
                                        optionC: questionsList[i].optionC, answer: questionsList[i].answer));

                                  }
                                }
                                else{
                                  tempList.add(questionsList[i]);
                                }
                                if(i == (questionsList.length-1)){
                                  quizModelForBank q  = quizModelForBank(
                                    id: widget.quiz.id,
                                    questions: tempList,
                                    mode: mode, timestamp: widget.quiz.timestamp,
                                  );
                                  await FirebaseFirestore.instance.collection("admin").
                                  doc("data").collection("QuestionBank")
                                      .doc("Families").collection(widget.familyname)
                                      .doc(widget.quiz.timestamp).set(q.toMap());

                                  isCreating = false;
                                  setState(() {

                                  });
                                  _showFinishDialog();


                                }


                              }

                            }
                            else{
                              tempList.addAll(questionsList);
                              quizModelForBank q  = quizModelForBank(
                                id: widget.quiz.id,
                                questions: tempList,
                                mode: mode, timestamp: widget.quiz.timestamp,
                              );
                              await FirebaseFirestore.instance.collection("admin").
                              doc("data").collection("QuestionBank")
                                  .doc("Families").collection(widget.familyname)
                                  .doc(widget.quiz.timestamp).set(q.toMap());

                              isCreating = false;
                              setState(() {

                              });
                              _showFinishDialog();
                            }
                          },
                          child: const Text(
                            "Save",
                            style: TextStyle(
                                color: Colors.white, fontFamily: 'Poppins'),
                          )),
                    )),
              ],
            ),
          ),
        )
      ):
    Scaffold(
      body:     Container(
        margin: EdgeInsets.only(bottom: 100),
        child: Center(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                Text("Creating",style: TextStyle(fontFamily: "Poppins",fontSize: 28),)
              ],
            ),
          ),
        ),
      ),
    );
  }



  Future<void> _showEditDialog(BuildContext context, QuestionModel question,int index) {
    bool isLoading = false;
    final TextEditingController _questioController = TextEditingController();
    final TextEditingController _opt1Controller = TextEditingController();
    final TextEditingController _opt2Controller = TextEditingController();
    final TextEditingController _opt3Controller = TextEditingController();

    String answer = "";
    _questioController.text = question.statement;
    _opt1Controller.text = question.optionA;
    _opt2Controller.text = question.option2;
    _opt3Controller.text = question.optionC;
    _imageUrl = question.image;
    answer = question.answer;


    XFile? imageile;
    bool isImagePick = false;


    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (thisLowerContext, innerSetState) {
            return Dialog(
              child: SingleChildScrollView(
                child: isLoading?
                Center(
                  child: Column(
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height*0.25,),
                      CircularProgressIndicator(),
                      SizedBox(height: 20,),
                      Text("Updating....",style: TextStyle(fontFamily: "Poppins",color: Colors.orange,fontSize: 18),)
                    ],
                  ),)
                    : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.close,color: Colors.transparent,),
                          const Text(
                            "Edit Question",
                            style: TextStyle(fontFamily: "Poppins", fontSize: 20),
                          ),
                          InkWell(
                              onTap: (){
                                Navigator.of(context,rootNavigator: true).pop();

                              },
                              child: Icon(Icons.close))
                        ],
                      ),
                      // Visibility(
                      //   visible: questionsWithImagePicked.contains(index) ,
                      //   child: InkWell(
                      //       onTap: () async {
                      //         imageile =  await selectImage();
                      //         isImagePick = true;
                      //         innerSetState((){
                      //
                      //         });
                      //       },
                      //       child:Image.file(File(question.image),fit: BoxFit.fitWidth,
                      //         height:  MediaQuery.of(context).size.height * 0.15,width:  MediaQuery.of(context).size.width,)
                      //   ),
                      // ),

                      question.image == "" && !isImagePick?
                      InkWell(
                        onTap: () async {
                          imageile =  await selectImage();
                          isImagePick = true;
                          innerSetState((){

                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: CircleAvatar(
                              radius: 30,
                              child: Icon(Icons.add_a_photo,size: 30,)),
                        ),


                      ):
                          Text(""),


                      isImagePick?
                      InkWell(
                          onTap: () async {
                            imageile =  await selectImage();
                            isImagePick = true;
                            innerSetState((){

                            });
                          },
                          child:Image.file(File(imageile!.path),fit: BoxFit.fitHeight,
                            height:  MediaQuery.of(context).size.height * 0.15,
                            width:  MediaQuery.of(context).size.width,)
                      ):
                          Text(""),

                      Visibility(
                        visible: !isImagePick,
                        child:
                        question.image !="" && !questionsWithImagePicked.contains(questionsList[index].statement) ?
                        InkWell(
                        onTap: () async {
                          imageile =  await selectImage();
                          isImagePick = true;
                          innerSetState((){

                          });
                        },
                        child:
                        Image.network(question.image, height:  MediaQuery.of(context).size.height * 0.15,width:  MediaQuery.of(context).size.width,),
                      ):
                        InkWell(
                        onTap: () async {
                          imageile =  await selectImage();
                          isImagePick = true;
                          innerSetState((){

                          });
                        },
                        child:

                        question.image !="" && questionsWithImagePicked.contains(questionsList[index].statement) ?
                        Image.file(File(question.image), height:  MediaQuery.of(context).size.height * 0.15,
                          width:  MediaQuery.of(context).size.width,):
                            Text(""),
                      ),
                      ),






                      // InkWell(
                      //     onTap: () async {
                      //       imageile =  await selectImage();
                      //       isImagePick = true;
                      //       innerSetState((){
                      //
                      //       });
                      //     },
                      //     child:!isImagePick &&
                      //     _imageUrl !="" && !questionsWithImagePicked.contains(index) ?
                      //     Image.network(_imageUrl, height:  MediaQuery.of(context).size.height * 0.15,width:  MediaQuery.of(context).size.width,):
                      //     !questionsWithImagePicked.contains(index)?
                      //     Icon(Icons.add_a_photo):
                      //     Image.file(File(imageile!.path),fit: BoxFit.fitWidth,
                      //       height:  MediaQuery.of(context).size.height * 0.15,width:  MediaQuery.of(context).size.width,)
                      //     ),
                      SizedBox(height: 20,),
                      TextField(
                        maxLines: 3,
                        controller: _questioController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          labelText: "Statement",
                        ),
                      ),
                      const SizedBox(
                        height: 15,
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
                          visualDensity: const VisualDensity(
                              horizontal: 0, vertical: -4),
                          title:  TextField(
                            controller: _opt1Controller,
                            decoration: InputDecoration(
                              labelText: "Option A",
                            ),
                          ),
                          trailing:
                          answer == _opt1Controller.text?
                          CircleAvatar(
                            foregroundImage: AssetImage("assets/tick.jpg"),
                            radius: 15,
                          )
                              :InkWell(
                            onTap: (){
                              innerSetState(() {
                                answer  = _opt1Controller.text;
                              });
                            },
                            child: CircleAvatar(
                              foregroundImage: AssetImage("assets/cross.jpg"),
                              radius: 15,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
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
                          visualDensity: const VisualDensity(
                              horizontal: 0, vertical: -4),
                          title:  TextField(
                            controller: _opt2Controller,
                            decoration: InputDecoration(
                              labelText: "Option 2",
                            ),
                          ),
                          trailing: answer == _opt2Controller.text?
                          CircleAvatar(
                            foregroundImage: AssetImage("assets/tick.jpg"),
                            radius: 15,
                          )
                              :InkWell(
                            onTap: (){
                              innerSetState(() {
                                answer  = _opt2Controller.text;
                              });
                            },
                            child: CircleAvatar(
                              foregroundImage: AssetImage("assets/cross.jpg"),
                              radius: 15,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
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
                          visualDensity: const VisualDensity(
                              horizontal: 0, vertical: -4),
                          title:  TextField(
                            controller: _opt3Controller,
                            decoration: InputDecoration(
                              labelText: "Option C",
                            ),
                          ),
                          trailing: answer == _opt3Controller.text?
                          CircleAvatar(
                            foregroundImage: AssetImage("assets/tick.jpg"),
                            radius: 15,
                          )
                              :InkWell(
                            onTap: (){
                              innerSetState(() {
                                answer  = _opt3Controller.text;
                              });
                            },
                            child: CircleAvatar(
                              foregroundImage: AssetImage("assets/cross.jpg"),
                              radius: 15,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),




                      InkWell(
                        onTap: (){

                          String path  = "";
                          if(imageile != null){
                            path = imageile!.path;
                          }

                          if(isImagePick) {
                            if (questionsWithImagePicked.contains(
                                questionsList[index].statement)) {
                              questionsWithImagePicked.removeWhere((
                                  element) => element == question.statement);
                            }

                            questionsWithImagePicked.add(
                                _questioController.text);
                          }

                          QuestionModel q = QuestionModel(
                              image: path,
                              statement: _questioController.text,
                              optionA: _opt1Controller.text,
                              option2: _opt2Controller.text,
                              optionC: _opt3Controller.text,
                              answer: answer);
                          questionsList[index] = q;
                          Navigator.pop(context);
                          update();

                        },
                        child: Material(
                          borderRadius: const BorderRadius.all(
                              Radius.circular(8)),
                          elevation: 6,
                          color: Colors.blue,
                          child: Container(
                            height: 40,
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: const Text(
                              'Save Question',
                              style: TextStyle(color: Colors.white,
                                  fontSize: 17,fontFamily: "Poppins"),
                            )
                            ,
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



  Future<void>? _showDeleteDialog(BuildContext context, QuestionModel q,int index) async {
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
                      questionsList.removeWhere((element) => element.statement == q.statement);
                      questionsWithImagePicked.removeWhere((element) => element == q.statement);
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

  void update() {
    setState(() {});
  }

  Future<XFile> selectImage() async {
    final XFile? selectedImages = (await imagePicker.pickImage(
        imageQuality: 10, source: ImageSource.gallery));
    // imageFileList.add(selectedImages!);
    XFile File = selectedImages!;

    return File;
  }


  Future<void> addDialog(BuildContext context) {
    final TextEditingController _questioController = TextEditingController();
    final TextEditingController _opt1Controller = TextEditingController();
    final TextEditingController _opt2Controller = TextEditingController();
    final TextEditingController _opt3Controller = TextEditingController();
    final TextEditingController _opt4Controller = TextEditingController();

    final ImagePicker imagePicker = ImagePicker();

    XFile? imageile;
    String _imageUrl = "";
    int answer = 0;
    bool isImagePick = false;


    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (thisLowerContext, innerSetState) {
            return Dialog(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Material(
                                color: Colors.grey[100],
                                child: Icon(
                                  Icons.close_rounded,
                                  size: 30,
                                )),
                          ),
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
                          onTap: () async{

                            imageile =  await selectImage();
                            isImagePick = true;
                            innerSetState((){

                            });
                          },
                          child:!isImagePick ? Icon(Icons.add_a_photo_outlined,size: 70,color: Colors.blue,)
                              :Image.file(File(imageile!.path),fit: BoxFit.fitWidth,height:  MediaQuery.of(context).size.height * 0.2,width:  MediaQuery.of(context).size.width,)
                      ),
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
                        height: 44,
                      ),

                      InkWell(
                        onTap: () async {
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

                            String path  = "";
                            if(imageile != null){
                              path = imageile!.path;
                            }

                            QuestionModel q = QuestionModel(
                                image:path,
                                statement: _questioController.text,
                                optionA: _opt1Controller.text,
                                option2: _opt2Controller.text,
                                optionC: _opt3Controller.text,
                                answer: a[answer - 1]);

                            questionsList.add(q);
                              questionsWithImagePicked.add(
                                  _questioController.text);

                            innerSetState(() {});
                            Navigator.pop(context);
                            update();

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

  Future uploadImage(String path) async {

    final Reference storageReference = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('profileImage/(${path}.path)');

    String downloadURL;
    final uploadTask = storageReference.putFile(File(path));
    uploadTask.snapshotEvents.listen((event) {
      switch (event.state) {
        case TaskState.running:
          final p = 100.0 * (event.bytesTransferred / event.totalBytes);
          print("prog $p");
          break;

        case TaskState.paused:
          print("paused");
          break;

        case TaskState.success:
          print("succ");
          break;
        case TaskState.canceled:
          print("cancek");
          break;
        case TaskState.error:
          print("errr");
          break;
      }
    });

    downloadURL = await (await uploadTask).ref.getDownloadURL();
    return downloadURL;
  }


  Future<void> _showFinishDialog() {
    return
      showModalBottomSheet(
          backgroundColor: Colors.transparent,
          constraints: BoxConstraints(
              maxWidth:
              MediaQuery
                  .of(context)
                  .size
                  .width -
                  20),
          isDismissible: false,
          elevation: 20,
          context: context,
          builder: (context) {
            return Container(
              margin: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.circular(20)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 60,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Your Quiz has been Updated....",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 18),
                  ),

                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 70),
                    child: InkWell(
                      onTap: () async {
                        Navigator.pushReplacement(
                            context, MaterialPageRoute(builder: (context) => quizNoScreen(familyName: widget.familyname)));
                      },

                      child: Material(
                        borderRadius:
                        const BorderRadius.all(
                            Radius.circular(8)),
                        elevation: 6,
                        color: Colors.yellow,
                        child: Container(
                            height: 40,
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: Text(
                              'Continue',
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: Colors.black,
                                  fontSize: 17),
                            )),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            );
          });
  }

}
