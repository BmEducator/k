import 'dart:io';

import 'package:bmeducators/Models/studentModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'edit_student_Screen.dart';

class studentSettings extends StatefulWidget {
  studentModel student ;
   studentSettings({Key? key,required this.student}) : super(key: key);

  @override
  State<studentSettings> createState() => _studentSettingsState();
}

class _studentSettingsState extends State<studentSettings> {
  String accessDate = "";
  String tempaccessDate = "";
  String mode = "";
  String revise = "";
  String isTranslation = "";
  String translationLanguge = "";
  List<String> noOfActivations = [];




  @override
  void initState() {
    // TODO: implement initState
    translationLanguge = widget.student.translation;
    print(widget.student.translation);
    mode = widget.student.mode;
    revise = widget.student.revise;

  if(widget.student.accessDate !=""){
    var f = new DateFormat('dd-MM-yyyy');
    tempaccessDate =f.format(DateTime.fromMillisecondsSinceEpoch(int.parse(widget.student.accessDate))).toString();
    setState(() {

    });
  }

    List<String>? noOf = ( widget.student.noOfActivations as List )?.map((item) => item as String)?.toList();
    noOfActivations = noOf!;
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child:Padding(
            padding:EdgeInsets.all(20),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               InkWell(
                   onTap: (){
                     Navigator.pop(context);
                   },
                   child: Icon(Icons.arrow_back_ios,color: Colors.black,)),
               SizedBox(height: 20,),

               Text("Student Settings",style: TextStyle(fontSize: 28,fontFamily: "Poppins",color: Colors.lightBlue),),
                 SizedBox(height: 40,),

               InkWell(
                 onTap: (){
                   _showEditDialog(context, widget.student);
                 },
                 child: Material(
                   borderRadius: BorderRadius.circular(5),
                    color: Colors.green,
                     elevation: 5,
                     child: Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Text("      Edit Profile      ",style: TextStyle(fontFamily: "PoppinRegular",color: Colors.white,fontSize: 18),),
                     )),
               ),
               SizedBox(height: 20,),

               Container(
                 padding: EdgeInsets.only(right: 60),
                 width: MediaQuery.of(context).size.width *1,
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Text("Study Mode",style: TextStyle(fontSize: 20,fontFamily: "Poppins"),),
                     Switch(
                         value: mode == "Study" || mode == "Both", onChanged: (r) {
                       _showModeDialog(context, "Study");
                     }),
                   ],
                 ),
               ),
               SizedBox(height: 15,),
               Container(
                 padding: EdgeInsets.only(right: 60),
                 width: MediaQuery.of(context).size.width *1,
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Text("Exam Mode",style: TextStyle(fontSize: 20,fontFamily: "Poppins"),),
                     Switch(
                         value: mode == "Exam" || mode == "Both", onChanged: (r) {
                       _showModeDialog(context, "Exam");
                     }),
                   ],
                 ),
               ),
               SizedBox(height: 15,),
               Container(
                 padding: EdgeInsets.only(right: 60),
                 width: MediaQuery.of(context).size.width *1,
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Text("Revise Mode",style: TextStyle(fontSize: 20,fontFamily: "Poppins"),),
                     Switch(value: revise=="true", onChanged: (r){
                       _showReviseDialog(context, r.toString());
                     }),
                   ],
                 ),
               ),
               SizedBox(height: 15,),
               Container(
                 padding: EdgeInsets.only(right: 60),
                 width: MediaQuery.of(context).size.width *1,
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Text("Google Translation",style: TextStyle(fontSize: 20,fontFamily: "Poppins"),),
                     Switch(value:translationLanguge == "true", onChanged: (r){
                     if(r){
                       translationLanguge =  "true";
                       isTranslation = "true";
                     }
                     else{
                       isTranslation = "false";
                       translationLanguge = "false";
                     }

                       _showTranslationDialog(context);

                     }),
                   ],
                 ),
               ),
               SizedBox(height: 15,),
               Container(
                 padding: EdgeInsets.only(right: 60),
                 width: MediaQuery
                     .of(context)
                     .size
                     .width * 1,
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Text("No of Activations  ", style: TextStyle(
                         fontSize: 15, fontFamily: "Poppins"),),
                     InkWell(
                       onTap: (){
                         _showNoOfActivationDialog(context);
                       },
                       child: Row(
                         children: [
                           Text(noOfActivations.length.toString(),style: TextStyle(fontFamily: "Poppins",fontSize: 18),),
                           Icon(Icons.arrow_drop_down,size: 45,color: Colors.blue,)
                         ],
                       ),
                     )
                   ],
                 ),
               ),
               SizedBox(height: 15,),

               Visibility(visible: tempaccessDate =="",child:
               InkWell(
                 onTap: (){
                   _showLimitDialog();
                 },
                 child: Material(
                     borderRadius: BorderRadius.circular(5),
                     color: Colors.red,
                     elevation: 5,
                     child: Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Text("    Limit her/his Access   ",style: TextStyle(fontFamily: "PoppinRegular",color: Colors.white,fontSize: 18),),
                     )),
               ),
               ),


               SizedBox(height: 15,),
               Visibility(visible: tempaccessDate !="",child:   Text("Student is Limited to : ${tempaccessDate}",style: TextStyle(fontFamily: "Poppins",fontSize: 17,color: Colors.red),)
               ),
               SizedBox(height: 20,),
               InkWell(
                 onTap: (){
                   _showRenewLimitDialog();
                 },
                 child: Material(
                     borderRadius: BorderRadius.circular(5),
                     color: Colors.blue[500],
                     elevation: 5,
                     child: Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Text(" Renew Activation",style: TextStyle(fontFamily: "PoppinRegular",color: Colors.white,fontSize: 18),),
                     )),
               ),

               // Visibility(visible: tempaccessDate !="",child:
               // Padding(
               //   padding: const EdgeInsets.only(bottom: 20),
               //   child: InkWell(
               //     onTap: (){
               //       _showRemoveLimitDialog(context);
               //     },
               //     child: Material(
               //         borderRadius: BorderRadius.circular(5),
               //         color: Colors.red,
               //         elevation: 5,
               //         child: Padding(
               //           padding: const EdgeInsets.all(8.0),
               //           child: Text("     Remove Limit     ",style: TextStyle(fontFamily: "PoppinRegular",color: Colors.white,fontSize: 18),),
               //         )),
               //   ),
               // ),
               // ),
               SizedBox(height: 20,),


               InkWell(
                 onTap: (){
                   _showResetDevicesDialog(context, "");
                 },
                 child: Material(
                     borderRadius: BorderRadius.circular(5),
                     color: Colors.grey[500],
                     elevation: 5,
                     child: Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Text(" Reset Login Devices ",style: TextStyle(fontFamily: "PoppinRegular",color: Colors.white,fontSize: 18),),
                     )),
               ),
               SizedBox(height: 20,),

             ],
           ),
          )
        ),
      ),
    );
  }


  Future<void> _showLimitDialog() {
    TextEditingController controller = TextEditingController();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const Icon(Icons.close),
                        ),
                      ),
                      Text("               Select Limit",style: TextStyle(fontFamily: "Poppins"),)
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                      height: 100,
                      child:CupertinoDatePicker(
                        dateOrder: DatePickerDateOrder.dmy,
                        mode: CupertinoDatePickerMode.date,
                        initialDateTime: DateTime.now().add(Duration(days: 1)),
                        onDateTimeChanged: (DateTime newDate){
                            accessDate = newDate.millisecondsSinceEpoch.toString();
                          // dateOfbirth = newDate;
                        },
                      )
                  ),
                  Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Material(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      elevation: 6,
                      color: Colors.blue,
                      child: InkWell(
                        onTap: () async {

                          await FirebaseDatabase.instance.ref().child("students").child(widget.student.dni).
                          child("accessLimit").child("limit").set({
                            "timestamp":accessDate ,
                          });

                           await FirebaseFirestore.instance.collection("admin").doc(
                              "data").collection("students").doc(
                              "allStudents").collection("allStudents")
                              .doc(widget.student.email).
                          update({"accessDate":accessDate});
                          var f = new DateFormat('dd-MM-yyyy');

                          tempaccessDate =f.format(DateTime.fromMillisecondsSinceEpoch(int.parse(accessDate))).toString();
                          widget.student.accessDate = accessDate;
                          Navigator.pop(context);
                          setState(() {
                            
                          });
                          
                          
                        },
                        child: Container(
                          height: 40,
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: const Text(
                            'Save ',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontFamily: "Poppins"),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
  Future<void> _showRenewLimitDialog() {
    TextEditingController controller = TextEditingController();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const Icon(Icons.close),
                        ),
                      ),
                      Text("               Select New Limit",style: TextStyle(fontFamily: "Poppins"),)
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                      height: 100,
                      child:CupertinoDatePicker(
                        dateOrder: DatePickerDateOrder.dmy,
                        mode: CupertinoDatePickerMode.date,
                        initialDateTime: DateTime.now().add(Duration(days: 1)),
                        onDateTimeChanged: (DateTime newDate){
                          accessDate = newDate.millisecondsSinceEpoch.toString();
                          // dateOfbirth = newDate;
                        },
                      )
                  ),
                  Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Material(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      elevation: 6,
                      color: Colors.blue,
                      child: InkWell(
                        onTap: () async {

                          await FirebaseDatabase.instance.ref().child("students").child(widget.student.dni).
                          child("accessLimit").child("limit").set({
                            "timestamp":accessDate ,
                          });

                          noOfActivations.add(DateTime.now().millisecondsSinceEpoch.toString());

                          int renewNo = widget.student.noOfActivation +1;
                          await FirebaseFirestore.instance.collection("admin").doc(
                              "data").collection("students").doc(
                              "allStudents").collection("allStudents")
                              .doc(widget.student.email).
                          update({"accessDate":accessDate,
                          "noOfActivations":noOfActivations},);
                          var f = new DateFormat('dd-MM-yyyy');

                          tempaccessDate =f.format(DateTime.fromMillisecondsSinceEpoch(int.parse(accessDate))).toString();
                          widget.student.accessDate = accessDate;
                          Navigator.pop(context);
                          setState(() {

                          });


                        },
                        child: Container(
                          height: 40,
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: const Text(
                            'Save ',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontFamily: "Poppins"),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }


  Future<void>? _showRemoveLimitDialog(BuildContext context ) async {
    return (
        await showDialog(context: context,
            builder: (context)
            =>
                AlertDialog(
                  content: const Text("Do you want to Remove Limit?",
                    style: TextStyle(fontFamily: "PoppinRegular"),),
                  actions: [
                    TextButton(onPressed: () {
                      Navigator.pop(context);
                    },
                      child: const Text(
                          "No", style: TextStyle(fontFamily: "Poppins")),),
                    TextButton(onPressed: () async {

                      FirebaseDatabase.instance.ref().child("students").child(widget.student.email.substring(0,widget.student.email.indexOf("@"))).
                      child("accessLimit").remove();
                 await FirebaseFirestore.instance.collection("admin").doc(
                          "data").collection("students").doc(
                          "allStudents").collection("allStudents")
                          .doc(widget.student.email).
                      update({"accessDate":""});
                      tempaccessDate = "";
                      accessDate = "";
                      Navigator.pop(context);
                      setState(() {

                      });

                    },
                      child: const Text("Yes", style: TextStyle(
                          color: Colors.grey, fontFamily: "Poppins")),),
                  ],
                )
        )
    );


  }

  Future<void>? _showTranslationDialog(BuildContext context ) async {
    print(translationLanguge);
    return (
        await showDialog(context: context,
            builder: (context)
            =>
                AlertDialog(
                  content:  Text(translationLanguge != "false"?"Do you want to Activate Language Translator?":"Do you want to Remove Language Translator?",
                    style: TextStyle(fontFamily: "PoppinRegular"),),
                  actions: [
                    TextButton(onPressed: () {
                      Navigator.pop(context);
                    },
                      child: const Text(
                          "No", style: TextStyle(fontFamily: "Poppins")),),
                    TextButton(onPressed: () async {

                      await FirebaseFirestore.instance.collection("admin").doc(
                          "data").collection("students").doc(
                          "allStudents").collection("allStudents")
                          .doc(widget.student.email).
                      update({
                        "translation":translationLanguge
                      });

                      Navigator.pop(context);
                      setState(() {

                      });

                    },
                      child: const Text("Yes", style: TextStyle(
                          color: Colors.grey, fontFamily: "Poppins")),),
                  ],
                )
        )
    );


  }
  Future<void> _showEditDialog(BuildContext context, studentModel std) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(

              contentPadding: EdgeInsets.zero,
              content: editStudentScreen(student: std, accessLimit: accessDate,));
        });
  }
  Future<void>? _showModeDialog(BuildContext context, String Mode) async {
    return (
        await showDialog(context: context,
            builder: (context) =>
                AlertDialog(
                  content: const Text("Do you want to Change Mode?",
                    style: TextStyle(
                        fontFamily: "PoppinRegular", fontSize: 14),),
                  actions: [
                    TextButton(onPressed: () {
                      Navigator.pop(context);
                    },
                      child: const Text(
                          "No", style: TextStyle(
                          fontFamily: "Poppins", fontSize: 14)),),
                    TextButton(
                      onPressed: () async {
                        if(Mode == "Exam"){
                          print (mode + "---");

                          if(mode == "Exam" || mode == "Both"){
                            mode = "Study";
                            print("1");
                            print(mode);

                          }
                          else if(mode == "Study"){
                            mode = "Both";
                            print("2");

                            print(mode);
                          }
                        }
                        else if(Mode == "Study"){
                          print (mode + "---");

                          if(mode == "Study" || mode == "Both"){
                            mode = "Exam";
                            print("3");

                            print(mode);

                          }
                          else if(mode == "Exam"){
                            mode = "Both";
                            print("4");

                            print(mode);
                          }

                        }

                        await FirebaseFirestore.instance.collection("admin")
                            .doc(
                            "data").collection("students").doc(
                            "allStudents").collection("allStudents")
                            .doc(widget.student.email)
                            .update({

                          "mode": mode
                        });

                        setState(() {

                        });

                        Navigator.pop(context);

                        setState(() {

                        });
                      },
                      child: const Text("Yes", style: TextStyle(
                          color: Colors.grey,
                          fontFamily: "Poppins",
                          fontSize: 14)),),
                  ],
                )
        )
    );
  }

  Future<void>? _showReviseDialog(BuildContext context, String r) async {
    return (
        await showDialog(context: context,
            builder: (context)
            =>
                AlertDialog(
                  content: const Text("Do you want to Change Revision Setting?",
                    style: TextStyle(fontFamily: "PoppinRegular"),),
                  actions: [
                    TextButton(onPressed: () {
                      Navigator.pop(context);
                    },
                      child: const Text(
                          "No", style: TextStyle(fontFamily: "Poppins")),),
                    TextButton(onPressed: () async {

                      await FirebaseFirestore.instance.collection("admin").doc(
                          "data").collection("students").doc(
                          "allStudents").collection("allStudents")
                          .doc(widget.student.email).update({
                        "revise":r.toString()
                      });
                      revise = r;
                      setState(() {

                      });

                      Navigator.pop(context);

                      setState(() {

                      });

                    },
                      child: const Text("Yes", style: TextStyle(
                          color: Colors.grey, fontFamily: "Poppins")),),
                  ],
                )
        )
    );


  }
  Future<void>? _showResetDevicesDialog(BuildContext context, String r) async {
    return (
        await showDialog(context: context,
            builder: (context)
            =>
                AlertDialog(
                  content: const Text("Do you want to Remove Device that is currently login with this Account?",
                    style: TextStyle(fontFamily: "PoppinRegular"),),
                  actions: [
                    TextButton(onPressed: () {
                      Navigator.pop(context);
                    },
                      child: const Text(
                          "No", style: TextStyle(fontFamily: "Poppins")),),
                    TextButton(onPressed: () async {
                      await FirebaseFirestore.instance.collection(
                          "admin").doc("data").collection("students").doc("login").collection("logins").doc(widget.student.email).
                      update({"loginAt":""});
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text("Device is Removed for this Account..")));

                    },
                      child: const Text("Yes", style: TextStyle(
                          color: Colors.grey, fontFamily: "Poppins")),),
                  ],
                )
        )
    );


  }

  Future<void> _showNoOfActivationDialog(BuildContext context) {
    return showDialog(
        context: context,

        builder: (BuildContext context) {
          return Dialog(
              child:SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width *0.2,
                  child: Column(
                    children: [
                      Text("  Date of Activation"),
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          DateFormat dateformat = DateFormat("yyyy-MM-dd");
                          String s;
                          s =  dateformat.format(DateTime.fromMillisecondsSinceEpoch(int.parse(noOfActivations[index])));
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 0),
                            child: Chip(
                              backgroundColor: Colors.lightBlue[100],
                              label: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("  "+(index+1).toString()+ "   "),
                                  Text(s,style: TextStyle(fontFamily: "PoppinRegular"),),
                                ],
                              ),
                            ),
                          );
                        },
                        itemCount:noOfActivations.length,
                      )
                    ],
                  ),
                ),
              ));
        });
  }



}
