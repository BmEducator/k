
import 'package:flutter/material.dart';

import '../mainScreen.dart';
import '../utilis/navigation_drawer.dart';



class license_screen extends StatefulWidget {
  const license_screen({Key? key}) : super(key: key);

  @override
  State<license_screen> createState() => _license_screenState();
}

class _license_screenState extends State<license_screen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => MainScreen()));
        return true;
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          body:Stack(
              children:[
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 100,),
                        Container(
                          width: MediaQuery.of(context).size.width*0.7,
                          child: Material(
                            elevation: 18,
                            color: Colors.transparent,
                            child: FittedBox(
                              child: const Text(
                                "What License we offer?",
                                style: TextStyle(fontFamily: "Poppins", fontSize: 24),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 40,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Column(children: [],),],),

                         Container(
                             width: MediaQuery.of(context).size.width*0.45,
                           child: FittedBox(
                           child: Text(
                            "Driving License B",
                            style: TextStyle(color: Colors.blue,fontFamily: "Poppins", fontSize: 20),
                        ),
                         )),
                        SizedBox(height: 10,),
                        Image.asset("assets/license1.jpg",height: MediaQuery.of(context).size.height *0.2),
                        SizedBox(height: 15,),

                        Divider(thickness: 2,),
                        SizedBox(height: 15,),

                        Container(
                            width: MediaQuery.of(context).size.width*0.45,
                            child: FittedBox(
                              child: Text(
                                "Driving License AM",
                                style: TextStyle(color: Colors.blue,fontFamily: "Poppins"),
                              ),
                            )),

                        SizedBox(height: 10,),
                        Image.asset("assets/license2.jpg",height: MediaQuery.of(context).size.height *0.23,),
                        SizedBox(height: 55,),


                        Divider(thickness: 2,),
                        SizedBox(height: 15,),

                        Container(
                            width: MediaQuery.of(context).size.width*0.48,
                            child: FittedBox(
                              child: Text(
                                "Driving License A1",
                                style: TextStyle(color: Colors.blue,fontFamily: "Poppins"),
                              ),
                            )),

                        SizedBox(height: 10,),
                        Image.asset("assets/license3.jpg",height: MediaQuery.of(context).size.height *0.25),
                        SizedBox(height: 55,),


                        Divider(thickness: 2,),
                        SizedBox(height: 15,),


                        Container(
                            width: MediaQuery.of(context).size.width*0.45,
                            child: FittedBox(
                              child: Text(
                                "Driving License C",
                                style: TextStyle(color: Colors.blue,fontFamily: "Poppins"),
                              ),
                            )),

                        SizedBox(height: 10,),
                        Image.asset("assets/license4.jpg",height: MediaQuery.of(context).size.height *0.2),
                        SizedBox(height: 55,),


                        Divider(thickness: 2,),
                        SizedBox(height: 15,),


                        Container(
                            width: MediaQuery.of(context).size.width*0.48,
                            child: FittedBox(
                              child: Text(
                                "Driving License A2",
                                style: TextStyle(color: Colors.blue,fontFamily: "Poppins"),
                              ),
                            )),

                        SizedBox(height: 10,),
                        Image.asset("assets/license5.jpg",height: MediaQuery.of(context).size.height *0.2),
                        SizedBox(height: 55,),
                      ],
                    ),
                  ),
                ),
                NavigationDrawer(),

              ])
      ),
    );
  }


  }

