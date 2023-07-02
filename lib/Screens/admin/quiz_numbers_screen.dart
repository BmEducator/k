import 'dart:io';

import 'package:bmeducators/Models/QuizModelForBank.dart';
import 'package:bmeducators/Screens/admin/Created_quiz_Detail_inBank.dart';
import 'package:bmeducators/Screens/admin/createQuizInBank.dart';
import 'package:bmeducators/Screens/admin/questionPank_categories.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;



import '../../Models/QuizModel.dart';
import '../../Models/question.dart';

class quizNoScreen extends StatefulWidget {
  String familyName;
   quizNoScreen({Key? key,required this.familyName}) : super(key: key);

  @override
  State<quizNoScreen> createState() => _quizNoScreenState();
}

class _quizNoScreenState extends State<quizNoScreen> {

  late List<quizModelForBank> quizesList = [];
  bool isLoading = true;
  bool hasData = false;
  String email = "";
  late List<QuestionModel> questionList =[];
  double searchAnimatedWidth = 0.2;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getQuizes();
  }

  Future<bool> willpop() async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => questionPankCategories()));
    return  true;

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: willpop,
      child: Scaffold(
          body: GestureDetector(
            onTap: (){
              searchAnimatedWidth != 0.2? searchAnimatedWidth =0.2:
              searchAnimatedWidth= 0.75;
              setState((){

              });
              FocusScope.of(context).requestFocus(new FocusNode());

            },
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(padding: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[

                          InkWell(
                              onTap:(){
                                Navigator.pushReplacement(
                                    context, MaterialPageRoute(builder: (context) => questionPankCategories()));

                              },
                              child: Icon(Icons.arrow_back_ios)),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 120),
                              width: MediaQuery.of(context).size.width * searchAnimatedWidth,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width* 0.8,
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height * 0.06,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
                                  child: Autocomplete<QuestionModel>(
                                    optionsMaxHeight: 10,
                                    optionsViewBuilder: (context, Function onSelected,
                                        Iterable<QuestionModel> options) {
                                      return Align(
                                        alignment: Alignment.topLeft,
                                        child: Material(
                                          elevation: 10,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width - 100,
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
                                                  //   Navigator.pushReplacement(
                                                  //       context, MaterialPageRoute(builder:
                                                  //       (context) => searchedQuestion(allquestionList: questionList, searchText: "", searchedquestionList: [questionList[index]])));
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
                                        return questionList.where((element) =>
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
                                                setState(() {
                                                  searchAnimatedWidth != 0.2? searchAnimatedWidth =0.2:
                                                  searchAnimatedWidth= 0.75;
                                                });
                                                // Navigator.pushReplacement(
                                                //     context, MaterialPageRoute(builder:
                                                //     (context) => searchedQuestion(allquestionList: questionList, searchText: searchText,searchedquestionList: questionList.where((element) =>
                                                //     element.statement.toLowerCase().contains(
                                                //         controller.text.toLowerCase())).toList(),)));

                                              },
                                              icon: const Icon(Icons.search_outlined),
                                            ),
                                            label: Visibility(
                                              visible: searchAnimatedWidth == 0.75,
                                              child: const Text(
                                                "Search Question",
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontFamily: "PoppinRegular"),
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.blue,width: 1),
                                              borderRadius: BorderRadius.circular(20)
                                            )),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                    SizedBox(height: 5,),
                    Text(
                     "    "+ widget.familyName,
                      style: TextStyle(fontFamily: "Poppins", fontSize: 25,letterSpacing: 1),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [

                        InkWell(
                          onTap: (){
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => createQuizInBank
                                  (familyName: widget.familyName, QuizNo: quizesList.length+1,)));

                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Material(
                              elevation: 4,
                              color: Colors.blue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: const [
                                    Icon(Icons.add_circle,color: Colors.white,),
                                    Text(
                                      " Create New Quiz   ",
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

                    Divider(
                      thickness: 4,
                    ),

                    !isLoading?
                    Container(
                      child:
                      hasData
                          ? ListView.builder(
                        reverse: true,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        itemBuilder: (context, index) {
                          return InkWell(
                            child: containerItem(index)
                          );
                        },
                        itemCount: quizesList.length,
                      )
                          : const Text(
                        "No Quiz to show",
                        style: TextStyle(
                            fontFamily: "PoppinRegular",
                            fontSize: 20,
                            color: Colors.blue),
                      ) ,
                    ):

                    !isLoading && quizesList.length ==0 ?
                    Container(
                      height: MediaQuery.of(context).size.height*0.4,
                      margin: const EdgeInsets.only(bottom: 0),
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
                                        width: 30,
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
                    ):
                    Container(
                        height: MediaQuery.of(context).size.height*0.4,
                        child: Center(child: Text("No Quiz",style: TextStyle(fontFamily: "PoppinRegular",fontSize: 17),))),
                    SizedBox(height: 30,),
                  ],
                ),

                ),
              ),
            ),
          ),
      ),
    );
  }
  Widget containerItem(int i) {
    // var d = DateTime.fromMicrosecondsSinceEpoch(int.parse(quizesList[i].date));
    // var a = DateFormat('dd-MM-yyyy').format(d);
    // var t = DateFormat('hh:mm').format(d);

    return Padding(
      padding: const EdgeInsets.only(bottom: 15,right: 0,left: 0),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Material(
            borderRadius: BorderRadius.circular(10),
            elevation: 10,
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: (){
                Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>
                            quizDetailInBank(quiz: quizesList[i], quizno: i+1, familyname: widget.familyName,)
                    ));

              },
              child: Container(
                  color: Color(0xff00aeff).withOpacity(0.2),
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
                          Text("Total Questions",style: TextStyle(fontFamily: "Poppins"),),
                          Text(quizesList[i].questions.length.toString(),style: TextStyle(fontFamily: "Poppins",fontSize: 16),),
                        ],
                      ),



                    ],
                  )
              ),
            ),
          ),
          InkWell(
            onTap: (){
              _showDeleteDialog(context, i);
            },
            child: Material(
              color: Colors.black.withOpacity(0.2),
              elevation: 5,
              child: Icon(Icons.close,color: Colors.grey[200],),
            ),
          )
        ],
      )
    );
  }


  Future<void> getQuizes() async {

    await FirebaseFirestore.instance.collection("admin").
    doc("data").collection("QuestionBank")
        .doc("Families").collection(widget.familyName).get(GetOptions(source: Source.server)).then((value) => {
      value.docs.forEach((element) {
        print(element['id']);
    quizModelForBank q = quizModelForBank(
    id: element['id'],
    questions: element['questions'],
    mode: element['mode'],
    timestamp: element['timestamp']);
    quizesList.add(q);

    q.questions.forEach((element) {

      QuestionModel qw= QuestionModel(
          image: element['image'],
          statement: element['statement'],
          optionA: element['optionA'],
          option2: element['option2'],
          optionC: element['optionC'],
          answer: element['answer']);
      questionList.add(qw);

    });

    })});

    if( quizesList.length>0){
      isLoading = false;
      hasData = true;
    }


    setState(() {

    });

  }

    Future<void>? _showDeleteDialog(BuildContext context,int index) async {
    return (
    await showDialog(context: context,
    builder: (context)
    =>
    AlertDialog(
    content: const Text("Do you want to delete this Quiz?",
    style: TextStyle(fontFamily: "PoppinRegular"),),
    actions: [
    TextButton(onPressed: () {
    Navigator.pop(context);
    },
    child: const Text(
    "No", style: TextStyle(fontFamily: "Poppins")),),
    TextButton(onPressed: () async {
      await FirebaseFirestore.instance.collection("admin").
      doc("data").collection("QuestionBank")
          .doc("Families").collection(widget.familyName)
          .doc(quizesList[index].timestamp).delete();


      quizesList[index].questions.forEach((element) async {
        if(element["image"] != ""){
          try {
            await firebase_storage.FirebaseStorage.instance
                .refFromURL(element["image"] )
                .delete();
          } catch (e) {


            print(e);
            print("------------");
          };
        }
      });

      firebase_storage.FirebaseStorage.instance
          .ref()
          .child('Quizes/${quizesList[index].timestamp}').delete();

      quizesList.removeWhere((element) => element.timestamp == quizesList[index].timestamp);

    setState(() {

    });
    Navigator.pop(context);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Quiz Deleted")));
    update();
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
}
