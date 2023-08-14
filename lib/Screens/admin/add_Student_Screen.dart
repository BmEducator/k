import 'dart:io';

import 'package:bmeducators/Models/studentModel.dart';
import 'package:bmeducators/Screens/admin/usersScreen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class addStudentScreen extends StatefulWidget {
  const addStudentScreen({Key? key}) : super(key: key);

  @override
  State<addStudentScreen> createState() => _addStudentScreenState();
}

class _addStudentScreenState extends State<addStudentScreen> {

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
  bool isDatePicked = false;
  bool isDateError = false;
  bool isTaxiSelected = false;
  bool isLoading = false;
  List<String> courses = [];
  String _imageUrl = "https://i.pinimg.com/736x/da/4f/ad/da4fad3f0c9549a86a70dc90d9208e8d.jpg";
  String selectedLanguage = "English";
  late String dateOfbirth ;
   String licenseType = "Permiso AM" ;
   String taxiType = "Bloque 1" ;
  List<String> languages = [
    'English',
    'Spanish',
    'Dutch',
    'Chinese',
    'French',
    'Russian'
  ];

  List<String> licenseTypes = [
   'Permiso AM',
   'Permiso A1-A2',
   'Permiso B',
   'Permiso C',
   'Permiso D',
   'Permiso C+E',
    'CAP',
    'Curso de Taxi Barcelona',
  ];
  List<String> taxiSubtypes = [
    'Bloque 1',
    'Bloque 2',
    'Cap',
    'Other',

  ];

  late SharedPreferences pref;
  Future init() async{
    pref = await SharedPreferences.getInstance();

  }

  @override
  void initState() {
    // TODO: implement initState
    getfamilies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return !isLoading?
    Scaffold(
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
                        horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        const Text(
                          "Add New Student ",
                          style: TextStyle(
                              fontFamily: "Poppins", fontSize: 25),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
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
                                  backgroundImage: AssetImage(
                                      "assets/profile.png"),
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
                          height: 14,
                        ),
                        Visibility(
                            visible: courses.length>0,
                            child: Text("Selected Courses",style: TextStyle(fontSize: 15,fontFamily: "Poppins"),)),
                        Visibility(
                          visible: courses.length>0,
                          child:ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Chip(
                                backgroundColor: Colors.lightBlue[100],
                                label: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(courses[index]+"   ",style: TextStyle(fontFamily: "PoppinRegular"),),
                                ],
                              ),
                                deleteIcon: Icon(Icons.close),
                                deleteIconColor: Colors.red,
                                onDeleted: (){
                                  courses.removeWhere((element) => element == courses[index]);
                                  setState(() {

                                  });
                                },
                              );
                            },
                            itemCount: courses.length,
                          ),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("License Type    ",style: TextStyle(fontFamily: "Poppins"),),

                            Container(
                              child: DropdownButton(
                                value: licenseType,
                                icon: Icon(Icons.arrow_drop_down),
                                iconSize: 30,
                                onChanged: (String? v){
                                  setState(() {
                                    licenseType = v!;
                                    if(v != "Curso de Taxi Barcelona" && courses.contains("Curso de Taxi Barcelona")) {
                                      isTaxiSelected = false;

                                    }
                                    if(v == "Curso de Taxi Barcelona"){
                                      isTaxiSelected = true;
                                      setState(() {

                                      });
                                    }
                                    else{
                                    if(!courses.contains(v)){
                                      courses.add(v);
                                    }
                                    }

                                  });
                                },
                                items: licenseTypes.map<DropdownMenuItem<String>>((String v){
                                  return DropdownMenuItem<String>(
                                    value: v,
                                    child: Container(
                                      alignment: Alignment.topLeft,
                                        width: MediaQuery.of(context).size.width *0.4,
                                        height: 20,
                                        child: FittedBox(child: Text(v,style: TextStyle(fontSize: 14,fontFamily: "Poppins",color: Colors.blue),))),

                                  );
                                }).toList(),
                              ),
                            ),

                          ],
                        ),
                        Visibility(
                          visible: isTaxiSelected,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Taxi SubType    ",style: TextStyle(fontFamily: "Poppins"),),

                              Container(
                                child: DropdownButton(
                                  value: taxiType,
                                  icon: Icon(Icons.arrow_drop_down),
                                  iconSize: 30,
                                  onChanged: (String? v){
                                    setState(() {
                                      taxiType = v!;
                                      if(!courses.contains(v)){
                                        courses.add(v);

                                      }

                                    });
                                  },
                                  items: taxiSubtypes.map<DropdownMenuItem<String>>((String v){
                                    return DropdownMenuItem<String>(
                                      value: v,
                                      child: Container(
                                        alignment: Alignment.topLeft,
                                          width: MediaQuery.of(context).size.width *0.4,
                                          height: 20,
                                          child: FittedBox(child: Text(v,style: TextStyle(fontSize: 14,fontFamily: "Poppins",color: Colors.blue),))),

                                    );
                                  }).toList(),
                                ),
                              ),

                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 24,
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
                        // const SizedBox(
                        //   height: 24,
                        // ),
                        //
                        // TextField(
                        //   controller: _emailController,
                        //   decoration: InputDecoration(
                        //     filled: true,
                        //     fillColor: Colors.white,
                        //     border: OutlineInputBorder(
                        //         borderRadius: BorderRadius.circular(20)),
                        //     labelText: "Email",
                        //   ),
                        // ),

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
                          height: 14,
                        ),

                        Visibility(
                            visible: isDateError,
                            child: Text("* Select Date Of Birth",style: TextStyle(fontFamily: "Poppins",fontSize: 18,color: Colors.red),)),
                        const SizedBox(
                          height: 14,
                        ),


                        SizedBox(
                            height: 100,
                            width: MediaQuery.of(context).size.width * 0.7,
                            child:CupertinoDatePicker(
                              mode: CupertinoDatePickerMode.date,
                              initialDateTime: DateTime(1990,1,1),
                              onDateTimeChanged: (DateTime newDate){
                                dateOfbirth = newDate.millisecondsSinceEpoch.toString();
                                setState(() {
                                  isDatePicked = true;
                                  isDateError = false;
                                });
                              },
                            )
                        ),
                        SizedBox(height: 104,)
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
                            setState(() {

                            });
                            if(!isDatePicked){
                                isDateError = true;
                                setState(() {

                                });

                            }
                            else{
                              isLoading = true;

                              if(isImagePicked) {
                                await uploadImage();
                              }
                              DateTime now = DateTime.now().add(Duration(days: 30));



                              FirebaseFirestore.instance.collection("admin").doc(
                                  "data").collection("students")
                                  .doc("login").collection("logins").doc(
                                  _dniController.text+"@gmail.com").
                              set({
                                "name": _nameController.text,
                                "email": _dniController.text+"@gmail.com",
                                "password": _passwordController.text,
                                'profileImage':_imageUrl,
                                'loginAt':"",
                                'dni':_dniController.text,
                                'licenseType':licenseType,
                                'courses':courses
                              });

                              DateFormat dateformat = DateFormat("yyyy-MM-dd");
                              dateformat.format(now);
                              List<String> li = [];
                              li.add(DateTime.now().millisecondsSinceEpoch.toString());
                              print(now);
                              studentModel newStudent = studentModel(
                                  id: _dniController.text,
                                  name: _nameController.text,
                                  contact: _contactController.text,
                                  profileImage: _imageUrl,
                                  dateofBirth: dateOfbirth,
                                  email: _dniController.text+"@gmail.com",
                                  dni: _dniController.text,
                                  address: _addressController.text,
                                  education: _educationController.text,
                                  language: selectedLanguage,
                                  accessDate: now.millisecondsSinceEpoch.toString(),
                                  translation: 'false',
                                  token: '',
                                  mode: 'Both',
                                  licenseType:licenseType,
                                  revise: 'true',
                                  courses: courses,
                                  noOfActivation: 1, noOfActivations: li );

                             await FirebaseFirestore.instance.collection("admin").doc(
                                  "data").collection("students").doc(
                                  "allStudents").collection("allStudents")
                                  .doc(_dniController.text+"@gmail.com").
                              set(newStudent.toMap());

                              await FirebaseDatabase.instance.ref().child("students").child(_dniController.text).
                              child("accessLimit").child("limit").set({
                                "timestamp":now.millisecondsSinceEpoch ,
                              });

                              // ScaffoldMessenger.of(context).showSnackBar(
                              //     SnackBar(content: Text("saved")));
                              Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          usersSreen()));

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(content: Text("User Created")));

                            }

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
        backgroundColor: Colors.grey[100],
        body:
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                    color: Colors.blue,
                    size: 60,
                  )),
            ),

    );
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

  Future<void> getfamilies() async {

    await init();

    List<dynamic> temp = [];

    await FirebaseFirestore.instance
        .collection("admin")
        .doc("data")
        .collection("families")
        .doc("families").get(GetOptions(source: Source.cache)).then((value) =>
    {

      temp.addAll(value["families"])
    });

    if(temp.isEmpty){
      print("f from cache");
      await FirebaseFirestore.instance
          .collection("admin")
          .doc("data")
          .collection("families")
          .doc("families").get(GetOptions(source: Source.server)).then((value) =>
      {
        temp.addAll(value["families"])
      });

    }
    licenseTypes = temp.cast<String>();

    setState(() {

    });

  }
}