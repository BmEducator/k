import 'dart:async';
import 'dart:io' show Platform;
import 'dart:math';

import 'package:bmeducators/Screens/admin/BAAB.dart';
import 'package:bmeducators/services_Screen/aboutUs_Scree.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Screens/admin/admin_Screen.dart';
import '../mainScreen.dart';
import '../resources/authMethods.dart';
import 'accessDeniedScreen.dart';
import 'main_menuScreen.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({Key? key}) : super(key: key);

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {

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
  String currentDevice = "";

  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  @override
  void initState() {
    super.initState();
    init();
    Sinup();
  }

  Future init() async{
    pref = await SharedPreferences.getInstance();

  }

  @override
  Widget build(BuildContext context) {
    return !_isLoading?GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          backgroundColor:Color(0xff111336),
          body: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width ,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors:[
                        Color(0xff0033cc),
                        Color(0xff111336),

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
                    InkWell(
                      onDoubleTap: (){
                        Navigator.pushReplacement(
                            context, MaterialPageRoute(
                            builder: (context) => baab()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50,vertical: 30),
                        child: Image.asset("assets/splashlogofull.png"),
                      ),
                    ),
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
                    Visibility(
                      visible: loginAt != "",
                      child: SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "    * ${loginAt} ",
                                style: TextStyle(color: Colors.white,fontFamily: "PoppinRegular"),
                                textAlign: TextAlign.start,
                              ),
                              InkWell(
                                onTap: (){
                                  showHelp(context);
                                },
                                child: Row(
                                  children: [
                                    Text("Help ",style: TextStyle(color: Colors.lightBlueAccent),),
                                    Icon(Icons.help_outline,color: Colors.lightBlueAccent,),
                                    Text("    ")
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Container(
                    //   height: 50,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       GestureDetector(
                    //           onTap: () {
                    //           },
                    //           child: const Text(
                    //             "Forget password?",
                    //             style: TextStyle(color: Colors.yellow,
                    //                 fontSize: 14,fontFamily: "PoppinRegular"),
                    //             textAlign: TextAlign.right,
                    //           )),
                    //       GestureDetector(
                    //           onTap: () {
                    //             Navigator.of(context).push(
                    //                 MaterialPageRoute(
                    //                     builder: (context) =>
                    //                         AboutScreen()));
                    //           },
                    //           child: const Text(
                    //             "Register",
                    //             style: TextStyle(color: Colors.yellow,
                    //                 fontSize: 14,fontFamily: "PoppinRegular"),
                    //             textAlign: TextAlign.right,
                    //           )),
                    //     ],
                    //   ),
                    // ),
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
                              : const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
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
          )),
    ):

    Scaffold(
        body: Container
          (
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors:[
                    Color(0xff0033cc),
                    Color(0xff111336),

                  ] ,

                  begin: Alignment.topRight,
                  end: Alignment.bottomCenter
              )
          ),
          child: Center(
              child: LoadingAnimationWidget.discreteCircle(
                color: Colors.white,
                size: 50,
              )),
        ));


  }



  void Sinup() async {

    Map<String, dynamic> deviceData;
    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
        currentDevice = deviceData['brand'] + " " + deviceData['model'];
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
        currentDevice = deviceData['name'];
      }


      print("myDevice = " + currentDevice);
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

  }


  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
      //'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  verifyInput() {


    final bool isValidMail =RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_'{|}-]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_emailController.text);


    if (!isValidMail ) {
      isEmailEntered = false;
    }
    if (_passwordController.text.isEmpty || _passwordController.text.length<6) {
      ispassEntered = false;
    }

    setState(() {});
  }

  void login() async {

    // String res = await AuthMethods().loginUser(
    //   email: _emailController.text,
    //   password: _passwordController.text,
    // );
    //
    // print(res);
    setState(() {
      _isLoading = true;
    });
    DocumentSnapshot snapp = await FirebaseFirestore.instance.collection(
        "admin").doc("data").collection("students").doc("login").collection(
        "logins").doc(_emailController.text).get();

    if (snapp.exists && _passwordController.text == snapp['password']) {

      loginAt = snapp['loginAt'];


      if (loginAt == "" || loginAt == currentDevice) {
        setState(() {
          _isLoading = true;
        });

         await AuthMethods().signUpUser(
          email: _emailController.text,
          password: _passwordController.text,
        );


        await AuthMethods().loginUser(
            email: _emailController.text, password: _passwordController.text);



        DocumentSnapshot snap = await FirebaseFirestore.instance.collection(
            "admin").doc("data").collection("students").doc("login")
            .collection("logins").doc(_emailController.text)
            .get(GetOptions(source: Source.server));

        print(snap['name']);
        pref.setString("name", snap['name']);
        pref.setString("admin", "true");
        pref.setString("myFamily", snap['licenseType']);
        print("family");
        print(pref.getString("myFamily"));
        pref.setString("email", _emailController.text);
        pref.setStringList("families", []);
        pref.setString("lastUpdateAccessTime", "");
        String _imageUrl = snap['profileImage'];
        // String _imageUrl = "https://i.pinimg.com/736x/da/4f/ad/da4fad3f0c9549a86a70dc90d9208e8d.jpg";
        await pref.setString("profileImage", _imageUrl);
        await pref.setBool("isSignedUp", true);

        getUserDetail();

        // else {
        //   String re = await AuthMethods().loginUser(
        //       email: _emailController.text, password: _passwordController.text);
        //
        //   print(re + " llll");
        //   setState(() {
        //     _isLoading = false;
        //   });
        //
        //   DocumentSnapshot snap = await FirebaseFirestore.instance.collection(
        //       "admin").doc("data").collection("students").doc("login")
        //       .collection("logins").doc(_emailController.text)
        //       .get(GetOptions(source: Source.server));
        //
        //   print(snap['name']);
        //   pref.setString("name", snap['name']);
        //   pref.setString("admin", "true");
        //   pref.setString("myFamily", snap['licenseType']);
        //   print("family");
        //   print(pref.getString("myFamily"));
        //   pref.setString("email", _emailController.text);
        //   pref.setStringList("families", []);
        //   pref.setString("lastUpdateAccessTime", "");
        //   String _imageUrl = snap['profileImage'];
        //   // String _imageUrl = "https://i.pinimg.com/736x/da/4f/ad/da4fad3f0c9549a86a70dc90d9208e8d.jpg";
        //   await pref.setString("profileImage", _imageUrl);
        //   await pref.setBool("isSignedUp", true);
        //
        //
        //   // String id = FirebaseAuth.instance.currentUser!.uid;
        //   // FirebaseFirestore.instance.collection("users").doc(id).update({"token":t});
        //
        //
        //   print("succ");
        //   print(snap['name']);
        //   pref.setString("isAdmin", "true");
        //
        //   pref.setStringList("families",[]);
        //   pref.setString("myFamily", snap['LicenseType']);
        //   pref.setString("email", _emailController.text);
        //   // String _imageUrl = "https://i.pinimg.com/736x/da/4f/ad/da4fad3f0c9549a86a70dc90d9208e8d.jpg";
        //   await pref.setString("profileImage", _imageUrl);
        //
        //   Navigator.pushReplacement(
        //       context, MaterialPageRoute(
        //       builder: (context) => mainMenu(isfromLogin: true, checkUpdate: true,)));
        // }
      }
      else if (loginAt != "") {
        isError = false;
        isLoginAtSomeWhere = true;
        setState(() {
          _isLoading = false;
        });
      }
    }
    else if (snapp.exists && _passwordController.text != snapp['password']) {
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



  Future<void> showHelp( context) {
    TextEditingController controller = TextEditingController();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (thisLowerContext, innerSetState) {
            return Dialog(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding:  EdgeInsets.all(15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Your Account is Currently logged-in an another device ",style: TextStyle(fontFamily: "PoppinRegular",fontSize: 15),),
                    SizedBox(height: 10,),
                    Text("* $loginAt",style: TextStyle(fontFamily: "Poppins",fontSize: 15,color: Colors.lightBlue),),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Contact BMEducator's Administration for more information....",style: TextStyle(fontFamily: "PoppinRegular",fontSize: 15,color: Colors.green),),

                    const SizedBox(height: 30,),
                    Row(
                      children: [
                        Icon(Icons.home,color: Colors.orangeAccent,),
                        Text(" Address",style: TextStyle(fontFamily: "PoppinRegular",fontSize: 16),),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Text("Calle Wagner 61-61, Santa Coloma de Gramenet, Barcelona, Spain",style: TextStyle(fontFamily: "Poppins",fontSize: 13),),
                    Divider(thickness: 2,),
                    const SizedBox(height: 30,),



                    Row(
                      children: [
                        Icon(Icons.call,color: Colors.orangeAccent,),
                        Text(" Phone",style: TextStyle(fontFamily: "PoppinRegular",fontSize: 16),),
                      ],
                    ),
                    const SizedBox(height: 10,),

                    InkWell(
                        onTap: () async {
                          Uri u = Uri(
                            scheme: 'tel',
                            path:"+34 631276431",
                          );
                          await launchUrl(u);
                        },
                        child: Text("+34 631276431",style: TextStyle(color: Colors.purpleAccent,fontFamily: "Poppins",fontSize: 17),)),
                    Divider(thickness: 2,),
                    const SizedBox(height: 30,),

                  ],
                ),
              ),
            );
          });
        });




  }

  Future<void> getUserDetail() async {
    print("getting");

    var accessDate = "null";
    String type = "";

    String email = _emailController.text;

    var today = DateTime.now();
      int  todaytimestamp  = today.millisecondsSinceEpoch;
      var accessTimestamp;
      var tdy = DateFormat('dd-MM-yyyy').format(today);

      DatabaseReference ref = FirebaseDatabase.instance.ref().child("students").child(email.substring(0,_emailController.text.indexOf("@"))).
      child("accessLimit").child("limit");

      DatabaseEvent event = await ref.once();

      if(event.snapshot.exists){
        accessTimestamp = event.snapshot.children.first.value.toString();
       var d = DateTime.fromMillisecondsSinceEpoch(int.parse(accessTimestamp));
          accessDate = DateFormat('dd-MM-yyyy').format(d);

     print(d );
        if(accessTimestamp == null || accessTimestamp == ""){
          Navigator.pushReplacement(
              context, MaterialPageRoute(
              builder: (context) => mainMenu(isfromLogin: true, checkUpdate: true,)));

        }

        else if(accessDate == tdy){
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => accessDeniedScreen()));
        }
        else if(todaytimestamp > (int.parse(accessTimestamp))){
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => accessDeniedScreen()));
        }
        else{
          Navigator.pushReplacement(
              context, MaterialPageRoute(
              builder: (context) => mainMenu(isfromLogin: true, checkUpdate: true,)));

        }
      }
      else{
        Navigator.pushReplacement(
            context, MaterialPageRoute(
            builder: (context) => mainMenu(isfromLogin: true, checkUpdate: true,)));

      }//   try{
      //     await FirebaseDatabase.instance.ref().child("students").child(email.substring(0,email.indexOf("@"))).
      //   child("accessLimit").child("limit").get().then((DataSnapshot snapshot) {
      //
      //     String temp = "";
      //     snapshot.children.forEach((element) {
      //
      //       temp = element.children.first.value.toString();
      //
      //     });
      //     // var d = DateTime.fromMillisecondsSinceEpoch(int.parse(temp));
      //     // accessDate = DateFormat('dd-MM-yyyy').format(d);
      //     print(temp);
      //
      //   });
      //   }on FirebaseException catch  (e) {
      // print('Failed with error code: ${e.code}');
      // print(e.message);
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (context) => accessDeniedScreen()));
      //   }
      //


    // if(widget.type == "home") {
    //   if(isAdmin == "false" || isAdmin == ""){
    //     var lastupdate = pref.getString("lastUpdateAccessTime");
    //     var access = "";
    //     var today = DateTime.now();
    //     print(access);
    //     var tdy = DateFormat('dd-MM-yyyy').format(today);
    //
    //     if(access == "blocked"){
    //       type = "blocked";
    //
    //     }
    //     else if(lastupdate != tdy ) {
    //       print("updated from firestore");
    //       String? email = pref.getString("email");
    //       String accessDate = "";
    //
    //       await FirebaseFirestore.instance.collection(
    //           "admin").doc(
    //           "data").collection("students").doc(
    //           "allStudents").collection("allStudents")
    //           .doc(email).get().then((value) {
    //         print(value["accessDate"]);
    //         accessDate = value["accessDate"];
    //
    //       });
    //
    //       if(accessDate!="") {
    //         var d = DateTime.fromMillisecondsSinceEpoch(
    //             int.parse(accessDate));
    //         var a = DateFormat('dd-MM-yyyy').format(d);
    //         pref.setString("lastUpdateAccessTime", tdy);
    //         access = a;
    //         pref.setString("accessDate", a);
    //       }
    //       else{
    //         type = "mainMenu";
    //
    //       }
    //     }
    //
    //     if(access == tdy ){
    //       print("blocked");
    //       pref.setString("accessDate", "blocked");
    //
    //     }
    //
    //     if(access != "blocked" && access != tdy){
    //       type = "mainMenu";
    //     }
    //
    //   else{
    //     type = "admin";
    //     }
    //   }
    //
    // }
    // else{
    //   Navigator.pushReplacement(
    //       context, MaterialPageRoute(builder: (context) => MainScreen()));
    // }
    //
    // print("tim");



  }

}
