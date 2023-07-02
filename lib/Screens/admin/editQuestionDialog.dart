import 'dart:io';

import 'package:bmeducators/Screens/admin/questionBank.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../../Models/question.dart';


class editQuestion extends StatefulWidget {
  final QuestionModel questionModel;
   editQuestion({Key? key,required this.questionModel}) : super(key: key);

  @override
  State<editQuestion> createState() => _editQuestionState();
}

class _editQuestionState extends State<editQuestion> {
  final TextEditingController _questioController = TextEditingController();
  final TextEditingController _opt1Controller = TextEditingController();
  final TextEditingController _opt2Controller = TextEditingController();
  final TextEditingController _opt3Controller = TextEditingController();
  final TextEditingController _opt4Controller = TextEditingController();

  final ImagePicker imagePicker = ImagePicker();
  var imageFile;
  String _imageUrl = "";
  String answer = "";
  bool isImagePicked = false;
  late QuestionModel question;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    question = widget.questionModel;
    _questioController.text = question.statement;
    _opt1Controller.text = question.optionA;
    _opt2Controller.text = question.option2;
    _opt3Controller.text = question.optionC;
    _imageUrl = question.image;
    answer = question.answer;



  }


    @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: isLoading?
        Center(
          child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height*0.25,),
            CircularProgressIndicator(),
            SizedBox(height: 20,),
            Text("Updating....",style: TextStyle(fontFamily: "Poppins",color: Colors.orange,fontSize: 18),)
          ],
        ),)
            : Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.close,color: Colors.transparent,),
                  const Text(
                    "Edit Question",
                    style: TextStyle(fontFamily: "Poppins", fontSize: 20),
                  ),
                  InkWell(
                      onTap: (){
                        Navigator.of(context,rootNavigator: true).pop();

                      },
                      child: Icon(Icons.close))
                ],
              ),
              SizedBox(height: 20,),
              InkWell(
                  onTap: (){
                    selectImage();
                  },
                  child:!isImagePicked?
                  _imageUrl !=""?Image.network(_imageUrl, height:  MediaQuery.of(context).size.height * 0.15,width:  MediaQuery.of(context).size.width,):
                  Icon(Icons.add_a_photo)
                      :Image.file(File(imageFile.path),fit: BoxFit.fitWidth,
                    height:  MediaQuery.of(context).size.height * 0.15,width:  MediaQuery.of(context).size.width,)
              ),
              SizedBox(height: 20,),
              TextField(
                maxLines: 3,
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
                height: 15,
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
                  answer == _opt1Controller.text?
                  CircleAvatar(
                    foregroundImage: AssetImage("assets/tick.jpg"),
                    radius: 15,
                  )
                      :InkWell(
                    onTap: (){
                      setState(() {
                        answer  = _opt1Controller.text;
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
                height: 15,
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
                  trailing: answer == _opt2Controller.text?
                  CircleAvatar(
                    foregroundImage: AssetImage("assets/tick.jpg"),
                    radius: 15,
                  )
                      :InkWell(
                    onTap: (){
                      setState(() {
                        answer  = _opt2Controller.text;
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
                height: 15,
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
                  trailing: answer == _opt3Controller.text?
                  CircleAvatar(
                    foregroundImage: AssetImage("assets/tick.jpg"),
                    radius: 15,
                  )
                      :InkWell(
                    onTap: (){
                      setState(() {
                        answer  = _opt3Controller.text;
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




              InkWell(
                onTap: () async {

                  if(isImagePicked){
                    await uploadImage();
                  }

                  QuestionModel q = QuestionModel(

                      statement: _questioController.text,
                      optionA: _opt1Controller.text,
                      option2: _opt2Controller.text,
                      optionC:_opt3Controller.text,
                      answer: answer, image: _imageUrl
                  );
                  FirebaseFirestore.instance.collection("questions")
                      .doc(widget.questionModel.statement).delete();
                  FirebaseFirestore.instance.collection("questions").doc(q.statement).
                  set(q.toMap());

                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => questionBank()));
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
      )
    );
  }

  void selectImage() async {
    final XFile? selectedImages = (await imagePicker.pickImage(
        imageQuality: 10, source: ImageSource.gallery));
    // imageFileList.add(selectedImages!);
    imageFile = selectedImages!;

    isImagePicked = true;
    setState(() {

    });
  }

  Future uploadImage() async {
    isLoading = true;
    setState(() {

    });

    final Reference storageReference = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('admin/quizes/questions/${imageFile.path}');

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

    print("kk");
    downloadURL = await (await uploadTask).ref.getDownloadURL();
    print("k");

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
