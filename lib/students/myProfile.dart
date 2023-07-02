import 'package:bmeducators/Models/studentModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class myProfile extends StatefulWidget {
  String email ;
   myProfile({Key? key,required this.email}) : super(key: key);

  @override
  State<myProfile> createState() => _myProfileState();
}


class _myProfileState extends State<myProfile> {
  late studentModel student ;

  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.blue,
                        )),
                    const Text(
                      "My Profile",
                      style: TextStyle(fontFamily: "Poppins", fontSize: 25,color: Colors.blue),
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
              Divider(thickness: 1,),
              SizedBox(height: 20,),


              isLoading?
              Container
                (
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.6,
                child: Center(
                    child: LoadingAnimationWidget.discreteCircle(
                      color: Colors.blueAccent,
                      size: 50,
                    )),
              )
                  :Column(
                children: [
                  Center(child: Material(

                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      borderRadius: BorderRadius.circular(70),
                      elevation: 10,
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: CircleAvatar(radius: 50,backgroundImage: NetworkImage(student.profileImage),),
                      )),),
                  SizedBox(height: 30,),
                  item("Name", student.name),
                  item("Email", student.email),
                  item("Dni", student.dni),
                  item("License-Type", student.licenseType),
                  item("Contact", student.contact),
                  item("Address", student.address),
                  item("Language", student.language),
                  item("Date of Birth", student.dateofBirth),
                  item("Access Limit", student.accessDate),


                ],
              ),




            ],
          ),
        ),
      ),
    );
  }

  getData() async {




    DocumentSnapshot snapp = await FirebaseFirestore.instance.collection("admin").doc(
        "data").collection("students").doc(
        "allStudents").collection("allStudents")
        .doc(widget.email)
        .get();

    student = studentModel(
        id: snapp['id'],
        name: snapp['name'],
        contact: snapp['contact'],
        profileImage: snapp['profileImage'],
        dateofBirth: snapp['dateofBirth'],
        email: snapp['email'],
        dni: snapp['dni'],
        token: snapp['token'],
        address: snapp['address'],
        education: snapp['education'],
        language: snapp['language'],
        translation: snapp['translation'],
        accessDate: snapp['accessDate'],
        mode: snapp['mode'],
        revise: snapp['revise'],
        licenseType: snapp['licenseType']);


    setState(() {
      isLoading = false;
    });
  }

  item(String name , String value){

    if(name == "Date of Birth"){

   String d =DateFormat("d-MM-yyyy").format( DateTime.fromMillisecondsSinceEpoch((int.parse(student.dateofBirth)!)));

   value =d;

    }
    if(name == "Access Limit"){
      if(value == ""){
        value = "none";
      }
      else{
        var s = DateTime.fromMillisecondsSinceEpoch(int.parse(student.accessDate));
        value = DateFormat("dd-MM-yyyy").format(s);
      }
    }
    return       Container(
      padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.35,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,style: TextStyle(fontFamily: "Poppins",fontSize: 16,color: Colors.grey[500]),),
                    Divider(thickness: 1,color: Colors.transparent,)
                  ],
                ),
              ),

            ],
          ),
         name == "Access Limit"?
         Container(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                value == "none"?

                Text(value,style: TextStyle(fontFamily: "Poppins",fontSize: 17),)
                    :
                Text(value,style: TextStyle(fontFamily: "Poppins",fontSize: 17),),
                Divider(thickness: 2,)
              ],
            ),
          ):
         Container(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,style: TextStyle(fontFamily: "Poppins",fontSize: 17),),
                Divider(thickness: 2,)
              ],
            ),
          )
        ],
      ),
    );

  }
}
