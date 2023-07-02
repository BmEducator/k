import 'package:bmeducators/Models/studentModel.dart';
import 'package:flutter/material.dart';

class adminSettings extends StatefulWidget {

  adminSettings({Key? key}) : super(key: key);

  @override
  State<adminSettings> createState() => _adminSettingsState();
}

class _adminSettingsState extends State<adminSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
            child:Padding(
              padding:EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back_ios,color: Colors.black,)),
                  SizedBox(height: 10,),
                  Text("Admin Settings",style: TextStyle(fontSize: 28,fontFamily: "Poppins",color: Colors.lightBlue),),

                  SizedBox(height: 20,),
                  Container(
                    padding: EdgeInsets.only(right: 60),
                    width: MediaQuery.of(context).size.width *1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Counciling",style: TextStyle(fontSize: 20,fontFamily: "Poppins"),),
                        Switch(value: true, onChanged: (r){
                        }),
                      ],
                    ),
                  ),
                  SizedBox(height: 15,),
                  Container(
                    padding: EdgeInsets.only(right: 60),
                    width: MediaQuery.of(context).size.width *1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Help",style: TextStyle(fontSize: 20,fontFamily: "Poppins"),),
                        Switch(value: true, onChanged: (r){
                        }),
                      ],
                    ),
                  ),
                  SizedBox(height: 15,),
                  Container(
                    padding: EdgeInsets.only(right: 60),
                    width: MediaQuery.of(context).size.width *1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Video Lectures",style: TextStyle(fontSize: 20,fontFamily: "Poppins"),),
                        Switch(value: true, onChanged: (r){
                        }),
                      ],
                    ),
                  ),
                  SizedBox(height: 15,),
                  Container(
                    padding: EdgeInsets.only(right: 60),
                    width: MediaQuery.of(context).size.width *1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Study Mode",style: TextStyle(fontSize: 20,fontFamily: "Poppins"),),
                        Switch(value: true, onChanged: (r){
                        }),
                      ],
                    ),
                  ),
                  SizedBox(height: 15,),
                  Container(
                    padding: EdgeInsets.only(right: 60),
                    width: MediaQuery.of(context).size.width *1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Exam Mode",style: TextStyle(fontSize: 20,fontFamily: "Poppins"),),
                        Switch(value: true, onChanged: (r){
                        }),
                      ],
                    ),
                  ),
                  SizedBox(height: 15,),


                ],
              ),
            )
        ),
      ),
    );
  }
}
