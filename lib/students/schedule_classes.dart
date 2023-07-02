import 'package:bmeducators/students/main_menuScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class scheduleClasses extends StatefulWidget {
  const scheduleClasses({Key? key}) : super(key: key);

  @override
  State<scheduleClasses> createState() => _scheduleClassesState();
}



class _scheduleClassesState extends State<scheduleClasses> {
  int currentstep= 0;
  List<dynamic> sant_English = [];
  List<dynamic> fondo_English= [];
  List<dynamic> center_English = [];


  List<dynamic> fondo_spanish = [];
  List<dynamic> sant_spanish = [];
  List<dynamic> center_spanish = [];


  @override
  void initState() {
    getSchedule();
    // TODO: implement initState
    super.initState();
  }

  Future<bool> willpop() async {

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => mainMenu(isfromLogin: false, checkUpdate: false,)));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: willpop,
      child: Scaffold(
        body:SafeArea(
          child: Padding(padding: EdgeInsets.all(10)
          ,child:  SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                        onTap: (){
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => mainMenu(isfromLogin: false, checkUpdate: false,)));
                          ;
                        },
                        child: Icon(Icons.arrow_back_ios,size: 30,)),
                    SizedBox(height: 20,),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
                        child:FittedBox(
                          child: Text(
                            "Classses Schedule",
                            style: const TextStyle(
                                fontFamily: "Poppins"),
                          ),
                        )
                    ),

                    Divider(thickness: 4,endIndent: 80,),
                    SizedBox(height: 30,),

                    Column(
                      children: [
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return item("  Fondo   ",fondo_English[index], fondo_spanish[index],index,fondo_English.length-1);
                          },
                          itemCount:fondo_English.length,
                        ),


                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return item("Sant Adria",sant_English[index], sant_spanish[index],index,sant_English.length-1);
                          },
                          itemCount:sant_English.length,
                        ),


                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return item("  Center  ",center_English[index], center_spanish[index],index,center_English.length-1);
                          },
                          itemCount:center_English.length,
                        ),

                      ],
                    )
                    // Stepper(
                    //   margin: EdgeInsets.symmetric(vertical: 10),
                    //     controlsBuilder: (context,controller){
                    //       return Row(children: [
                    //
                    //       ],);
                    //     },
                    //     steps: _steps)
                  ],
                ),
          ),
          )
        ),
      ),
    );
  }

void getSchedule() async{
  await FirebaseFirestore.instance.collection("admin").doc("data").
  collection("classes").
  doc("classes").get().then((value) {

    fondo_English =  value["fondoEnglish"];
    fondo_spanish =  value["fondoSpanish"];
    sant_English =  value["santEnglish"];
    sant_spanish =  value["santSpanish"];
    center_English =  value["centerEnglish"];
    center_spanish =  value["centerSpanish"];
  });

  setState(() {

  });


      // {
      //   "fondoEnglish":fondo_English,
      //   "fondoSpanish":fondo_spanish,
      //   "santEnglish":sant_English,
      //   "santSpanish":sant_spanish,
      //   "centerEnglish":center_English,
      //   "centerSpanish":center_spanish,
      // }

}

item(String name,String english, String spanish, int index,int size){

    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            children: [
              name!="Sant Adria"?
              Container(
                width: MediaQuery.of(context).size.width*0.2,
                height: MediaQuery.of(context).size.height * 0.1,
                child: FittedBox(
                  child: Text(name,style: TextStyle(
                      color:index == 0?  name != "Sant Adria" ?Colors.blue:Colors.deepOrange : Colors.transparent
                      ,fontFamily: "Poppins",fontSize: 18),
                  ),
                ),
              ):
              Container(
                width: MediaQuery.of(context).size.width*0.2,
                height: MediaQuery.of(context).size.height * 0.1,
                child: FittedBox(
                  child: Column(
                    children: [
                      Text("Sant ",style: TextStyle(
                          color:index == 0?  name != "Sant Adria" ?Colors.blue:Colors.deepOrange : Colors.transparent
                          ,fontFamily: "Poppins",fontSize: 18),
                      ),
                      Text(" Adria  ",style: TextStyle(
                          color:index == 0?  name != "Sant Adria" ?Colors.blue:Colors.deepOrange : Colors.transparent
                          ,fontFamily: "Poppins",fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  VerticalDivider(
                    thickness: 4,
                    width: 20,
                    color: name != "Sant Adria"  ? Colors.blue:Colors.orange,
                  ),
                  CircleAvatar(
                      radius: 12,
                      backgroundColor: name != "Sant Adria"?Colors.blue : Colors.orange,
                      child: Icon(Icons.star,color: Colors.white,size: 15,))

                ],
              ),
              SizedBox(width: 20,),
              index == 0?
              Container(
                decoration: BoxDecoration(
                    color: name !="Sant Adria"? Colors.blue[500] :Colors.orange,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color:name =="Sant Adria"? Colors.black.withOpacity(0.2): Colors.blueAccent.withOpacity(0.8),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset: Offset(0, 2)
                      ),
                    ]

                ),

                width: MediaQuery.of(context).size.width * 0.55,
                height: MediaQuery.of(context).size.height*0.1,
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.symmetric(horizontal: 19,vertical: 10),
                child: FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Text("English",style: TextStyle(fontFamily: "Poppins",color: Colors.white),),
                            SizedBox(height:10,),
                            Text(english,style: TextStyle(color: Colors.white),)
                          ],
                        ),
                      ),
                      SizedBox(width: 20,),
                      Column(
                        children: [
                          Text("Spanish",style: TextStyle(fontFamily: "Poppins",color: Colors.white),),
                          SizedBox(height: 10,),
                          Text(english,style: TextStyle(color: Colors.white),)
                        ],
                      )
                    ],
                  ),
                ),
              ):
              Container(
                decoration: BoxDecoration(
                    color:name!="Sant Adria" ?Colors.blue[500]:Colors.orange,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(color:name =="Sant Adria"? Colors.black.withOpacity(0.3): Colors.blueAccent.withOpacity(0.8),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset: Offset(0, 2)
                      ),
                    ]

                ),

                width: MediaQuery.of(context).size.width * 0.55,
                height: MediaQuery.of(context).size.height*0.05,
                padding: EdgeInsets.symmetric(horizontal: 19,vertical: 10),
                child: FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          english !="none"?
                          Text(english,style: TextStyle(color:Colors.white)):
                          Text(spanish,style: TextStyle(color:Colors.transparent) )],
                      ),
                      SizedBox(width: 20,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          spanish !="none"?
                          Text(spanish,style: TextStyle(color:Colors.white)):
                          Text(english,style: TextStyle(color:Colors.transparent)

                          )],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );

}

}
