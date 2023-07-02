import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../Models/question.dart';

class addQuestionInBank extends StatefulWidget {
  const addQuestionInBank({Key? key}) : super(key: key);

  @override
  State<addQuestionInBank> createState() => _addQuestionInBankState();
}

class _addQuestionInBankState extends State<addQuestionInBank> {

  final TextEditingController _questioController = TextEditingController();
  final TextEditingController _opt1Controller = TextEditingController();
  final TextEditingController _opt2Controller = TextEditingController();
  final TextEditingController _opt3Controller = TextEditingController();

  final ImagePicker imagePicker = ImagePicker();

  String _imageUrl = "";
  int answer = 0;
  bool isImagePicked = false;
  late XFile imageFile;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Material(
                    color: Colors.grey[100],
                    child: Icon(
                      Icons.close_rounded,
                      size: 30,
                    )),
                Text(
                  "      Add New Question",
                  style:
                  TextStyle(fontFamily: "Poppins", fontSize: 17),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
                onTap: () async{

                  await selectImage();
                  print("kjhj");

                },
              child:!isImagePicked? Icon(Icons.add_a_photo_outlined,size: 70,color: Colors.blue,)
                    :Image.file(File(imageFile.path),fit: BoxFit.fitWidth,height:  MediaQuery.of(context).size.height * 0.2,width:  MediaQuery.of(context).size.width,)
            ),
            SizedBox(
              height: 40,
            ),
            TextField(
              controller: _questioController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)),
                labelText: "Statement",
              ),
              maxLines: 2,
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
                visualDensity:
                const VisualDensity(horizontal: 0, vertical: -4),
                title: TextField(
                  controller: _opt1Controller,
                  decoration: InputDecoration(
                    labelText: "Option A",
                  ),
                ),
                trailing: answer == 1
                    ? CircleAvatar(
                  foregroundImage:
                  AssetImage("assets/tick.jpg"),
                  radius: 15,
                )
                    : InkWell(
                  onTap: () {
                  ;
                  },
                  child: CircleAvatar(
                    foregroundImage:
                    AssetImage("assets/cross.jpg"),
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
                visualDensity:
                const VisualDensity(horizontal: 0, vertical: -4),
                title: TextField(
                  controller: _opt2Controller,
                  decoration: InputDecoration(
                    labelText: "Option 2",
                  ),
                ),
                trailing: answer == 2
                    ? CircleAvatar(
                  foregroundImage:
                  AssetImage("assets/tick.jpg"),
                  radius: 15,
                )
                    : InkWell(
                  onTap: () {

                  },
                  child: CircleAvatar(
                    foregroundImage:
                    AssetImage("assets/cross.jpg"),
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
                visualDensity:
                const VisualDensity(horizontal: 0, vertical: -4),
                title: TextField(
                  controller: _opt3Controller,
                  decoration: InputDecoration(
                    labelText: "Option C",
                  ),
                ),
                trailing: answer == 3
                    ? CircleAvatar(
                  foregroundImage:
                  AssetImage("assets/tick.jpg"),
                  radius: 15,
                )
                    : InkWell(
                  onTap: () {

                  },
                  child: CircleAvatar(
                    foregroundImage:
                    AssetImage("assets/cross.jpg"),
                    radius: 15,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 44,
            ),

            InkWell(
              onTap: () async {

                  QuestionModel q = QuestionModel(
                      image: "",
                      statement: _questioController.text,
                      optionA: _opt1Controller.text,
                      option2: _opt2Controller.text,
                      optionC: _opt3Controller.text,
                      answer: "");

                Navigator.pop(context,q);
                // print(answer);
                // if(answer == 0){
                //   ScaffoldMessenger.of(context)
                //       .showSnackBar(SnackBar(content: Text("Select Correct Answer")));
                //
                // }
                // else{
                //   List a = [
                //     _opt1Controller.text + "",
                //     _opt2Controller.text + "",
                //     _opt3Controller.text + "",
                //   ];
                //
                //   QuestionModel q = QuestionModel(
                //       image: "",
                //       statement: _questioController.text,
                //       optionA: _opt1Controller.text,
                //       option2: _opt2Controller.text,
                //       optionC: _opt3Controller.text,
                //       answer: a[answer - 1]);
                //
                //   // questionsList.add(q);
                //   // Navigator.pop(context);
                //   // update();
                //   ScaffoldMessenger.of(context)
                //       .showSnackBar(SnackBar(content: Text("saved")));
                // }
                //
                },
              child: Material(
                borderRadius:
                const BorderRadius.all(Radius.circular(8)),
                elevation: 6,
                color: Colors.blue,
                child: Container(
                  height: 40,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: const Text(
                    'Save Question',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontFamily: "Poppins"),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future<void> selectImage() async {
    final XFile? selectedImages = (await imagePicker.pickImage(
        imageQuality: 10, source: ImageSource.gallery));
    // imageFileList.add(selectedImages!);
    imageFile = selectedImages!;

    isImagePicked = true;
    setState(() {

    });
  }

}
