import 'dart:io';

import 'package:bmeducators/Models/videoListModel.dart';
import 'package:bmeducators/Screens/admin/videoScreenAdmin.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';

import '../../Models/videoLectureModel.dart';
import 'package:intl/intl.dart';


class addVideoLecture extends StatefulWidget {
  List<videoLectureModel> videosList = [] ;
  String family;

  addVideoLecture({Key? key,required this.videosList,required this.family}) : super(key: key);

  @override
  State<addVideoLecture> createState() => _addVideoLectureState();
}

class _addVideoLectureState extends State<addVideoLecture> {
  final TextEditingController _captionController = TextEditingController();


  late VideoPlayerController _controller;


  bool isthumPicked = false;
  bool isvideoPicked = false;
  bool isvideoUploading = false;
  final ImagePicker imagePicker = ImagePicker();
  late XFile imageFile;
  late XFile videoFile;
  String _imageUrl = "";
  String _videoUrl = "";
  double uploadProgress = 0;
  late File f;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
              child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.arrow_back_ios, color: Colors.blue,)),

                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            style: TextStyle(
                                fontFamily: "PoppinRegular", fontSize: 22),
                            "Add New Lecture in",),
                          Text(
                            style: TextStyle(
                                fontFamily: "Poppins", fontSize: 24),
                            widget.family,),
                          const SizedBox(
                            height: 30,
                          ),

                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green),
                              onPressed: () async {
                                 selectVideo();

                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.ondemand_video_sharp, size: 35,),
                                  Text("     Select Video", style: TextStyle(
                                      fontFamily: "Poppins", fontSize: 18),),
                                ],
                              )),

                          const SizedBox(
                            height: 24,
                          ),
                          Container(
                              child:
                              isvideoPicked ?

                              Container(
                                height: 300,
                                width: 200,

                                child: Expanded(
                                  flex: 3,
                                  child: VideoPlayer(_controller),
                                ),
                              )
                                  :
                              Text("")

                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          TextField(
                            controller: _captionController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              labelText: "Add Caption",
                            ),
                            minLines: 3,
                            maxLines: 3,
                          ),
                          const SizedBox(
                            height: 34,
                          ),

                          // Text(
                          //   style: TextStyle(
                          //       fontFamily: "Poppins", fontSize: 18),
                          //   "Video Thumbnail ",),
                          // const SizedBox(
                          //   height: 14,
                          // ),
                          // isvideoPicked ? Image.file(f) :

                          // Container(
                          //   width: 200,
                          //   height: 200,
                          //   child: Center(
                          //     child: Icon(Icons.photo),
                          //   ),
                          // ),


                        ],
                      ),
                    ),
                    Visibility(
                      visible: isvideoUploading,
                      child: Container(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        color: Colors.black.withOpacity(0.86),
                        child: Center(
                          child: Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.8,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Text(uploadProgress != 100
                                        ? "Uploading..."
                                        : "", style: TextStyle(
                                        fontFamily: "Poppins",
                                        color: Colors.white,
                                        fontSize: 17),),
                                    Text(uploadProgress != 100
                                        ? "${(uploadProgress).round()}%"
                                        : "Video Uploaded Successfully....",
                                      style: TextStyle(fontFamily: "Poppins",
                                          color: Colors.white,
                                          fontSize: 17),),

                                  ],
                                ),
                                SizedBox(height: 10,),
                                LinearProgressIndicator(
                                  minHeight: 14,
                                  color: Colors.orange,
                                  backgroundColor: Colors.grey[200],
                                  value: uploadProgress / 100,
                                ),
                                SizedBox(height: 50,),
                                Visibility(
                                  visible: uploadProgress == 100,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 50),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    adminVideoScreen(family: widget.family,)));
                                      },
                                      child: Material(
                                        borderRadius:
                                        const BorderRadius.all(
                                            Radius.circular(8)),
                                        elevation: 6,
                                        color: Colors.yellow,
                                        child: Container(
                                            height: 40,
                                            width: double.infinity,
                                            alignment: Alignment.center,
                                            child: Text(
                                              'Continue',
                                              style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  color: Colors.black,
                                                  fontSize: 17),
                                            )),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 100,),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]

              ),
            )
        ),

        bottomNavigationBar: BottomAppBar(
          child: Visibility(
            visible: !isvideoUploading,
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
                              // Navigator.pop(context);
                              print(   _controller.value.duration);
                              print("-----------------");

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
                                isvideoUploading = true;
                              });
                              await uploadImage();
                              await uploadVideo();
                              var s = DateTime.fromMillisecondsSinceEpoch(int.parse(_controller.value.duration.inMilliseconds.toString()));

                              String dur = DateFormat.ms().format(s);

                              print(dur);
                              videoLectureModel video = videoLectureModel(
                                  caption: _captionController.text,
                                  url: _videoUrl,
                                  thumbnail: _imageUrl, duration: dur);
                              // FirebaseFirestore.instance.collection("admin")
                              //     .doc(
                              //     "data").collection("videos")
                              //     .doc("lecture").collection("all").doc()
                              //     .
                              // set(video.toMap());

                              List<videoLectureModel> m = [];
                              m.addAll(widget.videosList);
                              m.add(video);

                              videoListModel v = videoListModel(videos: m);
                              String time = DateTime.now().millisecondsSinceEpoch.toString();

                              FirebaseFirestore.instance.collection("admin")
                                  .doc(
                                  "data").collection("videos")
                                  .doc("lecture").collection(widget.family).doc("lectures")
                                  .set(v.toMap());


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
          ),
        )
    );
  }


  void selectImages() async {
    final XFile? selectedImages = (await imagePicker.pickImage(
        imageQuality: 10, source: ImageSource.gallery));
    // imageFileList.add(selectedImages!);
    imageFile = selectedImages!;
    isthumPicked = true;
    setState(() {

    });
  }

  void selectVideo() async {
    videoFile = (await imagePicker.pickVideo(source: ImageSource.gallery))!;

    videoFile = videoFile;

    setState(() {
      _controller = VideoPlayerController.file(File(videoFile.path));
    });
    _controller.initialize();
    // Use the controller to loop the video.
    _controller.setLooping(false);

    f = await VideoCompress.getFileThumbnail(videoFile.path);

    setState(() {
      isvideoPicked = true;
    });
  }


  Future uploadImage() async {
    print("image upload");
    DateTime timestamp = DateTime.now();
    print(timestamp);

    final Reference storageReference = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('admin/data/videoLecture/thumbs/ ${videoFile.name})');
    String downloadURL;
    final uploadTask = storageReference.putFile(f);
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


  Future uploadVideo() async {
    print("video upload");

    final Reference storageReference = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('admin/data/videoLecture/${videoFile.name})');
    String downloadURL;
    final uploadTask = storageReference.putFile(File(videoFile.path));
    uploadTask.snapshotEvents.listen((event) {
      switch (event.state) {
        case TaskState.running:
          final p = 100.0 * (event.bytesTransferred / event.totalBytes);
          uploadProgress = p;
          setState(() {

          });
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
    _videoUrl = downloadURL;
  }
}
