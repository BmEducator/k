import 'dart:io';

import 'package:bmeducators/Screens/admin/add_tikto_screen.dart';
import 'package:bmeducators/Screens/admin/admin_Screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../utilis/videos_Lecture_Scree.dart';

class myTiktoks extends StatefulWidget {
  const myTiktoks({Key? key}) : super(key: key);

  @override
  State<myTiktoks> createState() => _myTiktoksState();
}


class _myTiktoksState extends State<myTiktoks> {
  List<dynamic> temp = [];
  List<String> urls = [];

  @override
  void initState() {

    getTiktoks();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: ()async{
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => adminScreen()));

          return true;
        },
        child: SingleChildScrollView(
         physics: ClampingScrollPhysics(),
          child: SafeArea(child:
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context, MaterialPageRoute(builder: (context) => adminScreen()));

                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.blue,
                        )),
                    const Text(
                      "My TikToks",
                      style: TextStyle(fontFamily: "Poppins", fontSize: 25),
                    ),
                    IconButton(
                        onPressed: () {

                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.transparent,
                        )),

                  ],),
              ),
              Divider(thickness: 4,),


              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [

                    InkWell(
                      onTap: (){
                        Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    addTiktokScreen(urls: urls,)));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          elevation: 4,
                          color: Colors.lightBlueAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: const [
                                Icon(Icons.add_circle,color: Colors.white,),
                                Text(
                                  " Add New Tiktok   ",
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
              SizedBox(
                  height: 10,
              ),
              Container(
                child: GridView.count(
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  scrollDirection: Axis.vertical,
                  crossAxisCount: 2,
                  childAspectRatio: (0.7 / 1),
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 5,
                  children: List.generate(
                    urls.length,
                        (int i) {
                      return AnimationConfiguration.staggeredGrid(
                          position: i,
                          duration: const Duration(
                              milliseconds: 375),
                          columnCount: 2,
                          child: ScaleAnimation(
                            child: FadeInAnimation(
                                child:Padding(
                                    padding: const EdgeInsets.all(5.0),
                                  child: Stack(
                                    alignment: Alignment.topRight,
                                    children:[ Material(
                                        borderRadius: BorderRadius.circular(10),
                                        elevation: 10,
                                        clipBehavior: Clip.antiAlias,
                                        child:
                                        Platform.isIOS?
                                        videoLectureScreen(
                                            url:urls[i]):
                                        Stack(
                                          alignment: Alignment.center,
                                            children:[

                                              videoLectureScreen(url:urls[i]),
                                              InkWell(
                                                onTap: (){

                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(builder: (context) => videoLectureScreen(url: urls[i])));

                                                },

                                                  child: Container(
                                                    width:30,
                                                    height:30,
                                                    color: Colors.transparent,
                                                ),
                                              ),
                                            ])
                                    ),
                                      InkWell(
                                        onTap: (){
                                         _showDeleteDialog(context, urls[i]);
                                        },
                                        child: Material(
                                          elevation: 10,
                                          color: Colors.black,
                                          child:Icon(Icons.close,size:35 ,color: Colors.white,),
                                        ),
                                      )
                                    ]

                                  ),
                                )

                            ),
                          ));
                    },
                  ),
                ),
              ),

            ],
          )),
        ),
      ),
    );
  }

  Future<void> getTiktoks() async {
    await FirebaseFirestore.instance.
    collection("admin").doc("data").
    collection("tiktoks").doc("tiktoks").get().then((value) =>

    temp.addAll(value['tiktoksUrls'])
    );

    DatabaseReference ref = FirebaseDatabase.instance.ref().child("admin")
        .child("mytiktoks").child("urls");


    DatabaseEvent event = await ref.once();

    if(event.snapshot.exists){
      event.snapshot.children.forEach((element) {
       urls.add( element.value.toString());
       print(element.value.toString());
      });
      }
    else{
    }


    setState(() {

    });

  }

  Future<void>? _showDeleteDialog(BuildContext context, String docId) async {
    return (
        await showDialog(context: context,
            builder: (context)
            =>
                AlertDialog(
                  content: const Text("Do you want to delete this Tiktok?",
                    style: TextStyle(fontFamily: "PoppinRegular"),),
                  actions: [
                    TextButton(onPressed: () {
                      Navigator.pop(context);
                    },
                      child: const Text(
                          "No", style: TextStyle(fontFamily: "Poppins")),),
                    TextButton(onPressed: () async {

                      urls.removeWhere((element) => element == docId);

                      FirebaseDatabase.instance.ref().child("admin").child("mytiktoks").
                      set({
                        "urls":urls}
                      );



                      Navigator.pop(context);

                      setState(() {});

                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("TikTok Deleted")));

                    },
                      child: const Text("Yes", style: TextStyle(
                          color: Colors.grey, fontFamily: "Poppins")),),
                  ],
                )
        )
    );


  }
}
