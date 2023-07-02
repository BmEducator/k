import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math' as math;
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

import '../../Models/QuizToPerformModel.dart';
import '../../Models/question.dart';
import '../../services_Screen/photoView.dart';


class previewQuiz extends StatefulWidget {
  List<int> selecteddataList;
  bool isShuffle;
  List<QuestionModel> questionList;
  List<String> newlyAddedQuestion;
  String  isLanguageTranslation;
  previewQuiz({Key? key,required this.questionList,required this.newlyAddedQuestion, required this.isLanguageTranslation,required this.isShuffle,
    required this.selecteddataList}) : super(key: key);

  @override
  State<previewQuiz> createState() => _previewQuizState();
}

class _previewQuizState extends State<previewQuiz> {
  bool isOptioSelected = false;
  bool isLoaded = false;
  bool isSelected = false;
  bool showPic = true;

  int OptioSelected = 0;
  int question_no = 0;
  String aswer = "The Lane ahead is Closed";
  late List<QuestionModel> questioList= [];
  late List<String> mistakesQuestioList= [];
  int correct = 0;

  String email = "";
  String error = "";

  late SharedPreferences pref;
  CountDownController countDownController = CountDownController();
  List<int> selectedOptions = [];
  List<int> correctOptions = [];

  final GlobalKey<NavigatorState> key = new GlobalKey<NavigatorState>();


  late List<QuestionModel> allQuestionListinEnglish= [];

  List<List<String>> optionsList =[];


  String selectedLanguge="";
  bool showError = false;

  List< List<String>> languages = [
    ['English',"en"],
    ['Spanish',"es"],
    ['Hindi',"hi"],
    ['Urdu',"ur"],
    ['Dutch',"nl"],
    ['French','fr'],
    ['Arabic','ar'],
    ['Punjabi','pa'],
  ];

  bool isTranslated = false;
  bool islangugeSelected = false;
  String name  = "";
  String dni  = "";

  @override
  void initState() {
    super.initState();
    print(widget.isLanguageTranslation);

    init();
    getQuestions();

  }


  Future init() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      email = pref.getString("email")!;
      name = pref.getString("name")!;
      // dni = pref.getString("dni")!;
    });
    if(widget.isLanguageTranslation != "true" ){
      isTranslated = true;
      islangugeSelected= true;
    }
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child:isTranslated && islangugeSelected
              ?  Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [


                    // Material(
                    //   child: Text("  Question ${question_no+1}/${questioList.length}  ",style: TextStyle(fontSize: 16,color: Colors.orange,fontWeight: FontWeight.bold),),
                    //   borderRadius: BorderRadius.all(Radius.circular(20)),
                    //   color: Colors.blue[700],
                    //   elevation: 6,
                    // ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        SizedBox(height: 15,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              // Material(
                              //     color: Colors.grey[100],
                              //     child: Icon(Icons.close_rounded)
                              //
                              //
                              // ),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.center,
                              //   children: [
                              //
                              //
                              //     Container(
                              //       width: MediaQuery
                              //           .of(context)
                              //           .size
                              //           .width * 0.35,
                              //       child: LinearProgressIndicator(
                              //         minHeight: 8,
                              //         color: Colors.orange,
                              //         backgroundColor: Colors.grey[200],
                              //         value: (question_no+1) / questioList.length,
                              //       ),
                              //     ),
                              //     Text("   "),
                              //     Text(
                              //       (question_no + 1).toString() +
                              //           "/" +
                              //           questioList.length.toString(),
                              //       style: TextStyle(
                              //           fontFamily: "Poppins",
                              //           letterSpacing: 2,
                              //           fontSize: 15,
                              //           color: Colors.blue),
                              //     ),
                              //   ],
                              // ),

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      SizedBox(height: 5,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text("NIE/DNI :  ",style: TextStyle(fontFamily: "Poppins",color: Colors.blue),),
                                          SizedBox(height:5),
                                          Text("xxxxx",style: TextStyle(fontFamily: "Poppins"),),
                                        ],
                                      ),

                                      Row(
                                        children: [
                                          Text("Name    : ",style: TextStyle(fontFamily: "Poppins",color: Colors.blue),),
                                          SizedBox(height:5),
                                          Text("Admin",style: TextStyle(fontFamily: "Poppins"),),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 19,),
                                  Column(
                                    children: [
                                      Image.asset("assets/logo_plue.png",width: 80,height: 30,),
                                      Text("BM-Educators",style: TextStyle(fontFamily: "Poppins",fontSize: 10),)
                                      , SizedBox(height: 10,)
                                    ],
                                  ),


                                ],
                              ),

                              Stack(
                                  alignment: Alignment.center,
                                  children:[
                                    CircularCountDownTimer(
                                      width: 5,
                                      height: 5,
                                      duration: questioList.length * 60,
                                      textStyle: TextStyle(fontSize: 12),
                                      fillColor: Colors.blue[500],
                                      color: Colors.grey[300],
                                      controller: countDownController,

                                    ),

                                    CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.grey[100],
                                      child: CircularCountDownTimer(
                                        width: 45,
                                        height: 45,
                                        isReverse: true,
                                        duration: questioList.length * 60,
                                        textStyle: TextStyle(fontSize: 12),
                                        fillColor: Colors.blue[500],
                                        color: Colors.grey[300],

                                      ),

                                    ),

                                  ]
                              ),


                            ],
                          ),
                        ),
                        SizedBox(height:10,),
                        Column(
                          children: [
                            Visibility(
                              visible: questioList[question_no].image!="",
                              child: InkWell(

                                onTap: (){
                                  showPic = !showPic;
                                  setState(() {

                                  });
                                },
                                child: Material(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(20),
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text("   "),
                                        Icon(Icons.photo_camera_back_outlined,size: 15,),
                                        !showPic? Text("  See Picture  "):Text("  Hide Picture  "),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10,),
                            InkWell(
                              onTap: (){
                                // Navigator.pushReplacement(
                                //     context, MaterialPageRoute(builder: (context) =>previewImage(imageUrls:[ questioList[question_no].image], index: 0)));

                                Navigator.of(context).push(new MaterialPageRoute<Null>(
                                    builder: (BuildContext context) {
                                      return new previewImage(imageUrls: [questioList[question_no].image], index: 0, isFile: widget.newlyAddedQuestion.contains(questioList[question_no].statement),);
                                    },
                                    fullscreenDialog: true));
                              },
                              child: Material(
                                borderRadius: BorderRadius.circular(0),
                                child: Visibility(
                                  visible: questioList[question_no].image != "" && showPic,
                                  child:
                                  widget.newlyAddedQuestion.contains(questioList[question_no].statement)?
                                  Image.file(
                                    File( questioList[question_no].image),
                                    width: MediaQuery.of(context).size.width * 0.42,
                                    height: MediaQuery.of(context).size.height * 0.12,
                                  ):
                                  Image.network(
                                    questioList[question_no].image,
                                    width: MediaQuery.of(context).size.width * 0.42,
                                    height: MediaQuery.of(context).size.height * 0.12,
                                  )

                                ),
                              ),
                            ),
                            SizedBox(height:10,),
                            Visibility(
                                visible :questioList[question_no].image == "",
                                child: SizedBox(height:80,)),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: Material(
                                borderRadius: BorderRadius.circular(6),
                                clipBehavior: Clip.antiAlias,
                                elevation: 6,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal:10),
                                  width: MediaQuery.of(context).size.width ,
                                  color: Color(0xff00aeff).withOpacity(0.1),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                                    child: Text(
                                      questioList[question_no].statement,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: "Poppins",),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 0),
                        //   child: Row(
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     children: [
                        //       SizedBox(width: 15,),
                        //       InkWell(
                        //         onTap: (){
                        //           Navigator.pushReplacement(
                        //               context, MaterialPageRoute(builder: (context) =>previewImage(imageUrls:[ questioList[question_no].image], index: 0)));
                        //
                        //         },
                        //         child: Material(
                        //           borderRadius: BorderRadius.circular(0),
                        //           child: Visibility(
                        //             visible: questioList[question_no].image != "",
                        //             child: Image.network(
                        //               questioList[question_no].image,
                        //               width: MediaQuery.of(context).size.width * 0.4,
                        //               height: MediaQuery.of(context).size.height * 0.15,
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //       SizedBox(width: 15,),
                        //       questioList[question_no].image !=
                        //           ""?     Material(
                        //         borderRadius: BorderRadius.circular(6),
                        //         clipBehavior: Clip.antiAlias,
                        //         elevation: 6,
                        //         child: Container(
                        //           width:
                        //           MediaQuery.of(context).size.width * 0.45,
                        //
                        //           alignment: Alignment.topLeft,
                        //           color: Color(0xff00aeff).withOpacity(0.1),
                        //           child: Padding(
                        //             padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 5),
                        //             child: Text(
                        //               questioList[question_no].statement,
                        //               style: TextStyle(
                        //                   fontSize: 12,
                        //                   fontFamily: "Poppins",
                        //                   fontWeight: FontWeight.bold),
                        //               textAlign: TextAlign.center,
                        //             ),
                        //           ),
                        //         ),
                        //       ):
                        //
                        //       Material(
                        //         borderRadius: BorderRadius.circular(6),
                        //         clipBehavior: Clip.antiAlias,
                        //         elevation: 6,
                        //         child: Container(
                        //           padding: EdgeInsets.symmetric(horizontal:20),
                        //           width: MediaQuery.of(context).size.width * 0.9,
                        //           alignment: Alignment.topLeft,
                        //           color: Color(0xff00aeff).withOpacity(0.1),
                        //           child: Padding(
                        //             padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 5),
                        //             child: Text(
                        //               questioList[question_no].statement,
                        //               style: TextStyle(
                        //                   fontSize: 14,
                        //                   fontFamily: "Poppins",
                        //                   fontWeight: FontWeight.bold),
                        //               textAlign: TextAlign.center,
                        //             ),
                        //           ),
                        //         ),
                        //       )
                        //     ],
                        //   ),
                        // ),

                        SizedBox(
                          height: 20,
                        ),
                        //
                        // Padding(padding:
                        // EdgeInsets.symmetric(horizontal: 10),
                        //   child: optionItems(
                        //       questioList[question_no].optionA,
                        //       questioList[question_no].option2,
                        //       questioList[question_no].optionC
                        //   ),
                        Padding(
                          padding:EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              optionItem("a",1, questioList[question_no].optionA,questioList[question_no],correctOptions[question_no]==1),
                              optionItem("b",2, questioList[question_no].option2,questioList[question_no],correctOptions[question_no]==2),
                              optionItem("c",3, questioList[question_no].optionC,questioList[question_no],correctOptions[question_no]==3),

                            ],
                          ),


                        ),


                        SizedBox(height: 20,),

                        Visibility(
                            visible: error != "",
                            child:    Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("       * ${error}",style: TextStyle(fontFamily: "Poppins",color: Colors.red,fontSize: 17,letterSpacing: 1),),
                              ],
                            )),

                      ],
                    ),


                  ],
                ),
                Column(
                  children: [
                    Column(
                      children: [
                        Padding(padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              InkWell(
                                onTap: () {
                                  print(selectedOptions);

                                  error = "";
                                  setState(() {

                                  });

                                  if (question_no != 0) {
                                    question_no = question_no - 1;
                                    aswer = questioList[question_no].answer;
                                    OptioSelected = selectedOptions[question_no];
                                    setState(() {});
                                  }
                                },
                                child: Material(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.cyan[100] ,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 5),
                                    child: Icon(Icons.arrow_back,color: Colors.blueAccent,size: 30,),
                                  )
                                  ,
                                ),
                              ),
                              InkWell(
                                onTap: () {

                                  setState(() {

                                  });
                                    if(question_no == (questioList.length-1)){
                                    Navigator.pop(context);
                                    }

                                  else {
                                    if(question_no != questioList.length-1){
                                      question_no = question_no + 1;
                                      aswer = questioList[question_no].answer;
                                      OptioSelected = selectedOptions[question_no];
                                      setState(() {});
                                    }

                                  }
                                },
                                child: Material(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.cyan[100] ,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                                    child: Row(
                                      children: [
                                        Icon(Icons.arrow_forward,color: Colors.blueAccent,size: 30,),
                                        Text(" Next")
                                      ],
                                    ),
                                  )
                                  ,
                                ),
                              ),
                              InkWell(
                                onTap: (){
                                Navigator.pop(context);
                                },
                                child: Material(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.amber ,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                                    child: Row(
                                      children: [
                                        Icon(Icons.pin_end_outlined,color: Colors.blueAccent,size: 30,),
                                        Text("  Finish")

                                      ],
                                    ),
                                  )
                                  ,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15,),

                      ],
                    ),
                    Container(
                      height: 8,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey[300],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                          color: Colors.grey[300],
                          child:     Center(
                            child: ListView.builder(

                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.all(0),
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Material(
                                    clipBehavior: Clip.antiAlias,
                                    elevation: 0,
                                    child: InkWell(

                                      onTap: (){
                                        print(index);
                                        question_no = index;

                                        setState(() {

                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(2),
                                        child: Center(child:
                                        index != 9?
                                        Text(" 0${index+1} ",style:
                                        TextStyle(fontFamily: "Poppins",color: Colors.blue),):
                                        Text(" ${index+1} ",style:
                                        TextStyle(fontFamily: "Poppins",color: Colors.blue),)),

                                        color:selectedOptions.length > index && selectedOptions[index] != 0 ? Colors.green[100]:index == question_no?  Colors.yellow:Colors.white,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              itemCount:10,
                            ),
                          )
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                          color: Colors.grey[300],
                          child:     Center(
                            child: ListView.builder(

                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.all(0),
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Material(
                                    clipBehavior: Clip.antiAlias,
                                    elevation: 0,
                                    child: Container(
                                      padding: EdgeInsets.all(3),
                                      child: Center(child: Text(" ${index+11} "
                                        ,style: TextStyle(fontFamily: "Poppins"
                                            ,color: Colors.blue),)),
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              },
                              itemCount:10,
                            ),
                          )
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                          color: Colors.grey[300],
                          child:     Center(
                            child: ListView.builder(

                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.all(0),
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Material(
                                    clipBehavior: Clip.antiAlias,
                                    elevation: 0,
                                    child: Container(
                                      padding: EdgeInsets.all(2),
                                      child: Center(child: Text(" ${index+21} ",style:
                                      TextStyle(fontFamily: "Poppins",color: Colors.blue),)),
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              },
                              itemCount:10,
                            ),
                          )
                      ),
                    ),
                    Container(
                      height: 8,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey[300],
                    ),
                    SizedBox(height: 40,)
                  ],
                )
              ],
            ),
          )
              :Container(
            height: MediaQuery.of(context).size.height * 0.9,
            margin: EdgeInsets.only(bottom: 100),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                  Text("Translating...",style: TextStyle(fontFamily: "Poppins",fontSize: 18),),
                ],
              ),
            ),
          ),
        ),
      ),
    );




  }

  optionItem(String char,int option_no, String option,QuestionModel q,bool isanswer) {
   print(correctOptions[question_no]);
   print("dfsffdf");
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: InkWell(
        onTap: () {
        },
        child: Container(
          width: MediaQuery
              .of(context)
              .size
              .width ,
          decoration: BoxDecoration(
            color:correctOptions[question_no] != option_no
                ? Colors.white
                :Colors.yellow[300],
            border: Border.all(color: Colors.grey.withOpacity(0.2), width: 3),
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            horizontalTitleGap: 0,
            minLeadingWidth: 25,
            leading: Text("${char})",style: TextStyle(fontFamily: "Poppins",color: Colors.blue),),
            title: Text(
              option,
              style: TextStyle(fontFamily: "PoppinRegular", fontSize: 12),
            ),
            trailing:Visibility(
              visible: isanswer,
              child: InkWell(
                onTap: () {
                  setState(() {});
                },
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 7,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getQuestions() async {
    pref = await SharedPreferences.getInstance();

    // var data = await FirebaseFirestore.instance
    //     .collection('questions')
    //     .get(const GetOptions(source: Source.server));
    //
    // if (data.docs.isNotEmpty) {
    //   print("exisr");
    //   setState(() {
    //     questioList =
    //         List.from(data.docs.map((doc) => QuestionModel.fromSnapshot(doc)));
    //     questioList = widget.quiz.questions.cast<QuestionModel>();
      questioList.addAll(widget.questionList);

    aswer = questioList[question_no].answer;
    questioList.forEach((element) {

      if(element.optionA == element.answer){
        correctOptions.add(1);
      }
      else if(element.option2 == element.answer){
        correctOptions.add(2);
      }
      else if(element.optionC == element.answer){
        correctOptions.add(3);
      }

    });
    setState(() {

    });

    isLoaded = true;

    setState(() {

    });
  }




}
