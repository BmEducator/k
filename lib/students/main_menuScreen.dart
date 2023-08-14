
import 'dart:io';

import 'package:bmeducators/Models/notificationModel.dart';
import 'package:bmeducators/Screens/homeScreen.dart';
import 'package:bmeducators/mainScreen.dart';
import 'package:bmeducators/students/multipleCourses.dart';
import 'package:bmeducators/students/notifications_Screen.dart';
import 'package:bmeducators/students/quiz_Mainmenu.dart';
import 'package:bmeducators/students/schedule_classes.dart';
import 'package:bmeducators/students/video_lectures_forStudents.dart';
import 'package:bmeducators/utilis/updateApp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;


import '../Screens/admin/admin_Screen.dart';
import '../utilis/navigation_drawer.dart';
import 'my_Statistics.dart';


class mainMenu extends StatefulWidget {

  bool isfromLogin ;
  bool checkUpdate;
   mainMenu({Key? key,required this.isfromLogin,required this.checkUpdate}) : super(key: key);

  @override
  State<mainMenu> createState() => _mainMenuState();
}

class _mainMenuState extends State<mainMenu> {
  String loginAt= "";
  bool isLoading = true;
  bool hasUnreadNotification = false;
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();


  String email = "";
  String username = "";
  String fullUpdate = "1.0";
  String lite = "4.0";
  late SharedPreferences pref;
   List<notificationModel> notificationList  = [];
   List<String> familyList  = [];
   bool hasNotifcation = false;




  @override
  void initState() {

    init();


    // TODO: implement initState
    super.initState();

    // getNotifications();


    if(widget.isfromLogin){
      isLoading = true;
      Sinup();
    }

  }

  @override
  Widget build(BuildContext context) {
    return !isLoading?
    WillPopScope(
      onWillPop: ()async{
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => MainScreen()));
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
          body:Stack(
            children:[
              SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      SizedBox(height: 50,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.notifications_active_outlined,color: Colors.transparent,),

                            const Text(
                              "Profile",
                              style: TextStyle(fontFamily: "Poppins", fontSize: 25),
                            ),
                            InkWell(
                              onTap: (){
                               hasUnreadNotification = false;
                                setState(() {

                                });
                                Navigator.push(
                                    context, MaterialPageRoute(builder: (context) =>
                                  notificationsScreen(notificaitonslist: notificationList, name: username,),
                                fullscreenDialog: true));

                              },
                           child:Stack(
                             alignment: Alignment.topRight,
                             children: [
                               Material(
                                 elevation: 6,
                                 borderRadius: BorderRadius.circular(60),
                                 child: CircleAvatar(
                                   radius: 20,
                                     backgroundColor: Colors.orange.withOpacity(0.3),
                                     child: Icon(Icons.notifications_active_outlined,color: Colors.blue[700],size: 25,)),
                               ),

                              Visibility(
                                visible:hasUnreadNotification,
                                child: CircleAvatar(
                                  radius: 8,
                                  backgroundColor: Colors.red,
                                ),
                              )
                             ],
                           )
                            ),

                          ],
                        ),
                      ),
                      AnimationLimiter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:AnimationConfiguration.toStaggeredList(
                            duration: Duration(milliseconds: 905),
                              childAnimationBuilder: (widget)=> SlideAnimation(
                                horizontalOffset: 900.0,
                                  child: FadeInAnimation(child: widget)),
                              children:[

                                SizedBox(height: 40,),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [

                                        serviceContainer("classes.png", "Schedule Classes"),
                                        SizedBox(height: 20,),
                                        serviceContainer("lectures.jpeg", "Online Lectures"),
                                        SizedBox(height: 20,),
                                        serviceContainer("quizes.jpeg", "Quizzes"),
                                        SizedBox(height: 20,),
                                        serviceContainer("progress.jpeg", "Progress"),

                                      ],
                                    ),
                                  ],
                                ),
                              ])
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              NavigationDrawer(),

            ])
      ),
    ):
        Scaffold(
          body:Container(
            height: MediaQuery.of(context).size.height * 0.8,
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
        );
  }

  serviceContainer(String image,String name) {
    return
      InkWell(
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          splashColor: Colors.grey,
          onTap: () {
            if(name =="Schedule Classes" ){
              Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => scheduleClasses()));

            }
            else if(name =="Online Lectures"){
              if (familyList.length == 1) {
                Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>
                            Video_Lectures_students(family: familyList[0],)));
              }
              else {
                Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>
                            multipleCourses(isAdmin: username == "admin", type: 'video',)));
              }

            }
            else if(name == "Quizzes") {
              print(familyList.length);
              if (familyList.length == 1) {
                Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>
                            quizMainmenuScreen(myCourse: familyList[0],)));

              }
              else {
                Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>
                            multipleCourses(isAdmin: username == "admin", type: 'quiz',)));
              }
            }
            else {
              Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) =>
                          my_StatisticsScreen()));
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            height:MediaQuery.of(context).size.height*0.16,
            child: Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 10,
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      "assets/${image}",
                      width: MediaQuery.of(context).size.width * 0.3,
                      height:MediaQuery.of(context).size.height*0.1,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)
                        ),
                        color: Colors.blue.withOpacity(0.8),

                      ),
                      height:MediaQuery.of(context).size.height*0.03,

                      child: FittedBox(
                        child: Text(
                          name,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Poppins",fontSize: 14,
                              letterSpacing: 1),
                        ),
                      ),
                    )
                  ],
                )),
          ));

  }


  void Sinup() async {

    Map<String, dynamic> deviceData;

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
        loginAt = deviceData['brand'] +" "+  deviceData['model'];
        print(loginAt);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
        loginAt = deviceData['name'];
      }

        await FirebaseFirestore.instance.collection(
            "admin").doc("data").collection("students").doc("login").collection("logins").doc(email).
        update({"loginAt":loginAt});

      init();


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

  Future init() async {
    pref = await SharedPreferences.getInstance();

    setState(() {
      email = pref.getString("email")!;
      username = pref.getString("name")!;
      isLoading = false;

    });
    if(username == "admin"){
   familyList = [   'Permiso AM',
    'Permiso A1-A2',
    'Permiso B',
    'Permiso C',
    'Permiso D',
    'Permiso C+E',
    'CAP',
    'Curso de Taxi Barcelona',];

    }
    else{
      familyList = pref.getStringList("myCourses")!;

    }

    String first = "";

    String second = "";
    if(widget.checkUpdate){
      DatabaseReference ref = FirebaseDatabase.instance.ref().child("admin").child("appVersions");
      DatabaseEvent event = await ref.once();
      String fl = event.snapshot.children.first.value.toString();
      String lit = event.snapshot.children.last.value.toString();

      if(fullUpdate != fl){
        print("full");

        Navigator.pushReplacement(
            context, MaterialPageRoute(
            builder: (context) => UpdateScreen(updateType: 'full',)));
      }

      else if(lite != lit){
        print("lite");
        Navigator.pushReplacement(
            context, MaterialPageRoute(
            builder: (context) => UpdateScreen(updateType: 'lite',)));
      }
      else{
          getNotifications();
      }
    }
    else{
      getNotifications();

    }



  }

  getNotifications() async {
    print("getting Notifications");
    List<notificationModel> nlist = [];
    print(email);
    print(email.substring(0,email.indexOf("@")));
    await FirebaseDatabase.instance.ref().child("students").child(email.substring(0,email.indexOf("@"))).child("studentsNotifications")
    .get().then((DataSnapshot snapshot) {


     snapshot.children.forEach((element) {

      print(element.child("time").value);
       notificationModel n =
       notificationModel(
           message: element.child("Message").value.toString(),
           status: element.child("status").value.toString(),
           timestamp: int.parse(element.child("time").value.toString()));
       notificationList.add(n);


     });
     notificationList.sort((a, b) => a.timestamp.compareTo(b.timestamp));
     notificationList.reversed;

     notificationList.forEach((element) {

       if(element.status == "unread"){
         hasUnreadNotification = true;
         setState(() {

         });
         showNotification(context, element);

       }

     });

   });



  }




  Future<void> showNotification( context,notificationModel model ) {
    TextEditingController controller = TextEditingController();
    return showDialog(
      barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (thisLowerContext, innerSetState) {
            return Dialog(
              clipBehavior: Clip.antiAlias,
              child:  Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 20, 10, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Dear ${username}!",style: TextStyle(fontFamily: "Poppins",fontSize: 18,color: Colors.blue),),
                                SizedBox(height: 15,),
                                Text(model.message,style: TextStyle(fontFamily: "PoppinRegular",fontSize: 15,),),
                                SizedBox(height: 30,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text("Administration of BMEducators",style: TextStyle(fontFamily: "PoppinRegular",fontSize: 12,),),
                                  ],
                                ),],
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () async {

                          await FirebaseDatabase.instance.ref().child("students")
                              .child(email.substring(0,email.indexOf("@")))
                              .child("studentsNotifications")
                              .child(model.timestamp.toString()).update({
                            "status":"read"
                          });

                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                          child: Icon(Icons.close,size: 25,color: Colors.grey[600],),
                        ),
                      ),

                    ],
                  ),
                  SizedBox(height: 30,),
                ],
              )
            );
          });
        });




  }

    }

