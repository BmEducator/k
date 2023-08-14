
import 'dart:io';

import 'package:bmeducators/Models/QuizModelForBank.dart';
import 'package:bmeducators/Screens/admin/quiz_numbers_screen.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:math' as math;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:intl/intl.dart';



import '../../Models/QuizModelForAdmin.dart';
import '../../Models/QuizToPerformModel.dart';
import '../../Models/question.dart';
import '../../Models/studentModel.dart';
import '../../services_Screen/addQuestioninQuizInQuestionBank.dart';
import 'admin_Screen.dart';

class createQuizInBank extends StatefulWidget {
  String familyName;
  int QuizNo;
   createQuizInBank({Key? key,required this.familyName,required this.QuizNo}) : super(key: key);

  @override
  State<createQuizInBank> createState() => _createQuizInBankState();
}

class _createQuizInBankState extends State<createQuizInBank> {
  String mode = "";
  String error = "";
  var modes = ["","Study", "Exam"];
  final ImagePicker imagePicker = ImagePicker();
  late XFile imageFile;
  bool isImagePicked = false;
  bool isCreating = false;


  List<QuestionModel> questionsList = [];
  List<QuestionModel> tempList = [];
  List<QuestionModel> toDeleteQuestionList = [];





  @override
  void initState() {

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
              Text("Are you sure to discard?",
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
      child:!isCreating? Scaffold(
        backgroundColor: Colors.white,
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
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Create |",
                        style: TextStyle(fontFamily: "Poppins", fontSize: 25),
                      ),
                      InkWell(
                        onTap: () {
                          error = "";
                          setState(() {

                          });
                          var f =    addDialog(context);
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
                ),
                        Divider(thickness: 2),

                ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () async {},
                      child: Column(
                        children: [
                          Material(
                            color: Colors.grey[100],
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Stack(
                                alignment: Alignment.topRight,
                                children:[
                                  Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Visibility(
                                      visible:questionsList[index].image != "",
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.file(File(questionsList[index].image),
                                          height: MediaQuery.of(context).size.height * 0.13,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    Row(
                                      children: [
                                        Text("Q ${index+1})  ",style: TextStyle(fontFamily: "Poppins",color: Colors.deepPurpleAccent,fontSize: 16),),
                                        Text(
                                         questionsList[index].statement,
                                          maxLines: 3,
                                          style: TextStyle(fontFamily: "Poppins"),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10,),

                                    Row(
                                      children: [
                                        Text("a)   ",style: TextStyle(fontFamily: "Poppins",color: Colors.blue),),
                                        Text(
                                        questionsList[index].optionA,
                                          style: TextStyle(fontFamily: "PoppinRegular"),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 3,),

                                    Row(
                                      children: [
                                        Text("b)   ",style: TextStyle(fontFamily: "Poppins",color: Colors.blue),),

                                        Text(questionsList[index].option2),
                                      ],
                                    ),
                                    SizedBox(height: 3,),
                                    Row(
                                      children: [
                                        Text("c)   ",style: TextStyle(fontFamily: "Poppins",color: Colors.blue),),

                                        Text(questionsList[index].optionC),
                                      ],
                                    ),
                                    SizedBox(height: 3,),
                                    Visibility(
                                      visible: questionsList[index].optionD != "",
                                      child: Row(
                                        children: [
                                          Text("d)   ",style: TextStyle(fontFamily: "Poppins",color: Colors.blue),),

                                          Text(questionsList[index].optionD),
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                                  InkWell(
                                    onTap: (){
                                      print(tempList[index].image);
                                      if(tempList[index].image != ""){
                                      FirebaseStorage.instance.refFromURL(tempList[index].image).delete();
                                      }
                                      tempList.removeWhere((element) => element.statement == questionsList[index].statement);
                                      questionsList.removeWhere((element) => element.statement == questionsList[index].statement);
                                      setState(() {

                                      });
                                    },
                                    child: Material(
                                      color: Colors.black.withOpacity(0.4),
                                      child: Icon(Icons.close,color: Colors.white,),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 10,)
                        ],
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
                                backgroundColor: Colors.orangeAccent),
                            onPressed: () async {
                              isCreating = true;
                              setState(() {

                              });
    String timestamp = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();


    quizModelForBank q  = quizModelForBank(
    id: timestamp,
    questions: tempList,
    mode: mode, timestamp: timestamp,
    );
    await FirebaseFirestore.instance.collection("admin").
    doc("data").collection("QuizBank")
        .doc("Families").collection(widget.familyName)
        .doc(timestamp).set(q.toMap());

    isCreating = false;
    setState(() {

    });
    _showFinishDialog();
                            }
                            ,
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
          )
    );
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
    bool answerSelected = true;


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
                                      answerSelected = true;

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
                              labelText: "Option B",
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
                                      answerSelected = true;

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
                                      answerSelected = true;

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
                      SizedBox(height: 15,),

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
                                answerSelected = true;

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
                      SizedBox(height: 15,),
                      Visibility(
                        visible: !answerSelected,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(" * Select Answer",style: TextStyle(fontFamily: "Poppins",fontSize: 16,color: Colors.red),),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 34,
                      ),

                      InkWell(
                        onTap: () async {

                          print(answer);
                          if(answer == 0){
                            innerSetState((){
                              answerSelected = false;
                            });
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
                              answer: a[answer - 1], optionD: _opt4Controller.text);

                          questionsList.add(q);
                          innerSetState(() {});
                          Navigator.pop(context);
                          update(q);
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

  Future<XFile> selectImage() async {
    final XFile? selectedImages = (await imagePicker.pickImage(
        imageQuality: 10, source: ImageSource.gallery));
    // imageFileList.add(selectedImages!);
    XFile File = selectedImages!;

    return File;
  }

  Future uploadImage(String path,String id) async {

    XFile f = XFile(path);
    final Reference storageReference = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('Quizes/${id}/pictures ( ${f.name}.path)');

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



  Future<void> uploadImages()async {
  }
  Future<void> update(QuestionModel q) async {
    setState(() {});

    if(q.image ==""){
      tempList.add(q);
    }
    else{
      await updateImage(questionsList.last.image,q);
    }
    setState(() {});

  }

  Future<void> updateImage(String p, QuestionModel q) async {
    print("hasimage");
    print(p!="");
    if(p!=""){
      String url = await uploadImage(p,"QuizNo " +widget.QuizNo.toString());
      QuestionModel temp = QuestionModel(
          image: url,
          statement: q.statement,
          optionA:q.optionA,
          option2: q.option2,
          optionC: q.optionC,
          answer: q.answer, optionD: q.optionD);
      tempList.add(temp);
      print("uploaded");
    }
    setState(() {});
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
                    "Your Quiz has been Created....",
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
                            context, MaterialPageRoute(builder: (context) => quizNoScreen(familyName: widget.familyName)));
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
