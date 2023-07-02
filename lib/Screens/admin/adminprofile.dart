import 'package:bmeducators/Models/studentModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class adminProfile extends StatefulWidget {
  String email ;
  adminProfile({Key? key,required this.email}) : super(key: key);

  @override
  State<adminProfile> createState() => _adminProfileState();
}


class _adminProfileState extends State<adminProfile> {
  
  TextEditingController passwordController = TextEditingController();
  bool isLoading = true;
  String password = "";
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
                        child: CircleAvatar(radius: 50,backgroundImage: AssetImage("assets/profile.png")),
                      )),),
                  SizedBox(height: 30,),
                  item("Email", widget.email),
                  Container(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Password",style: TextStyle(fontFamily: "Poppins",fontSize: 16,color: Colors.grey[500]),),
                      Divider(thickness: 1,color: Colors.transparent,)
                    ],
                  ),
                ),

              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(password,style: TextStyle(fontFamily: "Poppins",fontSize: 17),),
                  Divider(thickness: 2,)
                ],
              ),
            ),
            InkWell(
              onTap: (){
                _showCentreialog(context);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.edit,color: Colors.red,),
                  Divider(thickness: 2,)
                ],
              ),
            ),

            SizedBox(width: 20,)
          ],
        ),
      )


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
        "data").collection("login").doc(
        "login").collection("logins")
        .doc(widget.email)
        .get();
        password = snapp['password'];

        print(password);

    setState(() {
      isLoading = false;
    });
  }
  Future<void> _showCentreialog(BuildContext context) {

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: Colors.grey[200],
              contentPadding: EdgeInsets.zero,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 20,),
                  Text("Add New Password"),
                  SizedBox(height: 20,),

                  Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: passwordController, //editing controller of this TextField
                decoration: InputDecoration(
                    labelText: "Enter new password.." //label text of field
                ),

              ),
            ),
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
                          onTap: () async {
                            await FirebaseFirestore.instance.collection("admin").doc(
                                "data").collection("login").doc(
                                "login").collection("logins")
                                .doc(widget.email).update({"password":passwordController.text});
                            password = passwordController.text;
                            setState(() {

                            });
                            Navigator.pop(context);

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
              ));
        });
  }

  item(String name , String value){

    return       Container(
      padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.25,
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

         Container(
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
