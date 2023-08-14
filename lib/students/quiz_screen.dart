
import 'package:bmeducators/Models/progressQuizModel.dart';
import 'package:bmeducators/services_Screen/photoView.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:photo_view/photo_view.dart';
import 'dart:math' as math;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

import '../Models/QuizModel.dart';
import '../Models/QuizToPerformModel.dart';
import '../Models/question.dart';
import 'main_menuScreen.dart';

class quizScreen extends StatefulWidget {
  String isLanguageTranslation;
  quizToPerformModel quizToPerform;
  List<dynamic> completedQuiz;
   quizScreen({Key? key,required this.completedQuiz, required this.quizToPerform,required this.isLanguageTranslation}) : super(key: key);

  @override
  State<quizScreen> createState() => _quizScreenState();
}

class _quizScreenState extends State<quizScreen> {
  bool isOptioSelected = false;
  bool isLoaded = false;
  bool isSelected = false;
  bool showError = false;
  String error = "";


  int OptioSelected = 0;
  int question_no = 0;
  final GlobalKey<NavigatorState> key = new GlobalKey<NavigatorState>();
  String aswer = "The Lane ahead is Closed";
  late List<QuestionModel> questioList= [];
  late List<String> mistakesQuestioList= [];
  List<int> selectedOptions = [];
  List<int> correctOptions = [];
  late List<QuestionModel> allQuestionListinEnglish= [];

  int correct = 0;

  String email = "";
  String selectedLanguge="";

 List< List<String>> languages = [
   ['English',"en"],
    ['Spanish',"es"],
    ['Hindi',"hi"],
    ['Urdu',"ur"],
    ['Dutch',"nl"],
    ['French','fr-CH'],
  ];


  late SharedPreferences pref;
   CountDownController countDownController = CountDownController();

   bool isTranslated = false;
   bool islangugeSelected = false;
   


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
       await translator.translate(
           questioList[i].optionC, from: 'en', to: selectedLanguge).then((
           value) {
         tempList[i].optionC = value.text;
       });
     }

    if(tempList[i].optionD != "") {
      await translator.translate(
          questioList[i].optionD, from: 'en', to: selectedLanguge).then((
          value) {
        tempList[i].optionD = value.text;
      });
    }
     await translator.translate(questioList[i].answer,from: 'en',to: selectedLanguge).then((value) {
        tempList[i].answer = value.text;
      });


      print(tempList[i].answer);
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

    allQuestionListinEnglish.clear();
    widget.quizToPerform.questions.forEach((element) {
      QuestionModel questionModel = QuestionModel(
          image: element['image'],
          statement: element['statement'],
          optionA: element['optionA'],
          option2: element['option2'],
          optionC: element['optionC'],
          optionD: element['optionD'],
          answer: element['answer']);
      allQuestionListinEnglish.add(questionModel);

    });
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
              Text("Do you want to exit Quiz?",
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
    return isLoaded
        ? WillPopScope(
      onWillPop: willpop,
          child: Scaffold(
      key: key,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
            child: isTranslated && islangugeSelected?
            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Column(
                        children: [



                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                InkWell(
                                  onTap: (){
                                    willpop();
                                  },
                                  child: Material(
                                      color: Colors.grey[100],
                                      child: Icon(Icons.close_rounded)

                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [


                                    Container(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width * 0.35,
                                      child: LinearProgressIndicator(
                                        minHeight: 8,
                                        color: Colors.orange,
                                        backgroundColor: Colors.grey[200],
                                        value: question_no / questioList.length,
                                      ),
                                    ),
                                    Text("   "),
                                    Text(
                                      (question_no + 1).toString() +
                                          "/" +
                                          questioList.length.toString(),
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          letterSpacing: 2,
                                          fontSize: 15,
                                          color: Colors.blue),
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
                                          onComplete: _showTimeoutDialog,

                                        ),

                                      ),

                                    ]
                                ),


                              ],
                            ),
                          ),


                          Visibility(
                            visible:questioList[question_no].image !="",
                            child: Padding(padding: EdgeInsets.only(top: 20)
                              , child: InkWell(
                                onTap: (){

                                  Navigator.of(context).push(new MaterialPageRoute<Null>(
                                      builder: (BuildContext context) {
                                        return new previewImage(imageUrls: [questioList[question_no].image], index: 0, isFile: false, question: questioList[question_no],);
                                      },
                                      fullscreenDialog: true));
                                },
                                child: Material(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    questioList[question_no].image,
                                    height: MediaQuery
                                        .of(context)
                                        .size
                                        .width * 0.3,
                                    alignment: Alignment.topCenter,
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
                          ),
                          Visibility(
                            visible:questioList[question_no].image =="",
                            child: SizedBox(height: MediaQuery.of(context).size.height*0.1,)
                          ),
                          Column(
                            children: [
                              SizedBox(

                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                                  child: Material(
                                    borderRadius: BorderRadius.circular(6),
                                    clipBehavior: Clip.antiAlias,
                                    elevation: 6,
                                    child:statementWidget(questioList[question_no].statement),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              optionItem("b",1, questioList[question_no].optionA,questioList[question_no]),
                              optionItem("a",2, questioList[question_no].option2,questioList[question_no]),
                              Visibility(visible: questioList[question_no].optionC != "",
                                child: optionItem("c",3, questioList[question_no].optionC,questioList[question_no]),
                              ),
                              Visibility(visible: questioList[question_no].optionD != "",
                                child: optionItem("d",4, questioList[question_no].optionD,questioList[question_no]),
                              ),

                              Visibility(
                                  visible: error != "",
                                  child:    Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("    * ${error}",style: TextStyle(fontFamily: "Poppins",color: Colors.red,fontSize: 17,letterSpacing: 1),),
                                    ],
                                  )),

                              SizedBox(height: 30,),
                              Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [

                                    InkWell(
                                      onTap: () {
                                        if (question_no != 1)
                                        {
                                          question_no = question_no - 1;
                                          aswer = questioList[question_no].answer;
                                          setState(() {});
                                        }
                                      },
                                      child: Container(
                                        width: MediaQuery.of(context).size.width*0.3,
                                        child: Material(
                                          borderRadius: BorderRadius.circular(5),
                                          color: Colors.cyan[100] ,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                            child: Row(
                                              children: [
                                                Icon(Icons.arrow_back,color: Colors.blueAccent,size: 20,),
                                                Text("Previous",style: TextStyle(fontFamily: "Poppins",fontSize: 16),)
                                              ],
                                            ),
                                          )
                                          ,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        if (question_no == (questioList.length-1)) {
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
                                            _showFinishDialog();
                                          }
                                        }
                                        else  {
                                          question_no = question_no + 1;
                                          aswer = questioList[question_no].answer;
                                          setState(() {});
                                        }
                                      },
                                      child: Container(
                                        width: MediaQuery.of(context).size.width*0.27,

                                        child: Material(
                                          borderRadius: BorderRadius.circular(5),
                                          color: Colors.cyan[100] ,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.arrow_forward,color: Colors.blueAccent,size: 25,),
                                                Text("Next  ",style: TextStyle(fontFamily: "Poppins",fontSize: 16),)
                                              ],
                                            ),
                                          )
                                          ,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: (){
                                        if(selectedOptions.contains(0)){
                                          for(int i= 0;i<selectedOptions.length;i++){
                                            if(selectedOptions[i] == 0) {
                                              error = "Tick Question no ${i+1}";
                                              setState(() {

                                              });
                                              break;

                                            }
                                          }
                                        }
                                        else{
                                          _showFinishDialog();
                                        }
                                      },
                                      child: Container(
                                        width: MediaQuery.of(context).size.width*0.27,


                                        child: Material(
                                          borderRadius: BorderRadius.circular(5),
                                          color: Colors.amber ,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.pin_end_outlined,color: Colors.blueAccent,size: 25,),
                                                Text("  Finish",style: TextStyle(fontFamily: "Poppins",fontSize: 15),)


                                              ],
                                            ),
                                          )
                                          ,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                        ],
                      ),
  ],
                  ),

                ],
              ),
            ):
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LoadingAnimationWidget.staggeredDotsWave(
                        color: Colors.blue,
                        size: 80,
                      ),
                      SizedBox(height: 30,),
                      Text("Translating.....",style: TextStyle(fontFamily: "Poppins",fontSize: 20),),
                      SizedBox(height: 100,),

                    ],
                  )),
            ),
        ),
      ),
          bottomNavigationBar: BottomAppBar(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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

                Container(
                  height: 18,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey[200],
                ),
              ],
            ),
          ),),
        )
        : Scaffold(
      body: Container(
        margin: EdgeInsets.only(bottom: 100),
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
    );
  }


  optionItem(String char,int option_no, String option,QuestionModel q) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        onTap: () {
          error = "";

          setState(() {
            OptioSelected = option_no;
          });

          if(selectedOptions[question_no] == 0) {
            if (option != aswer) {
              mistakesQuestioList.add(
                  allQuestionListinEnglish[question_no].statement + "~" +
                      allQuestionListinEnglish[question_no].answer);
              selectedOptions[question_no] = option_no;
            }
            else {
              correct = correct + 1;
              selectedOptions[question_no] = option_no;
            }

            };
          },
        child: Container(
          width: MediaQuery
              .of(context)
              .size
              .width * 0.9,
          decoration: BoxDecoration(
            color: selectedOptions[question_no] == 0
                ? Colors.white
                : selectedOptions[question_no] != 0 && option == aswer
                ? Color(0xff39FF14).withOpacity(0.6)
                : selectedOptions[question_no] == option_no
                ? Colors.red.withOpacity(0.5)
                : Colors.white,
            border: Border.all(color: Colors.grey.withOpacity(0.2), width: 3),
            borderRadius: BorderRadius.circular(15),
          ),
          child:Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 14),
            child: Row(
              children: [
                Row(
                  children: [
                    Text("${char})  ",style: TextStyle(fontFamily: "Poppins",color: Colors.blue),),

                    Container(
                      width: MediaQuery.of(context).size.width*0.65,
                      child: Text(
                        option,
                        style: TextStyle(fontFamily: "PoppinRegular"),
                      ),
                    ),

                  ],
                ),
                selectedOptions[question_no] == option_no && option == aswer
                    ? CircleAvatar(
                  foregroundImage: AssetImage("assets/tick.jpg"),
                  radius: 15,
                )
                    : Visibility(
                  visible: selectedOptions[question_no] == option_no && option != aswer ,
                  child: InkWell(
                    onTap: () {
                      setState(() {});
                    },
                    child: CircleAvatar(
                      foregroundImage: AssetImage("assets/cross.jpg"),
                      radius: 15,
                    ),
                  ),
                ),
              ],
            ),
          )

        ),
      ),
    );
  }

  Future<void> getQuestions() async {
    // var data = await FirebaseFirestore.instance
    //     .collection('questions')
    //     .get(const GetOptions(source: Source.server));
    //
    // if (data.docs.isNotEmpty) {
    //   print("exisr");
    //   setState(() {
    //     questioList =
    //         List.from(data.docs.map((doc) => QuestionModel.fromSnapshot(doc)));
    widget.quizToPerform.questions.forEach((element) {
      QuestionModel questionModel = QuestionModel(
          image: element['image'],
          statement: element['statement'],
          optionA: element['optionA'],
          option2: element['option2'],
          optionC: element['optionC'],
          optionD: element['optionD'],
          answer: element['answer']);
      questioList.add(questionModel);


    });

    aswer = questioList[question_no].answer;

    questioList.forEach((element) {

      selectedOptions.add(0);
        print("Shuffle");
        List<String> opti = [
          element.optionA,
          element.option2,
          element.optionC
        ];

      if(element.optionD != ""){
        opti.add(element.optionD);
      }
        opti.shuffle();

        element.optionA = opti[0];
        element.option2 = opti[1];
        element.optionC = opti[2];
      if(element.optionD !="") {
        element.optionD = opti[3];
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

      else if(element.optionD == element.answer){
        correctOptions.add(4);
      }

    });
        isLoaded = true;

  }


  Future<void> _showTimeoutDialog() {
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
                    "Your Quiz time has been out....",
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
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 70),
                    child: InkWell(
                      onTap: () async {
                        saveData();

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

  Future<void> _showFinishDialog() {
    bool isLoading= false;

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
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter innerSetState) {
             return WillPopScope(
                onWillPop: ()async{
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
                        "Your Made ${correct} corrects....",
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
                            saveData();}
                          },

                          child: Material(
                            borderRadius:
                            const BorderRadius.all(
                                Radius.circular(8)),
                            elevation: 6,
                            color: Colors.yellow,
                            child:isLoading?
                            Center(
                                child: LoadingAnimationWidget.staggeredDotsWave(
                                  color: Colors.blue,
                                  size: 40,
                                ))
                                :Container(
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
                ),
              );}
            );
          });
  }

  Future<void> savData() async {

    String a = DateTime
        .now()
        .microsecondsSinceEpoch
        .toString();

    quizModel q = quizModel(
        id: a,
        date: a,
        totalQuestions: questioList.length.toString(),
        correct: correct.toString(),
        time: countDownController.getTime().toString(),
    mistakes: mistakesQuestioList, mode: 'Study');

    await FirebaseFirestore.instance.collection("students").
    doc(email).collection("quizes").doc(a).set(q.toMap());

    List<dynamic> temp = [];
    temp.addAll(widget.completedQuiz);
    temp.add(widget.quizToPerform.id);
    await FirebaseFirestore.instance.collection("students").
    doc(email).collection("completedQuizes").doc("quizes").set(
        {
          "completedQuizes":temp
        }

    );
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => mainMenu(isfromLogin: false, checkUpdate: false,)));

  }
  Future<void> saveData() async {

    String a = DateTime
        .now()
        .microsecondsSinceEpoch
        .toString();

    quizModel q = quizModel(
        id: a,
        date: a,
        totalQuestions: questioList.length.toString(),
        correct: correct.toString(),
        time: countDownController.getTime().toString(),
    mistakes: mistakesQuestioList, mode: 'Study');


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
    temp.addAll(widget.completedQuiz);
    temp.add(widget.quizToPerform.id);
    await FirebaseFirestore.instance.collection("students").
    doc(email).collection("completedQuizes").doc("quizes").set(
        {
          "completedQuizes":temp
        }

    );
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => mainMenu(isfromLogin: false, checkUpdate: false,)));

  }


  Widget statementWidget (String statement){

    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,

      color: Color(0xff00aeff).withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          statement,
          style: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Future<void> selectLanguage( context) {
    TextEditingController controller = TextEditingController();
     return showDialog(
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
                                        height: MediaQuery.of(context).size.height * 0.5,
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
                                  ,SizedBox(height: 10,)
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

}
