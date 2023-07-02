import 'dart:async';
import 'dart:io' show Platform;
import 'dart:math';

import 'package:bmeducators/Screens/admin/admin_Screen.dart';
import 'package:bmeducators/services_Screen/aboutUs_Scree.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../resources/authMethods.dart';


class baab extends StatefulWidget {
  const baab({Key? key}) : super(key: key);

  @override
  State<baab> createState() => _baabState();
}

class _baabState extends State<baab> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late SharedPreferences pref;
  bool isObscurePass = true;
  bool isError = false;
  bool _isLoading = false;
  bool isEmailEntered = true;
  bool ispassEntered = true;
  bool isLoginAtSomeWhere = false;
  String loginAt = "";

  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async{
    pref = await SharedPreferences.getInstance();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:Color(0xff111336),
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width ,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors:[
                      Color(0xff0033cc),
                      Color(0xffffffff),

                    ] ,

                    begin: Alignment.topRight,
                    end: Alignment.bottomCenter
                )
            ),
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [

                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50,vertical: 10),
                    child: Image.asset("assets/splashlogofull.png"),
                  ),
                  Text("Admin's Only",style: TextStyle(fontFamily: "Poppins",fontSize: 18,color: Colors.white),),
                  SizedBox(height: 50,),
                  Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(10),
                    clipBehavior: Clip.antiAlias,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child:   TextField(
                        controller: _emailController,
                        decoration:  InputDecoration(
                          filled: true,
                          contentPadding: EdgeInsets.only(
                              left: 20
                          ),
                          border: InputBorder.none,
                          hintText: "Email",
                          labelText: "Email",
                          errorText: !isEmailEntered ? "* Enter valid email" : null,
                        ),

                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(10),
                    clipBehavior: Clip.antiAlias,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                              child: TextField(
                                obscureText: isObscurePass,
                                controller: _passwordController,

                                decoration: const InputDecoration(
                                  filled: true,
                                  contentPadding: EdgeInsets.only(
                                      left: 20
                                  ),
                                  border: InputBorder.none,
                                  hintText: "Password",
                                ),

                              )),
                          IconButton(onPressed: (){
                            setState(() {
                              isObscurePass = !isObscurePass;
                            });
                          }, icon:Icon(Icons.remove_red_eye_outlined,color:!isObscurePass?Colors.blue: Colors.grey,))

                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  Visibility(
                    visible: isError,
                    child: SizedBox(
                      width: double.infinity,
                      child: GestureDetector(
                          onTap: () {
                          },
                          child: const Text(
                            "* Invalid Email or Password",
                            style: TextStyle(color: Colors.red,fontFamily: "PoppinRegular"),
                            textAlign: TextAlign.start,
                          )),
                    ),
                  ),
                  Visibility(
                    visible: loginAt != "",
                    child: SizedBox(
                      width: double.infinity,
                      child: GestureDetector(
                          onTap: () {

                          },
                          child: const Text(
                            "* Your Account is currently Login in Another Device ",
                            style: TextStyle(color: Colors.amber,fontFamily: "PoppinRegular"),
                            textAlign: TextAlign.start,
                          )),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: (){
                      login();
                    },
                    child: Material(
                      borderRadius: const BorderRadius.all(
                          Radius.circular(8)),
                      elevation: 6,
                      color: Colors.yellow,
                      child: Container(
                        height: 40,
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: !_isLoading
                            ? const Text(
                          'Log in',
                          style: TextStyle(color: Colors.black,
                              fontSize: 17,fontFamily: "Poppins"),
                        )
                            :  Center(
                            child: LoadingAnimationWidget.staggeredDotsWave(
                              color: Colors.blue,
                              size: 40,
                            )),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  const SizedBox(
                    height: 12,
                  ),


                ],
              ),
            ),
          ),
        )

    );
  }



  void login() async {
    setState(() {
      _isLoading = true;
    });
  DocumentSnapshot snap =  await FirebaseFirestore.instance.collection(
          "admin").doc("data").collection("login").doc("login").collection(
          "logins").doc(_emailController.text).get();

      if (snap.exists && _passwordController.text == snap['password']) {
        print(snap['name']);

          String res = await AuthMethods().signUpUser(
            email: _emailController.text,
            password: _passwordController.text,
          );
          print(res);
          print("----");
          if (
          res ==
              "[firebase_auth/email-already-in-use] The email address is already in use by another account.") {
            setState(() {});

            String re = await AuthMethods().loginUser(
                email: _emailController.text, password: _passwordController.text);
            setState(() {
              _isLoading = false;
            });


            pref.setString("name","admin");
            pref.setString("email", _emailController.text);
            pref.setStringList("families", []);
            pref.setString("lastUpdateAccessTime", "");

            String _imageUrl = "https://i.pinimg.com/736x/da/4f/ad/da4fad3f0c9549a86a70dc90d9208e8d.jpg";
            await pref.setString("profileImage", _imageUrl);
            await pref.setBool("isSignedUp", true);

            Navigator.pushReplacement(
                context, MaterialPageRoute(
                builder: (context) => adminScreen()));
          }

          else {
            String re = await AuthMethods().loginUser(
                email: _emailController.text, password: _passwordController.text);


            print(re + " llll");
            setState(() {
              _isLoading = false;
            });


            // String id = FirebaseAuth.instance.currentUser!.uid;
            // FirebaseFirestore.instance.collection("users").doc(id).update({"token":t});


            print("succ");

            pref.setString("isAdmin", "true");
            pref.setString("admin", "true");

            pref.setString("name", snap['name']);
            pref.setStringList("families",[]);

            pref.setString("email", _emailController.text);
            await pref.setString("profileImage", "https://i.pinimg.com/736x/da/4f/ad/da4fad3f0c9549a86a70dc90d9208e8d.jpg");
            Navigator.pushReplacement(
                context, MaterialPageRoute(
                builder: (context) => adminScreen()));
          }


      }
      else if (snap.exists && _passwordController.text != snap['password']) {
        print("wrosnap['password']");
        setState(() {
          isError = true;
          _isLoading = false;
        });
      }
      else {
        setState(() {
          isError = true;
          _isLoading = false;
        });
        print("sadfdsf");

      }

  }



}
