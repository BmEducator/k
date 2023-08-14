import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../Models/studentModel.dart';
import 'package:http/http.dart' as http;

class promoScreen extends StatefulWidget {
  const promoScreen({Key? key}) : super(key: key);

  @override
  State<promoScreen> createState() => _promoScreenState();
}

class _promoScreenState extends State<promoScreen> {
  TextEditingController messageController = TextEditingController();

  List<studentModel> studentsList = [];
  List<studentModel> selectedStudentsList = [];
  List<studentModel> allStudentlist = [];
  bool isLoading = false;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    InkWell(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back_ios),

                    ),
                  SizedBox(height: 30,),

                  Text(
                    "Promotions |",
                    style: TextStyle(fontFamily: "Poppins", fontSize: 25),
                  ),
                  SizedBox(
                    height: 40,
                  ),

                  InkWell(
                    onTap: () async {
                      if(studentsList.isEmpty){
                        await getStudents();
                        print("getiing");
                      }
                      else{
                        print("dsfd");
                      }

                      for(int i = 0 ; i<selectedStudentsList.length ; i++){
                        studentsList.removeWhere((element) => element.email == selectedStudentsList[i].email);
                        studentsList.insert(0, selectedStudentsList[i]);

                      }


                      setState(() {
                        addStudents(context);
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Material(
                        elevation: 4,
                        color: Colors.lightBlue,
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
                                " Add Students   ",
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
                  SizedBox(height: 10,),
                  Text("${selectedStudentsList.length} Students Selected"),
                  SizedBox(height: 20,),


                  Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(10),
                    clipBehavior: Clip.antiAlias,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.lightBlueAccent.withOpacity(0.2),
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child:   TextField(
                        maxLines: 7,
                        controller: messageController,
                        decoration:  InputDecoration(
                          filled: true,
                          contentPadding: EdgeInsets.only(
                              left: 20
                          ),
                          border: InputBorder.none,
                          hintText: "Message",
                          labelText: "Message",
                        ),

                      ),
                    ),
                  ),

                SizedBox(height: MediaQuery.of(context).size.height * 0.15,),

                InkWell(

                      onTap: () {
                        selectedStudentsList.forEach((element) {
                          print(element.token);

                          sendPushMessage(messageController.text, element.token,
                              element.name,element.email);
                        });

                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Material(
                        elevation: 4,
                        color: Colors.orange,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:isLoading?
                          Center(
                              child: LoadingAnimationWidget.staggeredDotsWave(
                                color: Colors.blue,
                                size: 30,
                              ))
                              :Row(

                            children:  [
                              Spacer(),
                              Icon(
                                Icons.send_rounded,
                                color: Colors.white,
                              ),

                              Text(
                                "   Send   ",
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 18,
                                    color: Colors.white),
                              ),
                              Spacer()
                            ],
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
      ),
    );
  }

  Future<void> addStudents(BuildContext context) {
    List<studentModel> tempList = [];
    tempList.addAll(selectedStudentsList);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (thisLowerContext, innerSetState) {
            return Dialog(
              child: Scaffold(
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Students",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 20,
                            color: Colors.blue),
                      ),
                      Divider(
                        thickness: 3,
                      ),
                      SizedBox(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.06,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 1,


                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
                          child: Autocomplete<studentModel>(
                            optionsMaxHeight: 10,
                            optionsViewBuilder: (context, Function onSelected,
                                Iterable<studentModel> options) {
                              return Align(
                                alignment: Alignment.topLeft,
                                child: Material(
                                  elevation: 10,
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width - 120,
                                    child: ListView.separated(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (context, index) {
                                        studentModel option = options.elementAt(index);
                                        return ListTile(
                                          title: Text(
                                            option.name,
                                            style: const TextStyle(
                                                fontFamily: "PoppinRegular"),
                                          ),
                                          subtitle: Text(option.language),
                                          onTap: () {

                                            selectedStudentsList.add(option);
                                            Navigator.pop(context);
                                            update();

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
                                return const Iterable<studentModel>.empty();
                              } else {
                                return studentsList.where((element) =>
                                    element.name.toLowerCase().contains(
                                        texteditingvalue.text.toLowerCase())).toList();
                              }
                            },
                            fieldViewBuilder:
                                (context, controller, focusmode, onEditingComplete) {
                              return Material(
                                elevation: 2,
                                clipBehavior: Clip.antiAlias,
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(20),
                                child: TextField(
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

                                        },
                                        icon: const Icon(Icons.search_outlined),
                                      ),
                                      label: const Text(
                                        "Search",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontFamily: "PoppinRegular"),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(40),
                                      )),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height*0.75 ,
                        child: ListView.builder(
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () async {

                                if (tempList.any((element) =>
                                element.email == studentsList[index].email)) {
                                  tempList.removeWhere((element) =>
                                  element.email == studentsList[index].email);
                                  selectedStudentsList.removeWhere((element) =>
                                  element.email == studentsList[index].email);

                                  innerSetState(() {});
                                } else {
                                  tempList.add(studentsList[index]);
                                  innerSetState(() {});
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Material(
                                  elevation: 2,
                                  child: ListTile(
                                    tileColor: tempList.any((element) =>
                                    element.email ==
                                        studentsList[index]
                                            .email)
                                        ? Colors.yellow
                                        : Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          studentsList[index].profileImage),
                                      radius: 25,
                                    ),
                                    title: Text(
                                      studentsList[index].name,
                                      style: const TextStyle(
                                          fontSize: 17, fontFamily: "Poppins"),
                                    ),
                                    subtitle: Text(
                                      "Dni/Nei:   " + studentsList[index].dni,
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                    horizontalTitleGap: 10,
                                    contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                  ),
                                ),
                              ),
                            );
                          },
                          itemCount: studentsList.length,
                        ),
                      ),
                    ],
                  ),
                ),
                bottomNavigationBar: BottomAppBar(
                  child:                     InkWell(
                    onTap: () {
                      selectedStudentsList.clear();
                      selectedStudentsList.addAll(tempList);
                      Navigator.pop(context);
                      update();
                    },
                    child: Material(
                      elevation: 6,
                      color: Colors.blue,
                      child: Container(
                        height: 40,
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: const Text(
                          'Confirm',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontFamily: "Poppins"),
                        ),
                      ),
                    ),
                  )
                  ,
                ),
              ),
            );
          });
        });
  }



  void update() {
    setState(() {});
  }
  Future<void> getStudents() async {
    var data = await FirebaseFirestore.instance
        .collection("admin")
        .doc("data")
        .collection("students")
        .doc("allStudents")
        .collection("allStudents")
        .get(const GetOptions(source: Source.server));

    if (data.docs.isNotEmpty) {
      print("exisr");
      studentsList =
          List.from(data.docs.map((doc) => studentModel.fromSnapshot(doc)));
      allStudentlist.addAll(studentsList);


      setState(() {});
    } else {
      setState(() {});
    }
  }


  void sendPushMessage(String message,String token,String name,String id) async {

    setState(() {
      isLoading = true;
    });

    await FirebaseDatabase.instance.ref().child("students").child(id.substring(0,id.indexOf("@"))).
    child("studentsNotifications").child(DateTime.now().millisecondsSinceEpoch.toString()).set({
      "Message": messageController.text,
      "time": DateTime.now().millisecondsSinceEpoch.toString(),
      "status":"unread"
    });

    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
          'key=AAAAbZYqHOw:APA91bEahPFhGbFTQhUTfi6SZbPsK3qjAL5IU_PtI1dzzZbIg71_r1Q2wH2iKbvS0LKYkMHrmbqO5z4W_Ex9m6KouBAOyBDBYgNPxw3jLKiXocMBVKkLR6mkmR3Nr5BAkjpH9c67ZVAu',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': messageController.text,
              'title': "BM-Educators",
              'sound': 'default',
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'screen': "promotion",
              'body': messageController.text,
              'name': name,
            },
            "to": token
            // "f8oymJgmSIGBqnkXraDIMD:APA91bFrnuzPiY2DEmm0JN9i5ANEqN_eq8FCB729F-JptBcwuRHl73-f5jUKtOZ1L9MfFxotp7F-pIPASJdiKwCg7lH_77PwncP3bG2z7Box50DKcr3wec1BObyt_xdzKNn4d-erxXL8",
          },
        ),
      );


      messageController.clear();

      setState(() {
     isLoading = false;
      });
    } catch (e) {

      print("error push notification");

      isLoading  = false;
      setState(() {

      });
    }
  }
}
