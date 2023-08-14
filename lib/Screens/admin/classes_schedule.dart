import 'package:bmeducators/Screens/admin/admin_Screen.dart';
import 'package:bmeducators/Screens/homeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:intl/intl.dart';


class classes_Schedule extends StatefulWidget {
  const classes_Schedule({Key? key}) : super(key: key);


  @override
  State<classes_Schedule> createState() => _classes_ScheduleState();
}

class _classes_ScheduleState extends State<classes_Schedule> {



  List<dynamic> fondo_English = [];
  List<dynamic> sant_English = [];
  List<dynamic> center_English = [];

  List<dynamic> fondo_spanish = [];
  List<dynamic> sant_spanish = [];
  List<dynamic> center_spanish = [];

  bool isLoading = true;
  Future<bool> willpop() async {
    return (await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Row(
            mainAxisAlignment:
            MainAxisAlignment.start,
            children: [
              Flexible(
                child: Text("Do you want to save changes?",
                  style: const TextStyle(fontFamily: "PoppinRegular"),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text( "No",
                  style: const TextStyle(fontFamily: "Poppins")),
            ),
            TextButton(
              onPressed: () {
                saveChanges();
              },
              child: Text("Yes",
                  style: const TextStyle(
                      color: Colors.grey, fontFamily: "Poppins")),
            ),
          ],
        )));
  }

  @override
  void initState() {
    getSchedule();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
     onWillPop: willpop,
      child:!isLoading? Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: (){
                      willpop();
                    },
                    child: Icon(Icons.close),
                  ),
                  SizedBox(height: 29,),
                  Text("Classes Schedule",style: TextStyle(fontFamily: "Poppins",fontSize: 23),)
                  ,SizedBox(
                    height: 0,
                  ),

                  Divider(thickness: 3,color: Colors.grey,),
                  SizedBox(height: 20,),
                  Text("Fondo",style: TextStyle(color: Colors.orange,fontFamily: "Poppins",fontSize: 22),),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(top: 10),
                    itemBuilder: (context, index) {
                      return entryItem(fondo_English[index],fondo_spanish[index],index,"fondo");
                    },
                    itemCount:fondo_English.length,
                  ),

                  SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: (){
                          _showAddDialog(context);
                        },
                        child: Material(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("   Add new   ",style: TextStyle(fontSize: 16,color: Colors.white),),
                            )),
                      ),
                      SizedBox(width: 30,)

                    ],
                  ),

                  SizedBox(height: 20,),
                  Divider(thickness: 2,color: Colors.grey,),
                  SizedBox(height: 10,),

                  Text("Sant Adria",style: TextStyle(color: Colors.deepOrange,fontFamily: "Poppins",fontSize: 23),),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(top: 10),
                    itemBuilder: (context, index) {
                      return entryItem(sant_English[index],sant_spanish[index],
                          index,"sant");
                    },
                    itemCount:sant_English.length,
                  ),
                  SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: (){
                          _showSantDialog(context);
                        },
                        child: Material(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("   Add new   ",style: TextStyle(fontSize: 16,color: Colors.white),),
                            )),
                      ),
                      SizedBox(width: 30,)

                    ],
                  ),

                  SizedBox(height: 20,),
                  Divider(thickness: 2,color: Colors.grey,),
                  SizedBox(height: 10,),



                  Text("Center",style: TextStyle(color: Colors.deepOrange,fontFamily: "Poppins",fontSize: 23),),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(top: 10),
                    itemBuilder: (context, index) {
                      return entryItem(center_English[index],center_spanish[index],
                          index,"center");
                    },
                    itemCount:center_English.length,
                  ),
                  SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: (){
                          _showCentreialog(context);
                        },
                        child: Material(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("   Add new   ",style: TextStyle(fontSize: 16,color: Colors.white),),
                            )),
                      ),

                    ],
                  ),

                  SizedBox(height: 50,)

                ],


              ),
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
                            child: Text(
                              "Cancel",
                              style: const TextStyle(
                                  color: Colors.blue, fontFamily: 'Poppins'),
                            )),
                      )),
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 20, 10),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange[900]
                            ),
                            onPressed: () async {
                                isLoading = true;
                                setState(() {

                                });
                                saveChanges();

                            },
                            child: Text(
                              "Save",
                              style: const TextStyle(
                                  color: Colors.white, fontFamily: 'Poppins'),
                            )),
                      )),
                ],
              ),
            ),
          )
      ):
      Scaffold(
        backgroundColor: Colors.white,
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
      ),
    );
  }
  
   entryItem(String english , String spanish,int index,String type){
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 10, 20, 0),
      child: Column(
        children: [
          Visibility(
            visible: index == 0,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("English",style: TextStyle(fontFamily: "Poppins",color: Colors.black,fontSize: 20),),
                  SizedBox(width: 50,),
                  Text("Spanish",style: TextStyle(fontFamily: "Poppins",color: Colors.black,fontSize: 20),),
                  SizedBox(width: 30,),
                  InkWell(
                      child: Icon(Icons.close,color: Colors.transparent,))
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(english,style: TextStyle(fontFamily: "Poppins",color: Colors.blue,fontSize: 16),),
              SizedBox(width: 50,),
              Text(spanish,style: TextStyle(fontFamily: "Poppins",color: Colors.blue,fontSize: 16),),
              SizedBox(width: 30,),
              InkWell(
                  onTap: (){
                   if(type == "fondo"){
                     fondo_English.removeAt(index);
                     fondo_spanish.removeAt(index);

                   }
                   else if(type == "sant"){
                     sant_English.removeAt(index);
                     sant_spanish.removeAt(index);

                   }
                   else{
                     center_spanish.removeAt(index);
                     center_English.removeAt(index);

                   }

                    setState(() {

                    });
                  },
                  child: Icon(Icons.close))
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showAddDialog(BuildContext context) {
    TextEditingController englishTime  = TextEditingController();
    TextEditingController spanishTime  = TextEditingController();
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: StatefulBuilder(  // You need this, notice the parameters below:
            builder: (BuildContext context, StateSetter innerSetState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10,),
                  Text("Add New Time"),
                  Column(
                    children: [
                      SizedBox(height: 20,),
                      Text( englishTime.text,style: TextStyle(fontFamily: "PoppinRegular",),),
                      SizedBox(height:20),
                      TextField(
                        controller: englishTime, //editing controller of this TextField
                        decoration: InputDecoration(
                            icon: Icon(Icons.timer), //icon of text field
                            labelText: "Enter Time" //label text of field
                        ),
                        readOnly: true,  //set it true, so that user will not able to edit text
                        onTap: () async {
                          TimeOfDay? pickedTime =  await showTimePicker(
                            initialTime: TimeOfDay.now(),
                            context: context,
                          );

                          if(pickedTime != null ){
                            print(pickedTime.format(context));   //output 10:51 PM

                            innerSetState(() {
                              englishTime.text = pickedTime.format(context); //set the value of text field.
                            });
                          }else{
                            print("Time is not selected");
                          }
                        },
                      ),
                      SizedBox(height:20),


                      Text("Spanish",style: TextStyle(fontFamily: "PoppinRegular",),),
                      SizedBox(height:20),

                      TextField(
                        controller: spanishTime, //editing controller of this TextField
                        decoration: InputDecoration(
                            icon: Icon(Icons.timer), //icon of text field
                            labelText: "Enter Time" //label text of field
                        ),
                        readOnly: true,  //set it true, so that user will not able to edit text
                        onTap: () async {
                          TimeOfDay? pickedTime =  await showTimePicker(
                            initialTime: TimeOfDay.now(),
                            context: context,
                          );

                          if(pickedTime != null ){
                            print(pickedTime.format(context));   //output 10:51 PM

                            innerSetState(() {
                              spanishTime.text = pickedTime.format(context); //set the value of text field.
                            });
                          }else{
                            print("Time is not selected");
                          }
                        },
                      ),
                      SizedBox(height: 20,),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: Material(
                                elevation: 3,
                                color: Colors.grey[300],
                                child: Container(
                                    width: 100,
                                    padding: EdgeInsets.symmetric(vertical: 10),

                                    child: Center(child: Text(" Cancel "))),
                              ),
                            ),

                            InkWell(
                              onTap: (){
                                if(englishTime.text != "" || spanishTime.text != ""){

                                  if(englishTime.text == ""){

                                    fondo_English.add( "none");
                                  }
                                  else{
                                    fondo_English.add(englishTime.text);
                                  }
                                  if(spanishTime.text == ""){
                                    fondo_spanish.add("none");

                                  }
                                  else{
                                    fondo_spanish.add(spanishTime.text);

                                  }
                                  Navigator.pop(context);

                                  setState(() {

                                  });
                                }
                                else{
                                  print("add tine");
                                }

                              },
                              child: Material(
                                elevation: 3,
                                color: Colors.orange,
                                child: Container(
                                    width: 100,
                                    padding: EdgeInsets.symmetric(vertical: 10),

                                    child: Center(child: Text(" Save "))),
                              ),
                            ),



                          ],
                        ),
                      ),



                    ],
                  )
                ],
              );
            },
          ),
        );
      },
    );
  }



  Future<void> _showSantDialog(BuildContext context) {
    TextEditingController englishTime  = TextEditingController();
    TextEditingController spanishTime  = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: StatefulBuilder(  // You need this, notice the parameters below:
            builder: (BuildContext context, StateSetter innerSetState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10,),
                  Text("Add New Time"),
                  Column(
                    children: [
                      SizedBox(height: 20,),
                      Text( englishTime.text,style: TextStyle(fontFamily: "PoppinRegular",),),
                      SizedBox(height:20),
                      TextField(
                        controller: englishTime, //editing controller of this TextField
                        decoration: InputDecoration(
                            icon: Icon(Icons.timer), //icon of text field
                            labelText: "Enter Time" //label text of field
                        ),
                        readOnly: true,  //set it true, so that user will not able to edit text
                        onTap: () async {
                          TimeOfDay? pickedTime =  await showTimePicker(
                            initialTime: TimeOfDay.now(),
                            context: context,
                          );

                          if(pickedTime != null ){
                            print(pickedTime.format(context));   //output 10:51 PM

                            innerSetState(() {
                              englishTime.text = pickedTime.format(context); //set the value of text field.
                            });
                          }else{
                            print("Time is not selected");
                          }
                        },
                      ),
                      SizedBox(height:20),


                      Text("Spanish",style: TextStyle(fontFamily: "PoppinRegular",),),
                      SizedBox(height:20),

                      TextField(
                        controller: spanishTime, //editing controller of this TextField
                        decoration: InputDecoration(
                            icon: Icon(Icons.timer), //icon of text field
                            labelText: "Enter Time" //label text of field
                        ),
                        readOnly: true,  //set it true, so that user will not able to edit text
                        onTap: () async {
                          TimeOfDay? pickedTime =  await showTimePicker(
                            initialTime: TimeOfDay.now(),
                            context: context,
                          );

                          if(pickedTime != null ){
                            print(pickedTime.format(context));   //output 10:51 PM

                            innerSetState(() {
                              spanishTime.text = pickedTime.format(context); //set the value of text field.
                            });
                          }else{
                            print("Time is not selected");
                          }
                        },
                      ),
                      SizedBox(height: 20,),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: Material(
                                elevation: 3,
                                color: Colors.grey[300],
                                child: Container(
                                    width: 100,
                                    padding: EdgeInsets.symmetric(vertical: 10),

                                    child: Center(child: Text(" Cancel "))),
                              ),
                            ),

                            InkWell(
                              onTap: (){
                                if(englishTime.text != "" || spanishTime.text != ""){

                                  if(englishTime.text == ""){

                                    sant_spanish.add( "none");
                                  }
                                  else{
                                    sant_English.add(englishTime.text);
                                  }
                                  if(spanishTime.text == ""){
                                    sant_spanish.add("none");

                                  }
                                  else{
                                    sant_spanish.add(spanishTime.text);

                                  }
                                  Navigator.pop(context);

                                  setState(() {

                                  });
                                }
                                else{
                                  print("add tine");
                                }

                              },
                              child: Material(
                                elevation: 3,
                                color: Colors.orange,
                                child: Container(
                                    width: 100,
                                    padding: EdgeInsets.symmetric(vertical: 10),

                                    child: Center(child: Text(" Save "))),
                              ),
                            ),



                          ],
                        ),
                      ),



                    ],
                  )
                ],
              );
            },
          ),
        );
      },
    );

  }


  Future<void> _showCentreialog(BuildContext context) {
    TextEditingController englishTime  = TextEditingController();
    TextEditingController spanishTime  = TextEditingController();
    return showDialog(
      context: context,
      builder: (BuildContext context) {

        int selectedRadio = 0; // Declare your variable outside the builder

        return AlertDialog(
          content: StatefulBuilder(  // You need this, notice the parameters below:
            builder: (BuildContext context, StateSetter innerSetState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10,),
                  Text("Add New Time"),
                  Column(
                    children: [
                      SizedBox(height: 20,),
                      //
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //   children: [
                      //
                      //     Text("English  ",style: TextStyle(fontFamily: "PoppinRegular",),),
                      //     Container(
                      //       width: 120,
                      //       child: TextField(
                      //         controller: englishTime,
                      //         decoration: InputDecoration(
                      //           filled: true,
                      //           fillColor: Colors.blue[100],
                      //           border: OutlineInputBorder(
                      //               borderRadius: BorderRadius.circular(20)),
                      //           labelText: "Add time",
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // SizedBox(height: 20,),
                      //
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //   children: [
                      //
                      //     Text("Spanish  ",style: TextStyle(fontFamily: "PoppinRegular",),),
                      //     Container(
                      //       width: 120,
                      //       child: TextField(
                      //         controller: spanishTime,
                      //         decoration: InputDecoration(
                      //           filled: true,
                      //           fillColor: Colors.blue[100],
                      //           border: OutlineInputBorder(
                      //               borderRadius: BorderRadius.circular(20)),
                      //           labelText: "Add time",
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),


                      Text( englishTime.text,style: TextStyle(fontFamily: "PoppinRegular",),),
                      SizedBox(height:20),
                      TextField(
                        controller: englishTime, //editing controller of this TextField
                        decoration: InputDecoration(
                            icon: Icon(Icons.timer), //icon of text field
                            labelText: "Enter Time" //label text of field
                        ),
                        readOnly: true,  //set it true, so that user will not able to edit text
                        onTap: () async {
                          TimeOfDay? pickedTime =  await showTimePicker(
                            initialTime: TimeOfDay.now(),
                            context: context,
                          );

                          if(pickedTime != null ){
                            print(pickedTime.format(context));   //output 10:51 PM

                            innerSetState(() {
                              englishTime.text = pickedTime.format(context); //set the value of text field.
                            });
                          }else{
                            print("Time is not selected");
                          }
                        },
                      ),
                      SizedBox(height:20),


                      Text("Spanish",style: TextStyle(fontFamily: "PoppinRegular",),),
                      SizedBox(height:20),

                      TextField(
                        controller: spanishTime, //editing controller of this TextField
                        decoration: InputDecoration(
                            icon: Icon(Icons.timer), //icon of text field
                            labelText: "Enter Time" //label text of field
                        ),
                        readOnly: true,  //set it true, so that user will not able to edit text
                        onTap: () async {
                          TimeOfDay? pickedTime =  await showTimePicker(
                            initialTime: TimeOfDay.now(),
                            context: context,
                          );

                          if(pickedTime != null ){
                            print(pickedTime.format(context));   //output 10:51 PM

                            innerSetState(() {
                              spanishTime.text = pickedTime.format(context); //set the value of text field.
                            });
                          }else{
                            print("Time is not selected");
                          }
                        },
                      ),
                      SizedBox(height: 20,),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: Material(
                                elevation: 3,
                                color: Colors.grey[300],
                                child: Container(
                                    width: 100,
                                    padding: EdgeInsets.symmetric(vertical: 10),

                                    child: Center(child: Text(" Cancel "))),
                              ),
                            ),

                            InkWell(
                              onTap: (){
                                if(englishTime.text != "" || spanishTime.text != ""){

                                  if(englishTime.text == ""){

                                    center_English.add( "none");
                                  }
                                  else{
                                    center_English.add(englishTime.text);
                                  }
                                  if(spanishTime.text == ""){
                                    center_spanish.add("none");

                                  }
                                  else{
                                    center_spanish.add(spanishTime.text);

                                  }
                                  Navigator.pop(context);

                                  setState(() {

                                  });
                                }
                                else{
                                  print("add tine");
                                }

                              },
                              child: Material(
                                elevation: 3,
                                color: Colors.orange,
                                child: Container(
                                    width: 100,
                                    padding: EdgeInsets.symmetric(vertical: 10),

                                    child: Center(child: Text(" Save "))),
                              ),
                            ),



                          ],
                        ),
                      ),



                    ],
                  )
                ],
              );
            },
          ),
        );
      },
    );




  }

  Future<void> saveChanges() async {
    await FirebaseFirestore.instance.collection("admin").doc("data").collection("classes").doc("classes").set(
      {
        "fondoEnglish":fondo_English,
        "fondoSpanish":fondo_spanish,
        "santEnglish":sant_English,
        "santSpanish":sant_spanish,
        "centerEnglish":center_English,
        "centerSpanish":center_spanish,
      }
    );
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => adminScreen()));

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Schedule Updated")));

  }

  void getSchedule() async{
    await FirebaseFirestore.instance.collection("admin").doc("data").
    collection("classes").
    doc("classes").get().then((value) {
      fondo_English =  value["fondoEnglish"];
      fondo_spanish =  value["fondoSpanish"];
      sant_English =  value["santEnglish"];
      sant_spanish =  value["santSpanish"];
      center_English =  value["centerEnglish"];
      center_spanish =  value["centerSpanish"];
    });

    isLoading = false;
    setState(() {

    });
    // {
    //   "fondoEnglish":fondo_English,
    //   "fondoSpanish":fondo_spanish,
    //   "santEnglish":sant_English,
    //   "santSpanish":sant_spanish,
    //   "centerEnglish":center_English,
    //   "centerSpanish":center_spanish,
    // }

  }

}
