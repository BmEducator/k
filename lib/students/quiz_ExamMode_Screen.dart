import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math' as math;
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

import '../Models/QuizModel.dart';
import '../Models/QuizToPerformModel.dart';
import '../Models/question.dart';
import '../services_Screen/photoView.dart';
import 'main_menuScreen.dart';

class quiz_ExamMode_Screen extends StatefulWidget {
  List<int> selecteddataList;
  List<dynamic> completedQuizes;
  bool isShuffle;
  quizToPerformModel quiz;
  String  isLanguageTranslation;
   quiz_ExamMode_Screen({Key? key,required this.completedQuizes,required this.quiz, required this.isLanguageTranslation,required this.isShuffle,required this.selecteddataList}) : super(key: key);

  @override
  State<quiz_ExamMode_Screen> createState() => _quiz_ExamMode_ScreenState();
}

class _quiz_ExamMode_ScreenState extends State<quiz_ExamMode_Screen> {
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
    if(widget.isLanguageTranslation == "true" ){
      SchedulerBinding.instance.addPostFrameCallback((_) {
        selectLanguage(key.currentContext);
      });}
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
    if(widget.isLanguageTranslation == "true" && islangugeSelected){
      final translator = GoogleTranslator();


      List<QuestionModel> tempList = [];
      tempList.addAll(questioList);
      for(int i = 0 ;i<questioList.length;i++){

        await translator.translate(questioList[i].statement,from: 'en',to: selectedLanguge).then((value) {
          tempList[i].statement = value.text;
        });
        await translator.translate(questioList[i].optionA,from: 'en',to: selectedLanguge).then((value) {
          tempList[i].optionA = value.text;
        });
        await translator.translate(questioList[i].option2,from: 'en',to: selectedLanguge).then((value) {
          tempList[i].option2 = value.text;
        });

        if(tempList[i].optionC != "") {
        await translator.translate(questioList[i].optionC,from: 'en',to: selectedLanguge).then((value) {
          tempList[i].optionC = value.text;
        });
        }

        await translator.translate(questioList[i].answer,from: 'en',to: selectedLanguge).then((value) {
          tempList[i].answer = value.text;
        });


        if(i == questioList.length-1){
          setState(() {
            isTranslated = true;
          });
        }
      }

      questioList.clear();
      questioList.addAll(tempList);

    }
    if(widget.isLanguageTranslation != "true" ){
      isTranslated = true;
      islangugeSelected= true;
    }
    setState(() {
    });
  }
  Future<bool> willpop() async {
    return (await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Row(
            mainAxisAlignment:
            MainAxisAlignment.start,
            children: [
              Text("Are you sure to finish Quiz?",
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
                _showFinishDialog();
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
        key: key,
        backgroundColor: Colors.white,
        body: SafeArea(
          child:isTranslated && islangugeSelected
              ?  Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          Text("32823",style: TextStyle(fontFamily: "Poppins"),),
                                        ],
                                      ),

                                      Row(
                                        children: [
                                          Text("Name    : ",style: TextStyle(fontFamily: "Poppins",color: Colors.blue),),
                                          SizedBox(height:5),
                                          Text(name,style: TextStyle(fontFamily: "Poppins"),),
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
                                      duration: 10,
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
                                        onComplete: _showFinishDialog,

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
                                      return new previewImage(imageUrls: [questioList[question_no].image], index: 0, isFile: false,);
                                    },
                                    fullscreenDialog: true));
                              },
                              child: Material(
                                borderRadius: BorderRadius.circular(0),
                                child: Visibility(
                                  visible: questioList[question_no].image != "" && showPic,
                                  child: Image.network(
                                    questioList[question_no].image,
                                    width: MediaQuery.of(context).size.width * 0.42,
                                    height: MediaQuery.of(context).size.height * 0.12,
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



                        SizedBox(
                          height: 20,
                        ),

                        Padding(
                          padding:EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                        children: [
                        optionItem("a",1, questioList[question_no].optionA,questioList[question_no]),
                        optionItem("b",2, questioList[question_no].option2,questioList[question_no]),
                        Visibility(visible: questioList[question_no].optionC != "",
                          child: optionItem("c",3, questioList[question_no].optionC,questioList[question_no]),
                        )


                      ],
            ),


          ),
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

                                  error = "";
                                  setState(() {

                                  });

                                  if (question_no == (questioList.length-1) &&
                                      isSelected ) {
                                    if(question_no == (questioList.length-1)){
                                      if(selectedOptions.contains(0)){
                                        for(int i= 0;i<selectedOptions.length;i++){
                                          if(selectedOptions[i] == 0) {
                                            error = "Tick Question no ${i+1}";
                                            setState(() {

                                            });
                                          }
                                        }
                                      }
                                      else{
                                        saveSharedPreference();
                                        _showFinishDialog();
                                      }
                                    }
                                  }
                                  else {
                                    if(question_no != questioList.length-1){
                                      saveSharedPreference();
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
                                  if(selectedOptions.contains(0)){

                                    print(selectedOptions.length);


                                    for(int i= 0;i<selectedOptions.length;i++){
                                      if(selectedOptions[i] == 0) {
                                        error = "Tick Question no ${i+1}";
                                        setState(() {

                                        });
                                      }
                                    }
                                  }
                                  else{
                                    _showFinishDialog();
                                  }

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
                    Container(
                      color: Colors.grey[100],
                      child: AnimationLimiter(
                        child: GridView.count(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: const EdgeInsets.fromLTRB(6, 2, 6, 0),
                          scrollDirection: Axis.vertical,
                          crossAxisCount: 10,
                          childAspectRatio: (1 / 0.9),
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 8,
                          children: List.generate(
                            questioList.length,
                                (int index) {
                              return AnimationConfiguration.staggeredGrid(
                                position: index,
                                duration: const Duration(milliseconds: 375),
                                columnCount: 3,
                                child: ScaleAnimation(
                                  child: FadeInAnimation(
                                      child: InkWell(

                                                          onTap: (){
                                                            print(index);
                                                            question_no = index;
                                                            aswer = questioList[question_no].answer;
                                                            OptioSelected = selectedOptions[question_no];

                                                            setState(() {

                                                            });
                                                          },
                                        child: selectedOptions[index]!=0?
                                        Material(
                                          clipBehavior: Clip.antiAlias,
                                          elevation: 1,
                                          child: Container(
                                            child: Center(child:

                                            Text(" ${index+1} ",style:
                                            TextStyle(fontFamily: "Poppins",color: Colors.blue,fontSize: 16),)),

                                            color: selectedOptions[index] !=0?   Colors.green[200]:Colors.orange,
                                          ),
                                        ):
                                        index == question_no ?
                                            Material(
                                          clipBehavior: Clip.antiAlias,
                                          elevation: 1,
                                          child: Container(
                                            child: Center(child:

                                            Text(" ${index+1} ",style:
                                            TextStyle(fontFamily: "Poppins",color: Colors.blue,fontSize: 16),)),

                                            color: Colors.orange,
                                          ),
                                        ):
                                        Material(
                                          clipBehavior: Clip.antiAlias,
                                          elevation: 1,
                                          child: Container(
                                            child: Center(child:

                                            Text(" ${index+1} ",style:
                                            TextStyle(fontFamily: "Poppins",color: Colors.blue,fontSize: 16),)),

                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                  ),
                                ),
                              );
                            },
                          ),
                        ),),
                    ),



                    // SizedBox(
                    //   height: MediaQuery.of(context).size.height * 0.05,
                    //   width: MediaQuery.of(context).size.width,
                    //   child: Container(
                    //       color: Colors.grey[300],
                    //       child:     Center(
                    //         child: ListView.builder(
                    //
                    //           shrinkWrap: true,
                    //           scrollDirection: Axis.horizontal,
                    //           padding: const EdgeInsets.all(0),
                    //           itemBuilder: (context, index) {
                    //             return Padding(
                    //               padding: const EdgeInsets.all(5.0),
                    //               child: Material(
                    //                 clipBehavior: Clip.antiAlias,
                    //                 elevation: 0,
                    //                 child: InkWell(
                    //
                    //                   onTap: (){
                    //                     print(index);
                    //                     question_no = index;
                    //                     aswer = questioList[question_no].answer;
                    //                     OptioSelected = selectedOptions[question_no];
                    //
                    //                     setState(() {
                    //
                    //                     });
                    //                   },
                    //                   child: Container(
                    //                     padding: EdgeInsets.all(2),
                    //                     child: Center(child:
                    //                     index != 9?
                    //                     Text(" 0${index+1} ",style:
                    //                     TextStyle(fontFamily: "Poppins",color: Colors.blue),):
                    //                     Text(" ${index+1} ",style:
                    //                     TextStyle(fontFamily: "Poppins",color: Colors.blue),)),
                    //
                    //                     color:selectedOptions.length > index && selectedOptions[index] != 0 ? Colors.green[100]:index == question_no?  Colors.yellow:Colors.white,
                    //                   ),
                    //                 ),
                    //               ),
                    //             );
                    //           },
                    //           itemCount:10,
                    //         ),
                    //       )
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: MediaQuery.of(context).size.height * 0.05,
                    //   width: MediaQuery.of(context).size.width,
                    //   child: Container(
                    //       color: Colors.grey[300],
                    //       child:     Center(
                    //         child: ListView.builder(
                    //
                    //           shrinkWrap: true,
                    //           scrollDirection: Axis.horizontal,
                    //           padding: const EdgeInsets.all(0),
                    //           itemBuilder: (context, index) {
                    //             return Padding(
                    //               padding: const EdgeInsets.all(5.0),
                    //               child: Material(
                    //                 clipBehavior: Clip.antiAlias,
                    //                 elevation: 0,
                    //                 child: Container(
                    //                   padding: EdgeInsets.all(3),
                    //                   child: Center(child: Text(" ${index+11} "
                    //                     ,style: TextStyle(fontFamily: "Poppins"
                    //                         ,color: Colors.blue),)),
                    //                   color: Colors.white,
                    //                 ),
                    //               ),
                    //             );
                    //           },
                    //           itemCount:10,
                    //         ),
                    //       )
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: MediaQuery.of(context).size.height * 0.05,
                    //   width: MediaQuery.of(context).size.width,
                    //   child: Container(
                    //       color: Colors.grey[300],
                    //       child:     Center(
                    //         child: ListView.builder(
                    //
                    //           shrinkWrap: true,
                    //           scrollDirection: Axis.horizontal,
                    //           padding: const EdgeInsets.all(0),
                    //           itemBuilder: (context, index) {
                    //             return Padding(
                    //               padding: const EdgeInsets.all(5.0),
                    //               child: Material(
                    //                 clipBehavior: Clip.antiAlias,
                    //                 elevation: 0,
                    //                 child: Container(
                    //                   padding: EdgeInsets.all(2),
                    //                   child: Center(child: Text(" ${index+21} ",style:
                    //                   TextStyle(fontFamily: "Poppins",color: Colors.blue),)),
                    //                   color: Colors.white,
                    //                 ),
                    //               ),
                    //             );
                    //           },
                    //           itemCount:10,
                    //         ),
                    //       )
                    //   ),
                    // ),
                    Container(
                      height: 28,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey[200],
                    ),
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
                  LoadingAnimationWidget.staggeredDotsWave(
                    color: Colors.blue,
                    size: 80,
                  ),
                  SizedBox(height: 20,),
                  Text("Translating...",style: TextStyle(fontFamily: "Poppins",fontSize: 18),),
                ],
              ),
            ),
          ),
        ),

        // bottomNavigationBar: BottomAppBar(
        //   color: Colors.transparent,
        //   elevation: 0,
        //   child: Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 0),
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //
        //         InkWell(
        //           onTap: () {
        //             print(selectedOptions);
        //
        //             error = "";
        //             setState(() {
        //
        //             });
        //
        //             if (question_no != 0) {
        //               question_no = question_no - 1;
        //               aswer = questioList[question_no].answer;
        //               OptioSelected = selectedOptions[question_no];
        //               setState(() {});
        //             }
        //           },
        //           child: Padding(
        //             padding: const EdgeInsets.all(8.0),
        //             child: Material(
        //               borderRadius: BorderRadius.circular(10),
        //               color: Colors.blue[600],
        //               child: Padding(
        //                 padding: const EdgeInsets.all(8.0),
        //                 child: Text(" Previous ",
        //                     style: TextStyle(
        //                         fontFamily: "PoppinRegular",
        //                         fontSize: 20,
        //                         color:Colors.white)),
        //               ),
        //             ),
        //           ),
        //         ),
        //         InkWell(
        //           onTap: () {
        //             error = "";
        //             setState(() {
        //
        //             });
        //
        //             print(question_no);
        //             print(questioList.length);
        //             if (question_no == (questioList.length-1) &&
        //                 isSelected ) {
        //               print("a");
        //               if(question_no == (questioList.length-1)){
        //                 print("b");
        //                 print(selectedOptions);
        //                 if(selectedOptions.contains(0)){
        //
        //                   print(selectedOptions.length);
        //
        //
        //                   for(int i= 0;i<selectedOptions.length;i++){
        //                     if(selectedOptions[i] == 0) {
        //                       error = "Tick Question no ${i+1}";
        //                       setState(() {
        //
        //                       });
        //                     }
        //                   }
        //                 }
        //                 else{
        //                   _showFinishDialog();
        //                 }
        //               }
        //             }
        //             else {
        //               if(question_no != questioList.length-1){
        //               question_no = question_no + 1;
        //               aswer = questioList[question_no].answer;
        //               OptioSelected = selectedOptions[question_no];
        //               setState(() {});
        //             }
        //
        //             }
        //           },
        //           child: Padding(
        //             padding: const EdgeInsets.all(8.0),
        //             child: Material(
        //               borderRadius: BorderRadius.circular(10),
        //               color: Colors.green[600],
        //               child: Padding(
        //                 padding: const EdgeInsets.all(8.0),
        //                 child: Text("      Next      ",
        //                     style: TextStyle(
        //                         fontFamily: "PoppinRegular",
        //                         fontSize: 20,
        //                         color: Colors.white)),
        //               ),
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ),
    );




  }

  optionItem(String char,int option_no, String option,QuestionModel q) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: InkWell(
        onTap: () {

          setState(() {
            OptioSelected = option_no;
          });
          selectedOptions[question_no] = option_no;



            isSelected= true;
        },
        child: Container(
          width: MediaQuery
              .of(context)
              .size
              .width ,
          decoration: BoxDecoration(
            color:   OptioSelected != option_no
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
              visible: OptioSelected == option_no,
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
         widget.quiz.questions.forEach((element) {
           QuestionModel questionModel = QuestionModel(
               image: element['image'],
               statement: element['statement'],
               optionA: element['optionA'],
               option2: element['option2'],
               optionC: element['optionC'],
               answer: element['answer']);
           questioList.add(questionModel);
           allQuestionListinEnglish.add(questionModel);

         });

      setState(() {

      });
        aswer = questioList[question_no].answer;
        questioList.forEach((element) {

         selectedOptions.add(0);

         // if(false) {
         //
         //   print("Shuffle");
         //   List<String> opti = [
         //     element.optionA,
         //     element.option2,
         //     element.optionC
         //   ];
         //   opti.shuffle();
         //
         //   element.optionA = opti[0];
         //   element.option2 = opti[1];
         //   element.optionC = opti[2];
         // }
         if(widget.isShuffle){
           selectedOptions.clear();
           selectedOptions.addAll(widget.selecteddataList);
         }

         if(element.optionA == element.answer){
           correctOptions.add(1);
         }
         else if(element.option2 == element.answer){
           correctOptions.add(2);
         }
         else if(element.optionC == element.answer){
           correctOptions.add(3);
         }

         int? a =  pref.getInt("currentQuestion${widget.quiz.timestamp}");
         if(a != null){
           question_no = a;
         }
         OptioSelected = selectedOptions[question_no];

        });
         setState(() {

         });

        isLoaded = true;
      }



  // Future<void> _showTieoutDialog() {
  //   bool isLoading = false;
  //   return
  //     showModalBottomSheet(
  //         backgroundColor: Colors.transparent,
  //         constraints: BoxConstraints(
  //             maxWidth:
  //             MediaQuery
  //                 .of(context)
  //                 .size
  //                 .width -
  //                 20),
  //         isDismissible: true,
  //         elevation: 20,
  //         context: context,
  //         builder: (context) {
  //           return Container(
  //             margin: EdgeInsets.only(bottom: 20),
  //             decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius:
  //                 BorderRadius.circular(20)),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 SizedBox(
  //                   height: 20,
  //                 ),
  //                 Icon(
  //                   Icons.check_circle,
  //                   color: Colors.green,
  //                   size: 60,
  //                 ),
  //                 SizedBox(
  //                   height: 10,
  //                 ),
  //                 Text(
  //                   "Your Quiz time has been out....",
  //                   style: TextStyle(
  //                       fontFamily: "Poppins",
  //                       fontSize: 18),
  //                 ),
  //                 SizedBox(
  //                   height: 50,
  //                 ),
  //                 Text(
  //                   "Your Made ${mistakesQuestioList.length} mistakes....",
  //                   style: TextStyle(
  //                       fontFamily: "Poppins",
  //                       fontSize: 18),
  //                 ),
  //                 SizedBox(
  //                   height: 50,
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.symmetric(
  //                       horizontal: 70),
  //                   child: InkWell(
  //                     onTap: () async {
  //                       innerSetState((){
  //                         isLoading = true;
  //                       });
  //                       if(isLoading) {
  //                         saveData();
  //                       }
  //                     },
  //
  //                     child: Material(
  //                       borderRadius:
  //                       const BorderRadius.all(
  //                           Radius.circular(8)),
  //                       elevation: 6,
  //                       color: Colors.yellow,
  //                       child: Container(
  //                           height: 40,
  //                           width: double.infinity,
  //                           alignment: Alignment.center,
  //                           child:isLoading?
  //                           Center(
  //                               child: LoadingAnimationWidget.staggeredDotsWave(
  //                                 color: Colors.blue,
  //                                 size: 40,
  //                               ))
  //                           :Text(
  //                             'Continue',
  //                             style: TextStyle(
  //                                 fontFamily: "Poppins",
  //                                 color: Colors.black,
  //                                 fontSize: 17),
  //                           )),
  //                     ),
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   height: 50,
  //                 ),
  //               ],
  //             ),
  //           );
  //         });
  // }

  _showFinishDialog() {
    print(correctOptions.length);
    allQuestionListinEnglish.clear();
    widget.quiz.questions.forEach((element) {
      QuestionModel questionModel = QuestionModel(
          image: element['image'],
          statement: element['statement'],
          optionA: element['optionA'],
          option2: element['option2'],
          optionC: element['optionC'],
          answer: element['answer']);
      allQuestionListinEnglish.add(questionModel);
      print(allQuestionListinEnglish[0].statement);

    });
    selectedOptions.forEach((element) {
      print(element);
      print("////");
    });
    print("--------");

    correctOptions.forEach((element) {
      print(element);
      print("////");
    });
    bool isLoading= false;
    for(int i= 0;i<=correctOptions.length-1;i++ ){
      if(selectedOptions[i] != correctOptions[i])
      {
        print("wr00");
        mistakesQuestioList.add(allQuestionListinEnglish[i].statement + "~"+allQuestionListinEnglish[i].answer);

        print(allQuestionListinEnglish[i].statement);
      }
      else {
        print("corr");
        correct= correct+1;
      }
    }
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
            return  StatefulBuilder(
              builder: (BuildContext context, StateSetter innerSetState) {

              return WillPopScope(
                onWillPop: () async{
                  return false;
                },
                child: Container(
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
                        "Your Quiz has been Finished....",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 18),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        "Your Made ${mistakesQuestioList.length} mistakes....",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 18),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        "${correct} corrects....",
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

                            innerSetState((){
                              isLoading = true;
                            });

                            if(isLoading){
                              saveData();
                            }
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
                                child:isLoading?
                                Center(
                                    child: LoadingAnimationWidget.staggeredDotsWave(
                                      color: Colors.blue,
                                      size: 40,
                                    ))
                                :Text(
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
                ),
              );}
            );
          });
  }

  Future<void> saveData() async {

    String a = DateTime
        .now()
        .microsecondsSinceEpoch
        .toString();

    print(selectedOptions[0]);

    quizModel q = quizModel(
        id: a,
        date: a,
        totalQuestions: questioList.length.toString(),
        correct: correct.toString(),
        time: countDownController.getTime().toString(),
        mistakes: mistakesQuestioList, mode: 'Exam');


    List<dynamic> list = [
      q.id,
      q.date,
      q.totalQuestions,
      q.correct,
      q.time,
      q.mode
    ];

    q.mistakes.forEach((element) {
      list.add(element);
    });

    await FirebaseFirestore.instance.collection("students").
    doc(email).collection("quizesProgress").doc("quizes")
        .set({a: list}, SetOptions(merge: true));


    List<dynamic> temp = [];
    temp.addAll(widget.completedQuizes);
    temp.add(widget.quiz.id);

    //
    // await FirebaseFirestore.instance.collection("students").
    // doc(email).collection("quizes").doc(a).set(q.toMap());

    pref.remove("selectedOptions${widget.quiz.timestamp}");
    pref.remove("currentQuestion${widget.quiz.timestamp}");
    print( pref.containsKey("selectedOptions${widget.quiz.timestamp}"));

    print(pref.containsKey("currentQuestion${widget.quiz.timestamp}"));
    await FirebaseFirestore.instance.collection("students").
    doc(email).collection("completedQuizes").doc("quizes").set(
      {
        "completedQuizes":temp
      }

    );

    //
    // await FirebaseFirestore.instance.collection("students").
    // doc(email).collection("Pending").doc(widget.quiz.id).delete();

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => mainMenu(isfromLogin: false, checkUpdate: false,)));

  }

  Future<void> selectLanguage( context) {
    TextEditingController controller = TextEditingController();
    return showDialog(
       barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (thisLowerContext, innerSetState) {
            return Dialog(
              child: SingleChildScrollView(
                  child: WillPopScope(
                    onWillPop: ()async{
                      return false;
                    },
                    child: Padding(
                      padding:  EdgeInsets.all(15),
                      child: Column(

                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Column(
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text("Select Language",style: TextStyle(fontFamily: "Poppins",fontSize: 22,color: Colors.lightBlueAccent),)
                                      ,SizedBox(height: 20,),
                                      Container(
                                        width: MediaQuery.of(context).size.width*0.5,
                                        height: MediaQuery.of(context).size.height * 0.6,
                                        child: ListView.builder(

                                          padding: const EdgeInsets.all(10),
                                          itemBuilder: (context, index) {
                                            return Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children:[
                                                  InkWell(
                                                      onTap: (){
                                                        selectedLanguge = languages[index][1];
                                                        print(selectedLanguge);
                                                        showError = false;
                                                        innerSetState(() {

                                                        });
                                                      },
                                                      child: Container(
                                                          padding: EdgeInsets.fromLTRB(10, 5, 60, 5),
                                                          color:selectedLanguge ==  languages[index][1]?Colors.lightBlueAccent:Colors.white,
                                                          child: Text(languages[index][0],style: TextStyle(fontFamily: "PoppinRegular",fontSize: 18),))),
                                                  Divider(thickness: 2,),
                                                  SizedBox(height: 6,)
                                                ]
                                            );
                                          },
                                          itemCount:languages.length,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Visibility(
                                      visible: showError,
                                      child: Text("* Select a Language ",style: TextStyle(color: Colors.red,fontFamily: "Poppins",fontSize: 16),))
                                  ,SizedBox(height: 0,)
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: ElevatedButton(onPressed: (){
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                }, child: Text("Cancel",style: TextStyle(fontFamily: "Poppins",color: Colors.black),),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey.shade200

                                  ),),
                              ),
                              SizedBox(width: 25,),
                              Expanded(
                                child: ElevatedButton(onPressed: (){
                                  if(selectedLanguge!=""){
                                    islangugeSelected = true;
                                    Navigator.pop(context);
                                    init();}
                                  else{
                                    showError = true;
                                    innerSetState((){

                                    });
                                  }
                                }, child: Text("Start",style: TextStyle(fontFamily: "Poppins"),),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: selectedLanguge!=""?Colors.lightBlue:Colors.grey
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ],
                      ),
                    ),
                  )
              ),
            );
          });
        });




  }

  optionItems(String A,String B,String c){

    List<String> _optionList = [
      A,B,c
    ];
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return optionItem(index==0?  "a": index == 1 ? "b":"c", index, _optionList[index],
              questioList[question_no]);
        },
         itemCount:_optionList.length,
      );

  }
 saveSharedPreference(){

    List<String> t = [];
    selectedOptions.forEach((element) {
      t.add(element.toString());

    });
    pref.setStringList("selectedOptions${widget.quiz.timestamp}", t);
    pref.setInt("currentQuestion${widget.quiz.timestamp}", question_no);
    print("save");
 }
}
