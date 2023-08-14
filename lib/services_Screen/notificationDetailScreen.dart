import 'package:bmeducators/Screens/homeScreen.dart';
import 'package:flutter/material.dart';

import '../mainScreen.dart';
import '../students/main_menuScreen.dart';

class notificationDetailScreen extends StatefulWidget {
  String message;
  String name;
   notificationDetailScreen({Key? key,required this.message,required this.name}) : super(key: key);

  @override
  State<notificationDetailScreen> createState() => _notificationDetailScreenState();
}

class _notificationDetailScreenState extends State<notificationDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => MainScreen()));
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.blue,
        body: SafeArea(
          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height*0.2,),
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Material(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[200],
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Dear ${widget.name}!",style: TextStyle(fontFamily: "Poppins",fontSize: 22,color: Colors.blue),),
                                SizedBox(height: 10,),
                                Text(widget.message,style: TextStyle(fontFamily: "PoppinRegular",fontSize: 17,),),
                                SizedBox(height: 30,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text("Administration of BMEducators",style: TextStyle(fontFamily: "PoppinRegular",fontSize: 12,),),
                                  ],
                                ),],
                            ),
                          ),
                        ),
                        SizedBox(height: 200,)
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => mainMenu(isfromLogin: false, checkUpdate: false,)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                      child: Icon(Icons.close,size: 25,color: Colors.grey[600],),
                    ),
                  ),

                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
