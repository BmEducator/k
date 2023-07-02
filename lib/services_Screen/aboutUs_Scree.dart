import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Screens/homeScreen.dart';
import '../mainScreen.dart';


class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  TextEditingController t = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) =>
                    MainScreen()));
        return true;
      },
      child: Scaffold(
          backgroundColor: Colors.white,

        body: SafeArea(
          child: SingleChildScrollView(
        child:Column(
          children: [
            Stack(
                alignment: Alignment.center,
                children:
                [
                  Container(height:150,color:Colors.blue,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Row(
                        children: [
                          InkWell(
                              onTap: () async {

                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => MainScreen()));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: const Icon(Icons.arrow_back_ios, color: Colors.white,),
                              )),

                        ],
                      ),
                    ),),
                  Image.asset("assets/splashlogofull.png",height: 100,),

                ]),
            AnimationLimiter(
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children:AnimationConfiguration.toStaggeredList(
    duration: Duration(milliseconds: 905),
    childAnimationBuilder: (widget)=> SlideAnimation(
    horizontalOffset: 900.0,
    child: FadeInAnimation(child: widget)),
    children:[

      Padding(padding: EdgeInsets.all(20),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20,),

                  Text("Wish to enquire about admissions, syllabus, or anything else? You can walk in during office hours, give us a call...",style: TextStyle(fontFamily: "PoppinRegular",fontSize: 16),),
                  Divider(thickness: 2,),
                  const SizedBox(height: 30,),

                  Row(
                    children: [
                      Icon(Icons.home,color: Colors.orangeAccent,),
                      Text(" Address",style: TextStyle(fontFamily: "PoppinRegular",fontSize: 16),),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Text("Calle Wagner 61-61, Santa Coloma de Gramenet, Barcelona, Spain",style: TextStyle(fontFamily: "Poppins"),),
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


                 InkWell(
                   onTap: () async {
                     Uri _url = Uri.parse('https://www.bmeducators.com');
                     if (await launchUrl(_url)) {
                     await launchUrl(_url);
                     } else {
                     throw 'Could not launch $_url';
                     }
                   },
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Row(
                         children: [
                           Icon(Icons.web,color: Colors.orangeAccent,),
                           Text(" Website",style: TextStyle(fontFamily: "PoppinRegular",fontSize: 16),),
                           Divider(thickness: 2,),
                         ],
                       ),
                       const SizedBox(height: 10,),
                       Text("bmeducators.com",style: TextStyle(color: Colors.blue,fontFamily: "Poppins"),),
                       const SizedBox(height: 30,),
                     ],
                   ),
                 ),



                  Row(
                    children: [
                      Icon(Icons.mail_outline,color: Colors.orangeAccent,),
                      Text(" Email",style: TextStyle(fontFamily: "PoppinRegular",fontSize: 16),),
                      Divider(thickness: 2,),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Text("contact@bmeducators.com",style: TextStyle(fontFamily: "Poppins"),),
                  const SizedBox(height: 30,),


                ],
              )
      ),


      Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                InkWell(
                  onTap: (){
                    if (Platform.isAndroid || Platform.isIOS) {
                      final url = Uri.parse("https://m.facebook.com/story.php?story_fbid=pfbid0M2qtqPPjJDN9m3xMhu6u7RxmaQof8FWUB9pXiD7mDzd5CfgHTUKqdCjfzLL7YXYZl&id=100088702628216&mibextid=Nif5oz");
                      launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      );}},
                  child: Icon(Icons.facebook,size: 35,color: Colors.white,),
                ),
                Row(
                  children:  [
                    Icon(Icons.whatsapp,size: 35,color: Colors.white,),


                    InkWell(
                        onTap:(){
                          if (Platform.isAndroid || Platform.isIOS) {
                            final url = Uri.parse("https://www.instagram.com/p/CmDgz6pI-lj/?igshid=MDJmNzVkMjY=");
                            launchUrl(
                              url,
                              mode: LaunchMode.externalApplication,
                            );}},
                        child: Text("Follow us on Instagram",style: TextStyle(fontSize:15,fontFamily: "PoppinRegular",color: Colors.white),)),
                  ],
                ),


                InkWell(
                  onTap: (){
                    _launchUrl();
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.update,size: 35,color: Colors.white,),
                      SizedBox(width: 10,),
                      Text("Check Updates",style: TextStyle(fontSize:15,fontFamily: "PoppinRegular",color: Colors.white),),
                    ],
                  ),
                ),

                const Divider(thickness: 1,color: Colors.white),

              ],
            ),
      )
   ]))),
          ],
        ),


    ),
        ),
      ),
    );
  }
  Future<void> _launchUrl() async {
    if (Platform.isAndroid || Platform.isIOS) {
      final appId = Platform.isAndroid ? 'com.maan.fullstop' : 'YOUR_IOS_APP_ID';
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
  }

}
