import 'package:bmeducators/students/main_menuScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';

import '../Models/notificationModel.dart';

class notificationsScreen extends StatefulWidget {
  List<notificationModel> notificaitonslist;
  String name;

   notificationsScreen({Key? key,required this.notificaitonslist,required this.name}) : super(key: key);

  @override
  State<notificationsScreen> createState() => _notificationsScreenState();
}



class _notificationsScreenState extends State<notificationsScreen> {

  @override
  void initState() {
   widget.notificaitonslist.forEach((element) {
     print(element.timestamp);
     print(element.message);
     print(element.status);
   });
    print(widget.notificaitonslist.length);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                InkWell(
                  onTap: (){
                 Navigator.of(context).pop();
                  },
                  child: Icon(Icons.arrow_back_ios),
                ),
              SizedBox(height: 30,),
              Row(
                children: [
                  Text("Notifications  " , style: TextStyle(fontFamily: "Poppins",fontSize: 25),),
                  Icon(Icons.notifications_active_outlined,color: Colors.orange,)
                ],
              ),
              Divider(thickness: 5,color: Colors.grey[300],),
              SizedBox(height: 30,),

      Visibility(
        visible: widget.notificaitonslist.length > 0,
        child: AnimationLimiter(
          child: ListView.builder(
            reverse: true,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.all(8.0),
            itemCount: widget.notificaitonslist.length,
            itemBuilder: (BuildContext context, int index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 475),
                child: SlideAnimation(
                  verticalOffset: 44.0,
                  child: FadeInAnimation(
                    child: item(widget.notificaitonslist[index])
                  ),
                ),
              );
            },
          ),
          ),
      ),

            Visibility(
              visible: widget.notificaitonslist.length == 0,

              child: Container(
                height: MediaQuery.of(context).size.height*0.4,
                child: Center(
                  child: Text("No Notification"),
                ),
              ),
            )

            ],


          ),
        ),
      ),
      ),
    );
  }

  item(notificationModel model){
    var s = DateTime.fromMillisecondsSinceEpoch(model.timestamp);
    var month = DateFormat.MMMM().format(s);
    var day = DateFormat.d().format(s);
    var todat = DateFormat.d().format(DateTime.now());

    if(day == todat){
      month = "Today";
    }


    return InkWell(
        onTap: () async {
          showNotification(context, model);

        },
        child:Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                        visible: day != todat,
                        child: Text(day,style: TextStyle(fontFamily: "Poppins",color: Colors.blue,fontSize: 16),)),
                    Text(month,style: TextStyle(fontFamily: "Poppins",color: Colors.blue,fontSize: 13),),
                  ],
                ),
                radius: 30,
                backgroundColor: Colors.greenAccent.withOpacity(0.3),
              ),
              title: Text(model.message,style: TextStyle(fontFamily: "PoppinRegular"),),
            ),
            Divider(thickness: 2,),
            SizedBox(height: 10,)
          ],
        )

    );
  }


  Future<void> showNotification( context,notificationModel model ) {
    return showDialog(
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
                                  Text("Dear ${widget.name}!",style: TextStyle(fontFamily: "Poppins",fontSize: 18,color: Colors.blue),),
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
