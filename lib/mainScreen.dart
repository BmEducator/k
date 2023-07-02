import 'dart:async';


import 'package:bmeducators/utilis/internetConnection.dart';
import 'package:bmeducators/utilis/navigation_drawer.dart';
import 'package:flutter/material.dart';
// import 'package:connectivity/connectivity.dart';

import 'Screens/homeScreen.dart';

class MainScreen extends StatefulWidget {

  MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  bool hasInternet = true;
  String currentLocation = "";
  late StreamSubscription subscription;
  // InternetConnection connection = InternetConnection();

  @override
  void initState() {
    checkConnection();
    // subscription =  Connectivity().onConnectivityChanged.listen(checkConnect);
    super.initState();

  }

  @override
  void dispose(){
    // subscription.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:hasInternet?Stack(
          children: const [
            homeScreen(),
            NavigationDrawer()
          ],
        ): NoInternet(context));
  }

  void checkConnection() async{
    // hasInternet =await connection.checkConnection();
    setState((){
      hasInternet = hasInternet;
    });
  }
  // void checkConnect(ConnectivityResult r) async{
  //   hasInternet =await connection.checkConnection();
  //   setState((){
  //     hasInternet = hasInternet;
  //   });
  // }


  Widget NoInternet(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height*0.13,),
              Image.asset("assets/noconnection.png"),
              const Text("No Internet Connection",style: TextStyle(fontFamily: "Poppins",fontSize: 20),),
              const SizedBox(height: 6,),
              const Text("Please check your connection",style: TextStyle(fontSize: 16),),
              const SizedBox(height: 35,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.yellow,
                  elevation: 20,
                )
                ,onPressed: (){}, child: const Text("     Try Again     ",style:TextStyle(color: Colors.black),),)

            ],
          ),
        )
    );
  }


}
