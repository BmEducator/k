import 'dart:io';

import 'package:bmeducators/Screens/admin/usersScreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../Models/studentModel.dart';

class editStudentScreen extends StatefulWidget {
  studentModel student;
  String accessLimit;
   editStudentScreen({Key? key,required this.student,required this.accessLimit}) : super(key: key);

  @override
  State<editStudentScreen> createState() => _editStudentScreenState();
}

class _editStudentScreenState extends State<editStudentScreen> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _dniController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _languageController = TextEditingController();

  final ImagePicker imagePicker = ImagePicker();
  late XFile imageFile;
  bool isImagePicked = false;
  String _imageUrl = "https://i.pinimg.com/736x/da/4f/ad/da4fad3f0c9549a86a70dc90d9208e8d.jpg";
  String selectedLanguage = "English";
  late String dateOfbirth ;
  bool isSaving = false;
  List<String> languages = [
    'English',
    'Spanish',
    'Dutch',
    'Chinese',
    'French',
    'Russian'
  ];
  List<String> licenseTypes = [
    'License B',
    'Permit A',
    'Permit C',
    'Permit D',
    'Permit A1-A2',
    'Car Merchandise',
  ];
  late DateTime d;
  String licenseType = "Permit A" ;

  @override
  void initState() {
    // TODO: implement initState


    licenseType = widget.student.licenseType;
    licenseTypes.removeWhere((element) => element == widget.student.licenseType);
    licenseTypes.insert(0, widget.student.licenseType);
    super.initState();
    print(widget.accessLimit);
    getCredentials();

    _nameController.text = widget.student.name;
    _imageUrl = widget.student.profileImage;
    _emailController.text = widget.student.email;
    _languageController.text = widget.student.language;
    _educationController.text = widget.student.education;
    _addressController.text = widget.student.address;
    _dniController.text = widget.student.dni;
    _contactController.text = widget.student.contact;
    d = DateTime.fromMillisecondsSinceEpoch(
        (int.parse(widget.student.dateofBirth)!));

    dateOfbirth = widget.student.dateofBirth;
  }

  Future<void> getCredentials() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance.collection(
        "admin").doc("data").collection("students").doc("login").collection("logins").doc(widget.student.email ).get();
          _passwordController.text = snap['password'];
          print(snap['password']);
          setState(() {

          });
  }


  @override
  Widget build(BuildContext context) {
    return !isSaving ? Scaffold(
        backgroundColor: Colors.grey[100],
        body: SingleChildScrollView(
            child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(onPressed: () {
                          Navigator.pop(context);
                        },
                            icon: const Icon(
                              Icons.arrow_back_ios, color: Colors.blue,)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        InkWell(
                          onTap: () {
                            selectImages();
                          },
                          child: Center(
                            child: Material(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(75),
                              elevation: 20,
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: isImagePicked ?
                                CircleAvatar(
                                  backgroundImage: FileImage(
                                      File(imageFile.path)),
                                  radius: 50,
                                )
                                    : CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      widget.student.profileImage),
                                  radius: 50,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            labelText: "Name",
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),

                        TextField(
                          controller: _dniController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            labelText: "DNI",
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),

                        TextField(
                          controller: _educationController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            labelText: "Education",
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        TextField(
                          controller: _addressController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            labelText: "Address",
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        TextField(
                          controller: _contactController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            labelText: "Contact no",
                          ),
                          keyboardType: TextInputType.number,
                        ),

                        const SizedBox(
                          height: 24,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Language        ",style: TextStyle(fontFamily: "Poppins"),),

                            DropdownButton(
                              value: selectedLanguage,
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 30,
                              onChanged: (String? v){
                                setState(() {
                                  selectedLanguage = v!;
                                });
                              },
                              items: languages.map<DropdownMenuItem<String>>((String v){
                                return DropdownMenuItem<String>(
                                  value: v,
                                  child: Text(v),

                                );
                              }).toList(),
                            ),

                          ],
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("License Type ",style: TextStyle(fontFamily: "Poppins",color: Colors.blue),),

                            DropdownButton(
                              value: licenseTypes[0],
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 30,
                              onChanged: (String? v){
                                licenseTypes.removeWhere((i) => i == v);
                                licenseTypes.insert(0, v!);
                                setState(() {
                                  licenseType = v!;
                                });
                              },
                              items: licenseTypes.map<DropdownMenuItem<String>>((String v){
                                return DropdownMenuItem<String>(
                                  value: v,
                                  child: Text(v),

                                );
                              }).toList(),
                            ),

                          ],
                        ),

                        SizedBox(
                          height: 20,
                        ),


                        const Text(
                          "Login Credentials ",
                          style: TextStyle(
                              fontFamily: "Poppins", fontSize: 25),
                        ),

                        const Text(
                          "for Student to log-in ",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 15,
                              color: Colors.blue),
                        ),
                        const SizedBox(
                          height: 24,
                        ),

                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            labelText: "Email",
                          ),
                        ),

                        const SizedBox(
                          height: 24,
                        ),

                        TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            labelText: "Password",
                          ),
                        ),

                        const SizedBox(
                          height: 24,
                        ),

                        const Text(
                          "Date of Birth ",
                          style: TextStyle(
                              fontFamily: "Poppins", fontSize: 20),
                        ),


                        const SizedBox(
                          height: 24,
                        ),
                        SizedBox(
                            height: 100,
                            width: MediaQuery.of(context).size.width * 0.7,
                            child:CupertinoDatePicker(
                              mode: CupertinoDatePickerMode.date,
                              initialDateTime:d,
                              onDateTimeChanged: (DateTime newDate){
                                dateOfbirth = newDate.millisecondsSinceEpoch.toString();

                              },
                            )
                        ),
                      ],
                    ),
                  ),
                ]
            )

        ),
        bottomNavigationBar: BottomAppBar(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 10, 10),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Cancel",
                            style: const TextStyle(
                                color: Colors.blue, fontFamily: 'Poppins'),
                          )),
                    )),
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 20, 10),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[900]
                          ),
                          onPressed: () async {
                            isSaving = true;
                            setState(() {

                            });
                           if(isImagePicked){
                            await uploadImage();
                           }

                            FirebaseFirestore.instance.collection("admin").doc(
                                "data").collection("students")
                                .doc("login").collection("logins").doc(
                                _emailController.text).
                            update({
                              "name": _nameController.text,
                              "email": _emailController.text,
                              "password": _passwordController.text,
                              'profileImage':_imageUrl});

                            DateFormat dateformat = DateFormat("yyyy-MM-dd");
                            studentModel newStudent = studentModel(
                                id: _emailController.text,
                                name: _nameController.text,
                                contact: _contactController.text,
                                profileImage: _imageUrl,
                                dateofBirth:dateOfbirth,
                                email: _emailController.text,
                                dni: _dniController.text,
                                address: _addressController.text,
                                education: _educationController.text,
                                language: selectedLanguage,
                                accessDate :widget.accessLimit,
                                translation: widget.student.translation,
                                token: widget.student.token,
                                mode: widget.student.mode,
                                licenseType: licenseTypes[0], revise: widget.student.revise  );

                            FirebaseFirestore.instance.collection("admin").doc(
                                "data").collection("students").doc(
                                "allStudents").collection("allStudents")
                                .doc(_emailController.text).
                            set(newStudent.toMap());


                            Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        usersSreen()));
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("saved")));
                          },
                          child: Text(
                            "Save",
                            style: const TextStyle(
                                color: Colors.white, fontFamily: 'Poppins'),
                          )),
                    )),
              ],
            ),
          ),
        )
    ):
    Scaffold(
        body: Container
          (
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,

          child: Center(
              child: LoadingAnimationWidget.flickr(
                  leftDotColor: Colors.red,
                  rightDotColor: Colors.blue, size: 50))
        ));

  }

  void selectImages() async {
    final XFile? selectedImages = (await imagePicker.pickImage(
        imageQuality: 10, source: ImageSource.gallery));
    // imageFileList.add(selectedImages!);
    imageFile = selectedImages!;
    isImagePicked = true;
    setState(() {

    });
  }


  Future uploadImage() async {
    final Reference storageReference = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('admin/users/${_nameController.text}/(img.path)');
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
}