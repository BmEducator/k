import 'package:bmeducators/Screens/admin/myTiktoks.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class addTiktokScreen extends StatefulWidget {
  List<String> urls;
   addTiktokScreen({Key? key,required this.urls}) : super(key: key);

  @override
  State<addTiktokScreen> createState() => _addTiktokScreenState();
}

class _addTiktokScreenState extends State<addTiktokScreen> {
TextEditingController urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
          child:
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.blue,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text("Add TikTok Video",style:TextStyle(fontFamily: "Poppins",fontSize: 24)),
            SizedBox(
              height: 100,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding :EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.red[100]),
              child: TextField(
                controller: urlController,
                decoration: InputDecoration(
                  labelText: "   Paste Tiktok Url",
                ),
              )),

            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Material(
                borderRadius: const BorderRadius.all(
                    Radius.circular(8)),
                elevation: 6,
                color: Colors.blue,
                child: InkWell(
                  onTap: () async{
                   //  List<String> urlslist = [
                   //
                   //  ];
                   //  urlslist.addAll(widget.urls);
                   //  urlslist.add(urlController.text);
                   // await FirebaseFirestore.instance.
                   // collection("admin").doc("data").
                   // collection("tiktoks").doc("tiktoks")
                   //      .set({'tiktoksUrls':urlslist});

                    var t = DateTime.now().millisecondsSinceEpoch;

                    List<String> li = widget.urls;
                    li.add(urlController.text);
                    await FirebaseDatabase.instance.ref().child("admin").child("mytiktoks").update({
                      "urls":li
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("TikTok Uploaded")));
                   Navigator.pushReplacement(
                       context, MaterialPageRoute(builder: (context) => myTiktoks()));


                  },
                  child: Container(
                    height: 40,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: const Text(
                      'Save',
                      style: TextStyle(color: Colors.white,
                          fontSize: 17,fontFamily: "Poppins"),
                    )
                    ,
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }


}
