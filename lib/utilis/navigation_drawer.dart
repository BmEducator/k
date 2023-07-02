import 'dart:async';
import 'dart:io';

import 'package:bmeducators/Screens/admin/adminprofile.dart';
import 'package:bmeducators/Screens/admin/promo.dart';
import 'package:bmeducators/Screens/homeScreen.dart';
import 'package:bmeducators/services_Screen/aboutUs_Scree.dart';
import 'package:bmeducators/students/myProfile.dart';
import 'package:bmeducators/utilis/developerInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Screens/admin/admin_Screen.dart';
import '../mainScreen.dart';
import '../resources/authMethods.dart';
import '../students/login_Screen.dart';


class NavigationDrawer extends StatefulWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  bool isClick = false;
  final _animationDuration = const Duration(milliseconds: 300);
  late StreamController<bool> isSidebarOpeedStreamCotroller;
  late Stream<bool> isSidebaropedStream;
  late StreamSink<bool> isSidebarOpeedSik;

  dynamic userData = {};
  bool isUrd = false;
  var color = const Color(0xffE3AC6D);
  var isurdu = [true, false];

  String name = "Login";
  String email = "";
  String profilLink = "";
  String isAdmin = "";

  late SharedPreferences pref;
  @override
  void initState() {
    super.initState();
    init();
    animationController =
        AnimationController(vsync: this, duration: _animationDuration);
    isSidebarOpeedStreamCotroller = PublishSubject<bool>();
    isSidebaropedStream = isSidebarOpeedStreamCotroller.stream;
    isSidebarOpeedSik = isSidebarOpeedStreamCotroller.sink;

  }

  Future init() async {

    pref = await SharedPreferences.getInstance();
    pref.setStringList("families",[]);


    if(pref.containsKey("name")){

      name = pref.getString("name")!;
      email = pref.getString("email")!;
      profilLink = pref.getString("profileImage")!;

    }


    setState(() {

    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void icopressed() {
    final animationStatus = animationController.status;
    final isAnimatioCompleted = animationStatus == AnimationStatus.completed;

    if (isAnimatioCompleted) {
      isSidebarOpeedSik.add(false);
      animationController.reverse();
    } else {
      animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {


    final width = MediaQuery.of(context).size.width;
    return StreamBuilder<bool>(
      initialData: false,
      stream: isSidebaropedStream,
      builder: (context, isSidebarOpeedAsy) {
        return AnimatedPositioned(
          duration: _animationDuration,
          top: 0,
          bottom: 0,
          left: isClick ? 0 : -width,
          right: isClick ? 0 : width - 35,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  // color: Color(0xff00aeff),
                  // color: Color(0xff111336),
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
                  child: ListView(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 60,
                                    ),
                                    ListTile(
                                        onTap: (){

                                        },

                                        title: Container(
                                          alignment: Alignment.centerLeft,
                                          width: MediaQuery.of(context).size.width*0.1,
                                          height: MediaQuery.of(context).size.height * 0.05,
                                          child: FittedBox(
                                            child: Text(
                                              name,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Poppins'),
                                            ),
                                          ),
                                        ),
                                        subtitle: Container(
                                          alignment: Alignment.centerLeft,
                                          width: MediaQuery.of(context).size.width * 0.01,
                                          height: MediaQuery.of(context).size.height * 0.03,
                                          child: FittedBox(
                                            child: Text(
                                              email,
                                              style:
                                              TextStyle(color: Colors.grey[300]),
                                            ),
                                          ),
                                        ),
                                        leading: CircleAvatar(
                                          radius: 40,
                                          backgroundImage: NetworkImage(profilLink),
                                        )

                                    ),
                                    Divider(
                                      height: 54,
                                      thickness: 0.5,
                                      color: Colors.grey[300],
                                      indent: 32,
                                      endIndent: 32,
                                    ),
                                    Visibility(
                                      visible: name != "admin" && name !="Login",
                                      child: ListTile(
                                          title: Container(
                                            alignment: Alignment.centerLeft,
                                            height: MediaQuery.of(context).size.height *0.035,
                                            child:  FittedBox(
                                              child: Text(
                                                'My Profile',
                                                style: TextStyle(
                                                  fontFamily: "PoppinRegular",
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          leading: const Icon(
                                            color: Colors.white,
                                            Icons.home_outlined,
                                          ),
                                          onTap: () => Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      myProfile(email: email)))),
                                    ),
                                    Visibility(
                                      visible: name == "admin",
                                      child: ListTile(
                                          title: Container(
                                            alignment: Alignment.centerLeft,
                                            height: MediaQuery.of(context).size.height *0.035,
                                            child:  FittedBox(
                                              child: Text(
                                                'My Profile',
                                                style: TextStyle(
                                                  fontFamily: "PoppinRegular",
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          leading: const Icon(
                                            color: Colors.white,
                                            Icons.home_outlined,
                                          ),
                                          onTap: () => Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      adminProfile(email: email)))),
                                    ),
                                    ListTile(
                                        title: Container(
                                          alignment: Alignment.centerLeft,
                                          height: MediaQuery.of(context).size.height *0.035,

                                          child:  FittedBox(
                                            child: Text(
                                              'Home',
                                              style: TextStyle(
                                                fontFamily: "PoppinRegular",
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        leading: const Icon(
                                          color: Colors.white,
                                          Icons.home_outlined,
                                        ),
                                        onTap: () => Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MainScreen()))),
                                    ListTile(
                                        title:  Container(
                                          alignment: Alignment.centerLeft,
                                          height: MediaQuery.of(context).size.height *0.035,

                                          child: FittedBox(
                                            child: Text(
                                              'Contact Us',
                                              style: TextStyle(
                                                fontFamily: "PoppinRegular",
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        leading: const Icon(
                                          color: Colors.white,
                                          Icons.call,
                                        ),
                                        onTap: () =>
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AboutScreen()))),

                                    Visibility(
                                      visible: name == "admin",
                                      child: ListTile(
                                          title:  Container(
                                            alignment: Alignment.centerLeft,
                                            height: MediaQuery.of(context).size.height *0.035,

                                            child: FittedBox(
                                              child: Text(
                                                'Promo',
                                                style: TextStyle(
                                                  fontFamily: "PoppinRegular",
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          leading: const Icon(
                                            color: Colors.white,
                                            Icons.notification_add_outlined ,
                                          ),
                                          onTap: () =>
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          promoScreen()))),
                                    ),
                                    ListTile(
                                        title:  Container(
                                          alignment: Alignment.centerLeft,
                                          height: MediaQuery.of(context).size.height *0.035,

                                          child: FittedBox(
                                            child: Text(
                                              'Rate our App',
                                              style: TextStyle(
                                                fontFamily: "PoppinRegular",
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        leading: const Icon(
                                          color: Colors.white,
                                          Icons.star_rate,
                                        ),
                                        onTap: () async {

                                          if (Platform.isAndroid || Platform.isIOS) {
                                            final appId = Platform.isAndroid ? 'com.bmeducators.bmeducators' : 'YOUR_IOS_APP_ID';
                                            final url = Uri.parse(
                                              Platform.isAndroid
                                                  ? "market://details?id=$appId"
                                                  : "https://apps.apple.com/app/id$appId",
                                            );
                                            launchUrl(
                                              url,
                                              mode: LaunchMode.externalApplication,
                                            );
                                          }

                                        }),

                                    ListTile(
                                        title:
                                        Container(
                                            alignment: Alignment.centerLeft,
                                            height: MediaQuery.of(context).size.height *0.035,
                                            child:FittedBox(
                                                child:Text(
                                                  name=="Login"?"Login": 'Logout',
                                                  style: TextStyle(
                                                    fontFamily: "PoppinRegular",
                                                    color: Colors.white,
                                                  ),
                                                ))),
                                        leading: const Icon(
                                          color: Colors.white,
                                          Icons.logout_outlined,
                                        ),
                                        onTap: () {

                                          if(name == "Login"){
                                            Navigator.pushReplacement(
                                                context, MaterialPageRoute(builder: (context) => loginScreen()));

                                          }
                                          else{
                                            _showDeleteDialog(context);
                                          }
                                        }),

                                    Visibility(
                                      visible: name == "admin",
                                      child: ListTile(
                                          title: const Text(
                                            'Admin',
                                            style: TextStyle(
                                              fontFamily: "Poppins",
                                              color: Colors.amber,
                                            ),
                                          ),
                                          leading: const Icon(
                                            color: Colors.amber,
                                            Icons.admin_panel_settings_outlined,
                                          ),
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        adminScreen()));
                                          }),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: (){
                                Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            developersInformation()));

                              },
                              child: Column(
                                children: [
                                  Text("Developed by",style: TextStyle(fontFamily: "PoppinRegular",color: Colors.grey,fontSize: 11),),
                                  SizedBox(height: 5,),
                                  Text("Maan",style: TextStyle(color: Colors.white,fontFamily: "PoppinRegular"),)
                                 , SizedBox(height: 90,)

                                ],
                              ),
                            ),
                          ],
                        ),
                      )

                    ],
                  ),
                ),
              ),

              InkWell(
                onTap: () {
                  if(isClick){
                  icopressed();
                  setState(() {
                    isClick = !isClick;
                  });}
                },
                child: Container(
                  color: Colors.transparent,
                  child: Align(
                      alignment: const Alignment(0, -0.92),
                      child: GestureDetector(
                        onTap: () {
                          icopressed();
                          setState(() {
                            isClick = !isClick;
                          });
                        },
                        child: ClipPath(
                          clipper: CustomMClipper(),
                          child: Container(
                            alignment: Alignment.centerLeft,
                            width: 35,
                            height: 90,
                            color: Color(0xff0033cc),
                            child: AnimatedIcon(
                              progress: animationController.view,
                              icon: AnimatedIcons.menu_close,
                              color: Colors.white,
                              size: 29,
                            ),
                          ),
                        ),
                      )),
                ),
              )
            ],
          ),
        );
      },
    );
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

  Future<void>? _showDeleteDialog(BuildContext context) async {
    return (
        await showDialog(context: context,
            builder: (context)
            =>
                AlertDialog(
                  content: const Text("Do you want to Logout?",
                    style: TextStyle(fontFamily: "PoppinRegular"),),
                  actions: [
                    TextButton(onPressed: () {
                      Navigator.pop(context);
                    },
                      child: const Text(
                          "No", style: TextStyle(fontFamily: "Poppins")),),
                    TextButton(onPressed: () async {
                      pref.clear();

                      if(name == "admin"){
                        pref.setString("isAdmin", "false");

                     }else{
                       await FirebaseFirestore.instance.collection(
                           "admin").doc("data").collection("students").doc("login").collection("logins").doc(email).
                       update({"loginAt":""});
                     }
                      AuthMethods auth = AuthMethods();
                      auth.signOut();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => MainScreen()));

                    },
                      child: const Text("Yes", style: TextStyle(
                          color: Colors.grey, fontFamily: "Poppins")),),
                  ],
                )
        )
    );


  }
}



class CustomMClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Paint paint = Paint();
    paint.color = Colors.blueAccent;

    final width = size.width;
    final height = size.height;

    Path path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(0, 8, 10, 16);
    path.quadraticBezierTo(width - 1, height / 2 - 20, width, height / 2);
    path.quadraticBezierTo(width + 1, height / 2 + 20, 10, height - 16);
    path.quadraticBezierTo(0, height - 8, 0, height);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }





}
