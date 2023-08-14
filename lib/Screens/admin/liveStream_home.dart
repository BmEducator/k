// import 'dart:io';
// import 'dart:typed_data';
//
// import 'package:dotted_border/dotted_border.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
//
// import '../../resources/firebase_methods.dart';
// import 'broadcastScreen.dart';
//
// class GoLiveScreen extends StatefulWidget {
//   const GoLiveScreen({Key? key}) : super(key: key);
//
//   @override
//   State<GoLiveScreen> createState() => _GoLiveScreenState();
// }
//
// class _GoLiveScreenState extends State<GoLiveScreen> {
//   final TextEditingController _titleController = TextEditingController();
//   Uint8List? image;
//
//   final ImagePicker imagePicker = ImagePicker();
//   late XFile imageFile;
//   bool isImagePicked = false;
//   String imageUrl = "";
//
//   @override
//   void dispose() {
//     _titleController.dispose();
//     super.dispose();
//   }
//
//   goLiveStream() async {
//     await uploadImage();
//     String channelId = await FirestoreMethods()
//         .startLiveStream(context, _titleController.text, imageUrl);
//
//     if (channelId.isNotEmpty) {
//       Navigator.of(context).push(
//         MaterialPageRoute(
//           builder: (context) => BroadcastScreen(
//             isBroadcaster: true,
//             channelId: channelId,
//           ),
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 18.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     children: [
//                       GestureDetector(
//                         onTap: () async {
//                           // Uint8List? pickedImage = await pickImage();
//                           // if (pickedImage != null) {
//                           //   setState(() {
//                           //     image = pickedImage;
//                           //   });
//                           // }
//
//                           final XFile? selectedImages = (await imagePicker.pickImage(
//                               imageQuality: 10, source: ImageSource.gallery));
//                           imageFile = selectedImages!;
//                           setState(() {
//                             isImagePicked = true;
//                           });
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 22.0,
//                             vertical: 20.0,
//                           ),
//                           child:isImagePicked
//                               ? SizedBox(
//                             height: 300,
//                             child: Image.file(File(imageFile.path)),
//                           )
//                               : DottedBorder(
//                             borderType: BorderType.RRect,
//                             radius: const Radius.circular(10),
//                             dashPattern: const [10, 4],
//                             strokeCap: StrokeCap.round,
//                             color: Colors.blue,
//                             child: Container(
//                               width: double.infinity,
//                               height: 150,
//                               decoration: BoxDecoration(
//                                 color: Colors.blue,
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   const Icon(
//                                     Icons.folder_open,
//                                     color: Colors.blue,
//                                     size: 40,
//                                   ),
//                                   const SizedBox(height: 15),
//                                   Text(
//                                     'Select your thumbnail',
//                                     style: TextStyle(
//                                       fontSize: 15,
//                                       color: Colors.red,
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text(
//                             'Title',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 8),
//                             child: TextField(
//                               controller: _titleController,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(
//                       bottom: 10,
//                     ),
//                     child: ElevatedButton(
//                         onPressed: goLiveStream,
//                         child: Text("Go Live"))
//                   )
//                 ],
//               ),
//             ),
//           ),
//
//       ),
//     );
//   }
//
//   Future uploadImage() async {
//
//     final Reference storageReference =FirebaseStorage.instance
//         .ref()
//         .child('profileImage/(${imageFile.name}.path)');
//
//     String downloadURL;
//     final uploadTask = storageReference.putFile(File(imageFile.path));
//     uploadTask.snapshotEvents.listen((event) {
//       switch (event.state) {
//         case TaskState.running:
//           final p = 100.0 * (event.bytesTransferred / event.totalBytes);
//           print("prog $p");
//           break;
//
//         case TaskState.paused:
//           print("paused");
//           break;
//
//         case TaskState.success:
//           print("succ");
//           break;
//         case TaskState.canceled:
//           print("cancek");
//           break;
//         case TaskState.error:
//           print("errr");
//           break;
//       }
//     });
//
//     downloadURL = await (await uploadTask).ref.getDownloadURL();
//     imageUrl = downloadURL;
//   }
// }