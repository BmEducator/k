import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../../Models/question.dart';


class addQuestio extends StatefulWidget {
  bool is4Option;
   addQuestio({Key? key,required this.is4Option}) : super(key: key);

  @override
  State<addQuestio> createState() => _addQuestioState();
}

class _addQuestioState extends State<addQuestio> {
  final TextEditingController _questioController = TextEditingController();
  final TextEditingController _opt1Controller = TextEditingController();
  final TextEditingController _opt2Controller = TextEditingController();
  final TextEditingController _opt3Controller = TextEditingController();
  final TextEditingController _opt4Controller = TextEditingController();

  final ImagePicker imagePicker = ImagePicker();
  late XFile imageFile;
  String _imageUrl = "";
  int answer = 0;
  bool isImagePicked = false;
  bool isError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  Material(
                      color: Colors.grey[100],
                      child: Icon(Icons.close_rounded,size: 30,)

                  ),
                  Text("      Add New Question",style: TextStyle(fontFamily: "Poppins",fontSize: 17),),


                ],
              ),
              SizedBox(height: 20,),

              InkWell(
                  onTap: (){
                    selectImage();
                  },
                  child:!isImagePicked? Icon(Icons.add_a_photo_outlined,size: 70,color: Colors.blue,)
                      :Image.file(File(imageFile.path),fit: BoxFit.fitWidth,height:  MediaQuery.of(context).size.height * 0.2,width:  MediaQuery.of(context).size.width,)
              ),
              SizedBox(height: 40,),
              TextField(
                controller: _questioController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  labelText: "Statement",
                ),
              ),
              const SizedBox(
                height: 24,
              ),


              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.orange[100]),
                child: ListTile(
                  dense: true,
                  contentPadding:
                  const EdgeInsets.only(left: 15, right: 10),
                  horizontalTitleGap: 0,
                  visualDensity: const VisualDensity(
                      horizontal: 0, vertical: -4),
                  title:  TextField(
                    controller: _opt1Controller,
                    decoration: InputDecoration(
                      labelText: "Option A",
                    ),
                  ),
                  trailing:
                  answer == 1?
                  CircleAvatar(
                     foregroundImage: AssetImage("assets/tick.jpg"),
                    radius: 15,
                  )
                  :InkWell(
                    onTap: (){
                      setState(() {
                        answer  = 1;
                        isError= false;

                      });
                    },
                    child: CircleAvatar(
                       foregroundImage: AssetImage("assets/cross.jpg"),
                      radius: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),

              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue[100]),
                child: ListTile(
                  dense: true,
                  contentPadding:
                  const EdgeInsets.only(left: 15, right: 10),
                  horizontalTitleGap: 0,
                  visualDensity: const VisualDensity(
                      horizontal: 0, vertical: -4),
                  title:  TextField(
                    controller: _opt2Controller,
                    decoration: InputDecoration(
                      labelText: "Option 2",
                    ),
                  ),
                  trailing: answer == 2?
                  CircleAvatar(
                    foregroundImage: AssetImage("assets/tick.jpg"),
                    radius: 15,
                  )
                      :InkWell(
                    onTap: (){
                      setState(() {
                        answer  = 2;
                        isError= false;

                      });
                    },
                        child: CircleAvatar(
                    foregroundImage: AssetImage("assets/cross.jpg"),
                    radius: 15,
                  ),
                      ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),

              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.red[100]),
                child: ListTile(
                  dense: true,
                  contentPadding:
                  const EdgeInsets.only(left: 15, right: 10),
                  horizontalTitleGap: 0,
                  visualDensity: const VisualDensity(
                      horizontal: 0, vertical: -4),
                  title:  TextField(
                    controller: _opt3Controller,
                    decoration: InputDecoration(
                      labelText: "Option C",
                    ),
                  ),
                  trailing: answer == 3?
                  CircleAvatar(
                    foregroundImage: AssetImage("assets/tick.jpg"),
                    radius: 15,
                  )
                      :InkWell(
                    onTap: (){
                      setState(() {
                        answer  = 3;
                        isError= false;
                      });
                    },
                        child: CircleAvatar(
                    foregroundImage: AssetImage("assets/cross.jpg"),
                    radius: 15,
                  ),
                      ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),

              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.green[100]),
                child: ListTile(
                  dense: true,
                  contentPadding:
                  const EdgeInsets.only(left: 15, right: 10),
                  horizontalTitleGap: 0,
                  visualDensity: const VisualDensity(
                      horizontal: 0, vertical: -4),
                  title:  TextField(
                    controller: _opt4Controller,
                    decoration: InputDecoration(
                      labelText: "Option D",
                    ),
                  ),
                  trailing: answer == 4?
                  CircleAvatar(
                    foregroundImage: AssetImage("assets/tick.jpg"),
                    radius: 15,
                  )
                      :InkWell(
                    onTap: (){
                      setState(() {
                        answer  = 4;
                      });
                    },
                        child: CircleAvatar(
                    foregroundImage: AssetImage("assets/cross.jpg"),
                    radius: 15,
                  ),
                      ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),

              Visibility(
                visible: isError,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("*Select Correct Answer",style: TextStyle(fontFamily: "PoppinRegular",fontSize: 16,color: Colors.red),),
                  ],
                ),
              ),

              const SizedBox(
                height: 15,
              ),


              InkWell(
                onTap: () async {
              if(answer!=0){
    List a = [_opt1Controller.text+"",_opt2Controller.text+"",_opt3Controller.text+"",];
    if(isImagePicked){
    await uploadImage();
    }

    QuestionModel q = QuestionModel(

    statement: _questioController.text,
    optionA: _opt1Controller.text,
    option2: _opt2Controller.text,
    optionC:_opt3Controller.text,
    answer: a[answer-1], image: _imageUrl, optionD: _opt4Controller.text
    );

    FirebaseFirestore.instance.collection("questions").doc(q.statement).
    set(q.toMap());

    _questioController.clear();
    _opt1Controller.clear();
    _opt2Controller.clear();
    _opt3Controller.clear();

    answer = 0;


    setState(() {

    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Question Added")));

              }
              else{
                isError = true;
                setState(() {

                });
              }


                },
                child: Material(
                  borderRadius: const BorderRadius.all(
                      Radius.circular(8)),
                  elevation: 6,
                  color: Colors.blue,
                  child: Container(
                    height: 40,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: const Text(
                      'Save Question',
                      style: TextStyle(color: Colors.white,
                          fontSize: 17,fontFamily: "Poppins"),
                    )
                    ,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void selectImage() async {
    final XFile? selectedImages = (await imagePicker.pickImage(
        imageQuality: 80, source: ImageSource.gallery));
    // imageFileList.add(selectedImages!);
    imageFile = selectedImages!;

    isImagePicked = true;
    setState(() {

    });
  }

  Future uploadImage() async {

    final Reference storageReference = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('profileImage/(${imageFile.name}.path)');

    String downloadURL;
    final uploadTask = storageReference.putFile(File(imageFile.path));
    uploadTask.snapshotEvents.listen((event) {
      switch (event.state) {
        case TaskState.running:
          final p = 100.0 * (event.bytesTransferred / event.totalBytes);
          print("prog $p");
          break;

        case TaskState.paused:
          print("paused");
          break;

        case TaskState.success:
          print("succ");
          break;
        case TaskState.canceled:
          print("cancek");
          break;
        case TaskState.error:
          print("errr");
          break;
      }
    });

    downloadURL = await (await uploadTask).ref.getDownloadURL();
    _imageUrl = downloadURL;
  }

  //
  // Future uploadToStorage() async {
  //   try {
  //     final DateTime now = DateTime.now();
  //     final int millSeconds = now.millisecondsSinceEpoch;
  //     final String month = now.month.toString();
  //     final String date = now.day.toString();
  //     final String storageId = (millSeconds.toString() + "kk");
  //     final String today = ('$month-$date');
  //
  //     final XFile =  await ImagePicker.pickVideo(source: ImageSource.gallery);
  //
  //     StorageReference ref = FirebaseStorage.instance.ref().child("video").child(today).child(storageId);
  //     StorageUploadTask uploadTask = ref.putFile(file, StorageMetadata(contentType: 'video/mp4')); <- this content type does the trick
  //
  //   Uri downloadUrl = (await uploadTask.future).downloadUrl;
  //
  //   final String url = downloadUrl.toString();
  //
  //   print(url);
  //
  //   } catch (error) {
  //   print(error);
  //   }
  //
  // }
}
