
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/scheduler.dart';
import 'dart:math' as math;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

import '../Models/QuizModel.dart';
import '../Models/QuizToPerformModel.dart';
import '../Models/question.dart';
import '../services_Screen/photoView.dart';
import 'main_menuScreen.dart';

class reviseModeScreen extends StatefulWidget {
  String isLanguageTranslation;
  quizToPerformModel quizToPerform;
  reviseModeScreen({Key? key, required this.quizToPerform,required this.isLanguageTranslation}) : super(key: key);

  @override
  State<reviseModeScreen> createState() => _reviseModeScreenState();
}

class _reviseModeScreenState extends State<reviseModeScreen> {
  bool isOptioSelected = false;
  bool isLoaded = false;
  bool isSelected = false;
  bool showError = false;


  int OptioSelected = 0;
  int question_no = 0;
  final GlobalKey<NavigatorState> key = new GlobalKey<NavigatorState>();
  String aswer = "The Lane ahead is Closed";
  late List<QuestionModel> questioList= [];
  late List<String> mistakesQuestioList= [];
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
    isTranslated = true;
    islangugeSelected= true;
    // if(widget.isLanguageTranslation == "true" ){
    //   SchedulerBinding.instance.addPostFrameCallback((_) {
    //     selectLanguage(key.currentContext);
    //   });}
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
        print(selectedLanguge);
        await translator.translate(questioList[i].statement,from: 'en',to: selectedLanguge).then((value) {
          tempList[i].statement = value.text;
        });
        await translator.translate(questioList[i].optionA,from: 'en',to: selectedLanguge).then((value) {
          tempList[i].optionA = value.text;
        });
        await translator.translate(questioList[i].option2,from: 'en',to: selectedLanguge).then((value) {
          tempList[i].option2 = value.text;
        });
        await translator.translate(questioList[i].optionC,from: 'en',to: selectedLanguge).then((value) {
          tempList[i].optionC = value.text;
        });

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

  @override
  Widget build(BuildContext context) {
    return isLoaded
        ? Scaffold(
      key: key,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isTranslated && islangugeSelected?Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: MediaQuery
              .of(context)
              .size
              .height,
          alignment: Alignment.topCenter,
          child: Column(
            children: [


              // Material(
              //   child: Text("  Question ${question_no+1}/${questioList.length}  ",style: TextStyle(fontSize: 16,color: Colors.orange,fontWeight: FontWeight.bold),),
              //   borderRadius: BorderRadius.all(Radius.circular(20)),
              //   color: Colors.blue[700],
              //   elevation: 6,
              // ),

              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    InkWell(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Material(
                          child: Icon(Icons.close_rounded)

                      ),
                    ),
                    Container(
                      width:  MediaQuery.of(context).size.width *0.3,
                      child: FittedBox(child: Text("Revision",style: TextStyle(fontFamily: "Poppins",fontSize: 22),)),

                    ),

                    Material(
                        color: Colors.transparent,
                        child: Icon(Icons.close_rounded,color: Colors.transparent,)

                    ),


                  ],
                ),
              ),
              SizedBox(height: 20,),
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
                      value: (question_no+1) / questioList.length,
                    ),
                  ),
                  Text("   "),
                  Text(
                    (question_no +1).toString() +
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
              SizedBox(height: 20,),


              Visibility(
                visible:questioList[question_no].image !="",
                child: InkWell(
                  onTap: (){
                    // Navigator.pushReplacement(
                    //     context, MaterialPageRoute(builder: (context) =>previewImage(imageUrls:[ questioList[question_no].image], index: 0)));

                    Navigator.of(context).push(new MaterialPageRoute<Null>(
                        builder: (BuildContext context) {
                          return new previewImage(imageUrls: [questioList[question_no].image], index: 0, isFile: false, question: questioList[question_no],);
                        },
                        fullscreenDialog: true));
                  },
                  child: Padding(padding: EdgeInsets.only(top: 20)
                    , child: Material(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        questioList[question_no].image,
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.15,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    height:MediaQuery.of(context).size.height*0.02
                  ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10, horizontal: 24),
                child: Material(
                  borderRadius: BorderRadius.circular(6),
                  clipBehavior: Clip.antiAlias,
                  elevation: 6,
                  child:statementWidget(questioList[question_no].statement),
                ),
              ),

                  const SizedBox(
                    height: 24,
                  ),
                  Text("Answer",style: TextStyle(fontFamily: "Poppins",fontSize: 16),),
                  optionItem(1, questioList[question_no].answer,questioList[question_no]),

                ],
              ),
            ],
          ),
        ):
        Center(
          child: CircularProgressIndicator(),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        child: Visibility(
          visible: isTranslated && islangugeSelected,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // IconButton(onPressed: (){
                //   question_no = question_no  - 1;
                //   aswer = questioList[question_no].answer;
                //   OptioSelected =0;
                //   setState(() {
                //   });
                //
                //   }, icon: Icon(Icons.arrow_back_ios,color: Colors.white,size: 30,)),

                InkWell(
                  onTap: () {
                    if (question_no > 0)
                    {
                      question_no = question_no - 1;
                      setState(() {});}

                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width*0.45,
                    child: Padding(
                      padding: const EdgeInsets.all(0),
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue[600],
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.arrow_back_ios,color: Colors.white,),
                              Text(" Previous    ",
                                  style: TextStyle(
                                      fontFamily: "PoppinRegular",
                                      fontSize: 17,
                                      color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (question_no < (questioList.length-1)) {
                      // _showFinishDialog();
                      question_no = question_no + 1;
                      setState(() {});
                    }

                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width*0.45,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        color:Colors.blue[600],
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Next   ",
                                  style: TextStyle(
                                      fontFamily: "PoppinRegular",
                                      fontSize: 17,
                                      color:Colors.white)),
                              Icon(Icons.arrow_forward_ios,color: Colors.white,)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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

  optionItem(int option_no, String option,QuestionModel q) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: () {
        },
        child: Container(
          width: MediaQuery
              .of(context)
              .size
              .width * 0.9,
          decoration: BoxDecoration(
            color: Colors.green[100],
            border: Border.all(color: Colors.grey.withOpacity(0.2), width: 3),
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            title: Text(
              option,
              style: TextStyle(fontFamily: "Poppins", fontSize: 14),
            ),
          ),
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

    await FirebaseFirestore.instance.collection("students").
    doc(email).collection("quizes").doc(a).set(q.toMap());

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
          maxLines: 4,
          style: TextStyle(

            overflow: TextOverflow.ellipsis,
              fontSize: 16,
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
                  )
              ),
            );
          });
        });




  }

}
