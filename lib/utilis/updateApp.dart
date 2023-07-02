import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../students/main_menuScreen.dart';


class UpdateScreen extends StatefulWidget {
  String updateType;
  UpdateScreen({Key? key,required this.updateType}) : super(key: key);

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: willpop,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              Padding(
                padding: const EdgeInsets.symmetric(horizontal:20,vertical: 40),
                child: Image.asset("assets/update.png"),
              ),

              Visibility(
                visible: widget.updateType == "lite",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Time to Update",style: TextStyle(color: Colors.amber[900],fontFamily: "Poppins",fontSize: 18),),
                    const SizedBox(height: 10,),
                    const Text("We added a lot of new features and fixed some bugs to make your experience as smooth as possible.."
                      ,style: TextStyle(fontFamily: "PoppinRegular",fontSize: 16),),

                  ],
                ),
              ),
              Visibility(
                visible: widget.updateType == "full",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Update required",style: TextStyle(fontFamily: "Poppins",fontSize: 16),),
                    const SizedBox(height: 20,),
                    const Text("The installed version of BM-EDUCATORS is no longer supported. Please update your app.",style: TextStyle(fontFamily: "PoppinRegular",fontSize: 16),),

                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: Column(
                  children: [
                    ElevatedButton(onPressed: (){
                      _launchUrl();
                    }, style: ElevatedButton.styleFrom(
                      elevation: 10,
                    ),child:
                    Container(
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        child: const Text("Update",style: TextStyle(fontFamily: "Poppins",fontSize: 16),))),
                    Visibility(
                      visible: widget.updateType =="lite",
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: ElevatedButton(onPressed: (){

                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => mainMenu(isfromLogin: false, checkUpdate: false,)));

                        },style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 1,
                        ), child:
                        Container(
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            child: const Text(
                              "Not now",style: TextStyle(color:Colors.black,fontFamily: "Poppins",fontSize: 16),))),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl() async {

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

  }}

Future<bool> willpop() async {
  return false;
}

