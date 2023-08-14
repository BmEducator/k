import 'package:bmeducators/Screens/admin/admin_Screen.dart';
import 'package:bmeducators/Screens/admin/studentSetting.dart';
import 'package:bmeducators/Screens/admin/student_statistics_Screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'dart:math' as math;

import '../../Models/studentModel.dart';
import '../../utilis/navigation_drawer.dart';
import 'add_Student_Screen.dart';
import 'edit_student_Screen.dart';


class usersSreen extends StatefulWidget {
  const usersSreen({Key? key}) : super(key: key);

  @override
  State<usersSreen> createState() => _usersSreenState();
}

class _usersSreenState extends State<usersSreen> {

   List<studentModel> studentsList = [] ;
  bool isEndLoading = false;

  @override
  void initState() {
    super.initState();
    getStudents();


  }


   Future<bool> willpop() async {
     Navigator.pushReplacement(
         context, MaterialPageRoute(builder: (context) => adminScreen()));
     return  true;
   }


   @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: willpop,
      child: Scaffold(
        backgroundColor: Colors.white,
          body:SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
              children: [
                Column(
                  children: [

                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(onPressed: () {
                            Navigator.pushReplacement(
                                context, MaterialPageRoute(
                                builder: (context) => adminScreen()));
                            },
                              icon: const Icon(
                                Icons.arrow_back_ios, color: Colors.blue,size: 30,)),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: (){
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                addStudentScreen()));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Material(
                                      elevation: 4,
                                      color: Colors.blue[900],
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: const [
                                            Icon(Icons.add_circle,color: Colors.white,),
                                            Text(
                                              " Add New Student   ",
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
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20,),

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
                                      .width - 70,
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
                                        subtitle: Text(option.dni),
                                        onTap: () {
                                          Navigator.pushReplacement(
                                              context, MaterialPageRoute(builder: (context) => student_statistics_screen(student: option)));

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
                              List<studentModel> l =[];
                              l.addAll(studentsList.where((element) =>
                                  element.name.toLowerCase().contains(
                                      texteditingvalue.text.toLowerCase())).toList());
                              l.addAll(studentsList.where((element) =>
                                  element.dni.toLowerCase().contains(
                                      texteditingvalue.text.toLowerCase())).toList());
                              return l;
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

                                  if(studentsList.length == 0) {
                                    getStudents();
                                  }
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
                  ],
                ),
                SizedBox(height: 10,),
               isEndLoading? SizedBox(
                 height: MediaQuery.of(context).size.height * 0.8,
                 child: AnimationLimiter(
                   child: ListView.builder(
                     shrinkWrap: true,
                     physics: ClampingScrollPhysics(),
                     scrollDirection: Axis.vertical,
                     padding: const EdgeInsets.all(8.0),
                     itemCount: studentsList.length,
                     itemBuilder: (BuildContext context, int index) {
                       return AnimationConfiguration.staggeredList(
                         position: index,
                         duration: const Duration(milliseconds: 675),
                         child: SlideAnimation(
                           verticalOffset: 44.0,
                           child: FadeInAnimation(
                               child: InkWell(
                                 onTap: () async {
                                   Navigator.pushReplacement(
                                       context, MaterialPageRoute(builder: (context) => student_statistics_screen(student: studentsList[index])));
                                   },
                                 child: Padding(
                                   padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 14),
                                   child: Material(
                                     elevation: 7,
                                     child: ListTile(
                                       tileColor: Colors.grey[100],
                                       shape: RoundedRectangleBorder(
                                           borderRadius: BorderRadius.circular(10)),
                                       leading: CircleAvatar(
                                         backgroundImage: NetworkImage(studentsList[index].profileImage),
                                         radius: 25,
                                       ),
                                       title: Text(
                                         studentsList[index].name,
                                         style: const TextStyle(fontSize: 17, fontFamily: "Poppins"),
                                       ),
                                       subtitle: Text(
                                         "Nei/Dni:  "+  studentsList[index].dni,
                                         style: const TextStyle(fontSize: 15),
                                       ),
                                       horizontalTitleGap: 10,
                                       contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                       trailing:  PopupMenuButton(
                                           offset: const Offset(0, 40),
                                           icon: const Icon(
                                             Icons.more_vert,
                                           ),
                                           itemBuilder: (BuildContext context) => [
                                             PopupMenuItem<String>(
                                                 child: InkWell(
                                                   onTap: (){
                                                     Navigator.pushReplacement(
                                                         context, MaterialPageRoute(
                                                         builder: (context) =>
                                                             studentSettings(student: studentsList[index],)));

                                                   },
                                                   child: Row(
                                                     children: [
                                                       const Icon(
                                                         Icons.edit,
                                                         size: 20,
                                                       ),
                                                       const Text(
                                                         " Edit",
                                                         style:
                                                         TextStyle(fontSize: 13),
                                                       ),
                                                     ],
                                                   ),
                                                 )),
                                             PopupMenuItem<String>(
                                                 child: InkWell(
                                                   onTap: (){

                                                     Navigator.push(
                                                         context, MaterialPageRoute(
                                                         builder: (context) =>
                                                             student_statistics_screen(student: studentsList[index])));

                                                   },
                                                   child: Row(
                                                     children: [
                                                       const Icon(
                                                         Icons.show_chart,
                                                         size: 20,
                                                       ),
                                                       const Text(
                                                         " Statistics",
                                                         style:
                                                         TextStyle(fontSize: 13),
                                                       ),
                                                     ],
                                                   ),
                                                 )),
                                             PopupMenuItem<String>(
                                                 child: GestureDetector(
                                                   onTap: () async {
                                                     _showDeleteDialog(context, studentsList[index]);
                                                   },
                                                   child: Row(
                                                     children: [
                                                       const Icon(
                                                         Icons.delete_outline,
                                                         size: 20,
                                                       ),
                                                       const Text(
                                                         " Remove",
                                                         style:
                                                         TextStyle(fontSize: 13),
                                                       ),
                                                     ],
                                                   ),
                                                 )),

                                           ]),
                                     ),
                                   ),
                                 ),
                               )
                           ),
                         ),
                       );
                     },
                   ),
                 ),
               ):
               Container(
                 height: MediaQuery.of(context).size.height*0.5,
                 width: MediaQuery.of(context).size.width,
                 child: Center(
                     child: LoadingAnimationWidget.fourRotatingDots(
                       color: Colors.blue,
                       size: 45,
                     )),
               ),
                SizedBox(height: 250,)
              ],
            )
          )


      ),
    );
  }

  Future<void> getStudents() async {
    var data = await FirebaseFirestore.instance.collection("admin").doc("data")
        .collection("students").doc("allStudents").collection("allStudents")
        .get(const GetOptions(source: Source.server));

    if (data.docs.isNotEmpty) {
      print("exisr");
      studentsList =
          List.from(data.docs.map((doc) => studentModel.fromSnapshot(doc)));

      setState(() {

        isEndLoading = true;
        print(studentsList.length);
      });
    }
    else{
      isEndLoading = true;
      setState(() {

      });
    }
  }

   Future<void>? _showDeleteDialog(BuildContext context, studentModel std) async {
     return (
         await showDialog(context: context,
             builder: (context)
             =>
                 AlertDialog(
                   content: const Text("Do you want to delete this User?",
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
                           .doc(std.email).delete();

                      await FirebaseFirestore.instance.collection(
                          "admin").doc("data").collection("students").doc("login").collection(
                          "logins").doc(std.email).delete();
                      await FirebaseFirestore.instance.collection("students").
                      doc(std.email).delete();


                       studentsList.removeWhere((element) => element.email == std.email);
                       setState(() {

                       });

                       Navigator.pop(context);
                       Navigator.pop(context);


                     },
                       child: const Text("Yes", style: TextStyle(
                           color: Colors.grey, fontFamily: "Poppins")),),
                   ],
                 )
         )
     );


   }


}
