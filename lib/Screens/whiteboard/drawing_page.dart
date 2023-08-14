// import 'dart:async';
// import 'dart:io';
// import 'dart:typed_data';
// import 'dart:ui' as ui;
//
// import 'package:bmeducators/Screens/whiteboard/sketcher.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_speed_dial/flutter_speed_dial.dart';
// import 'package:image_picker/image_picker.dart';
//
// import '../../Models/studentModel.dart';
// import 'drawn_line.dart';
//
// class DrawingPage extends StatefulWidget {
//   @override
//   _DrawingPageState createState() => _DrawingPageState();
// }
//
// class _DrawingPageState extends State<DrawingPage> {
//   GlobalKey _globalKey = new GlobalKey();
//   List<DrawnLine> lines = <DrawnLine>[];
//    var line;
//   Color selectedColor = Colors.black;
//   double selectedWidth = 5.0;
//   String selectedImage = "";
//   TextEditingController searchText = TextEditingController();
//   List<String> undoStackList = [];
//
//   List<String> searchedimageList = [];
//   List<String> imageList = [
//     'noconnection',
//     'classes',
//     'cross',
//     'logo_plue',
//      'license',
//     'language',
//     'splash',
//     'nationality',
//     'noaccess',
//     'passport',
//   ];
//
//   StreamController<List<DrawnLine>> linesStreamController = StreamController<List<DrawnLine>>.broadcast();
//   StreamController<DrawnLine> currentLineStreamController = StreamController<DrawnLine>.broadcast();
//
//
//   Future<void> clear() async {
//     setState(() {
//     lines.clear();
//     line = null;
//       lines = [];
//       selectedImage = "";
//       isImagePicked = false;
//       // line = null;
//     });
//     print(lines);
//     setState(() {
//
//     });
//   }
//
//
//   final ImagePicker imagePicker = ImagePicker();
//   late XFile imageFile;
//   bool isImagePicked = false;
//
//   Offset position = Offset(0.0, 0.0);
//   double dx = 0.0;
//   double dy = 0.0;
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.yellow[50],
//       floatingActionButton:   SpeedDial( //Speed dial menu
//         marginBottom: 15, //margin bottom
//         icon: Icons.color_lens, //icon on Floating action button
//         activeIcon: Icons.close, //icon when menu is expanded on button
//         backgroundColor: Colors.deepOrangeAccent, //background color of button
//         foregroundColor: Colors.white, //font color, icon color in button
//         activeBackgroundColor: Colors.deepPurpleAccent, //background color when menu is expanded
//         activeForegroundColor: Colors.white,
//         buttonSize: 50.0, //button size
//         visible: true,
//         closeManually: false,
//         curve: Curves.bounceIn,
//         overlayColor: Colors.black,
//         overlayOpacity: 0.5,
//         elevation: 2.0, //shadow elevation of button
//         shape: CircleBorder(), //shape of button
//
//         children: [
//           SpeedDialChild( //speed dial child
//             child:buildColorButton(Colors.white),
//             backgroundColor: Colors.white,
//             foregroundColor: Colors.white,
//             onTap: () => print('FIRST CHILD'),
//             onLongPress: () => print('FIRST CHILD LONG PRESS'),
//           ),
//           SpeedDialChild( //speed dial child
//             child:buildColorButton(Colors.black),
//             backgroundColor: Colors.black,
//             foregroundColor: Colors.black,
//           ),
//           SpeedDialChild( //speed dial child
//             child:buildColorButton(Colors.red),
//             backgroundColor: Colors.red,
//             foregroundColor: Colors.red,
//             onTap: () => print('FIRST CHILD'),
//             onLongPress: () => print('FIRST CHILD LONG PRESS'),
//           ),
//           SpeedDialChild( //speed dial child
//             child:buildColorButton(Colors.blueAccent),
//             backgroundColor: Colors.blueAccent,
//             foregroundColor: Colors.blueAccent,
//             onTap: () => print('FIRST CHILD'),
//             onLongPress: () => print('FIRST CHILD LONG PRESS'),
//           ),
//           SpeedDialChild( //speed dial child
//             child:buildColorButton(Colors.deepOrange),
//             backgroundColor: Colors.deepOrange,
//             foregroundColor: Colors.deepOrange,
//             onTap: () => print('FIRST CHILD'),
//             onLongPress: () => print('FIRST CHILD LONG PRESS'),
//           ),
//           SpeedDialChild( //speed dial child
//             child:buildColorButton(Colors.green),
//             backgroundColor: Colors.green,
//             foregroundColor: Colors.green,
//             onTap: () => print('FIRST CHILD'),
//             onLongPress: () => print('FIRST CHILD LONG PRESS'),
//           ),
//           SpeedDialChild( //speed dial child
//             child:buildColorButton(Colors.lightBlue),
//             backgroundColor: Colors.lightBlue,
//             foregroundColor: Colors.lightBlue,
//           ),
//
//
//           //add more menu item childs here
//         ],
//       ),
//
//       body: Stack(
//         children: [
//           isImagePicked?
//           Center(child: Image.file(File(imageFile.path))):
//               Text(""),
//           selectedImage!=""?
//           Center(child: Image.asset("assets/${selectedImage}.png" )):
//           Text(" "),
//           buildAllPaths(context),
//           buildCurrentPath(context),
//           buildStrokeToolbar(),
//           // Positioned(
//           //     top: position.dy-0,
//           //     left: position.dx-0,
//           //     child: Center(child: DragableImage())),
//
//           buildColorToolbar(),
//
//         ],
//       ),
//     );
//   }
//
//   Widget buildCurrentPath(BuildContext context) {
//     return GestureDetector(
//       onPanStart: onPanStart,
//       onPanUpdate: onPanUpdate,
//       onPanEnd: onPanEnd,
//       child: RepaintBoundary(
//         child: Container(
//           width: MediaQuery.of(context).size.width,
//           height: MediaQuery.of(context).size.height,
//           padding: EdgeInsets.all(4.0),
//           color: Colors.transparent,
//           alignment: Alignment.topLeft,
//           child: StreamBuilder<DrawnLine>(
//             stream: currentLineStreamController.stream,
//             builder: (context, snapshot) {
//               return CustomPaint(
//                 painter: Sketcher(
//                   lines: [line],
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildAllPaths(BuildContext context) {
//     return RepaintBoundary(
//       key: _globalKey,
//       child: Container(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         color: Colors.transparent,
//         padding: EdgeInsets.all(4.0),
//         alignment: Alignment.topLeft,
//         child: StreamBuilder<List<DrawnLine>>(
//           stream: linesStreamController.stream,
//           builder: (context, snapshot) {
//             return  CustomPaint(
//               painter: Sketcher(
//                 lines: lines,
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   void onPanStart(DragStartDetails details) {
//     final RenderBox renderBox = this._globalKey.currentContext!
//         .findRenderObject() as RenderBox;
//     Offset point = renderBox.globalToLocal(details.globalPosition);
//     line = DrawnLine([point], selectedColor, selectedWidth);
//   }
//
//   void onPanUpdate(DragUpdateDetails details) {
//     final RenderBox renderBox = this._globalKey.currentContext!
//         .findRenderObject() as RenderBox;
//     Offset point = renderBox.globalToLocal(details.globalPosition);
//
//     List<Offset> path = List.from(line.path)..add(point);
//     line = DrawnLine(path, selectedColor, selectedWidth);
//     currentLineStreamController.add(line);
//   }
//
//   void onPanEnd(DragEndDetails details) {
//     undoStackList.add("Line");
//     lines = List.from(lines)..add(line);
//
//     linesStreamController.add(lines);
//   }
//
//   Widget buildStrokeToolbar() {
//     return Positioned(
//       bottom: 20.0,
//       right: 90.0,
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           buildStrokeButton(7.0),
//           SizedBox(width: 6,),
//           buildStrokeButton(12.0),
//           SizedBox(width: 6,),
//           buildStrokeButton(17.0),
//         ],
//       ),
//     );
//   }
//
//   Widget buildStrokeButton(double strokeWidth) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectedWidth = strokeWidth;
//         });
//       },
//       child: Padding(
//         padding: const EdgeInsets.all(4.0),
//         child: Container(
//           width: strokeWidth * 2,
//           height: strokeWidth * 2,
//           decoration: BoxDecoration(color: selectedColor, borderRadius: BorderRadius.circular(50.0)),
//         ),
//       ),
//     );
//   }
//
//   Widget buildColorToolbar() {
//     return Positioned(
//       top: 40.0,
//       right: 10.0,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.end ,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Container(
//             width: MediaQuery.of(context).size.width,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(left: 20),
//                   child: IconButton(onPressed: (){
//                     Navigator.of(context).pop();
//
//                   }, icon: Icon(Icons.arrow_back_ios)),
//                 ),
//                 Row(
//                   children: [
//                     buildClearButton(),
//                     SizedBox(width: 25,),
//
//                     buildUndoButton(),
//                     SizedBox(width: 10,),
//
//
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Divider(
//             height: 10.0,
//           ),
//           InkWell(
//             onTap: selectImages,
//             child: CircleAvatar(
//               radius: 22,
//               backgroundColor: Colors.green,
//                 child: Icon(Icons.image,color: Colors.white,size: 30,)),
//           ),
//           Divider(
//             height: 10.0,
//           ),
//           InkWell(
//             onTap:(){
//               addSigns(context);
//               },
//             child: CircleAvatar(
//                 radius: 22,
//                 backgroundColor: Colors.lightBlueAccent,
//                 child: Icon(Icons.format_shapes,color: Colors.white,size: 30,)),
//           ),
//
//         ],
//       ),
//     );
//   }
//
//   Widget buildColorButton(Color color) {
//     return Padding(
//       padding: const EdgeInsets.all(4.0),
//       child: FloatingActionButton(
//         mini: true,
//         backgroundColor: color,
//         child: Container(),
//         onPressed: () {
//           setState(() {
//             selectedColor = color;
//           });
//         },
//       ),
//     );
//   }
//
//   Widget buildSaveButton() {
//     return GestureDetector(
//       child: CircleAvatar(
//         child: Icon(
//           Icons.save,
//           size: 20.0,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }
//
//   Widget buildClearButton() {
//     return GestureDetector(
//       onTap: clear,
//       child: Icon(
//         Icons.clear,
//         size: 30.0,
//         color: Colors.blue,
//       ),
//     );
//   }
//   Widget buildUndoButton() {
//     return GestureDetector(
//       onTap: (){
//         if(undoStackList.isNotEmpty){
//
//
//         if(undoStackList.last == "image"){
//           isImagePicked = false;
//         }
//         else if(undoStackList.last == "sign"){
//           selectedImage = "";
//         }
//         else{
//           lines.removeLast();
//           line = null;
//
//         }
//         undoStackList.removeLast();
//         setState(() {
//
//         });
//       }}
//       ,
//       child: Icon(
//         Icons.undo_outlined,
//         size: 30.0,
//         color: Colors.blue,
//       ),
//     );
//   }
//
//   void selectImages() async {
//     final XFile? selectedImages = (await imagePicker.pickImage(
//         imageQuality: 100, source: ImageSource.gallery));
//     // imageFileList.add(selectedImages!);
//     imageFile = selectedImages!;
//     isImagePicked = true;
//     undoStackList.add("image");
//     setState(() {
//
//     });
//   }
//
//   Future<void> addSigns(BuildContext context) {
//     return showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return StatefulBuilder(builder: (thisLowerContext, innerSetState) {
//             return Dialog(
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Text(
//                       "Signs",
//                       style: TextStyle(
//                           fontFamily: "Poppins",
//                           fontSize: 20,
//                           color: Colors.blue),
//                     ),
//                     Divider(
//                       thickness: 3,
//                     ),
//                      Padding(
//                        padding: const EdgeInsets.symmetric(horizontal: 10),
//                        child: Material(
//                   clipBehavior: Clip.antiAlias,
//                   color: Colors.grey[100],
//                   borderRadius: BorderRadius.circular(20),
//                   child: TextField(
//                     onTapOutside: (p){
//                     },
//                     onTap: (){
//
//
//                     },
//                     onSubmitted: (s){
//                     },
//                     onChanged: (s) {
//                         if(s!= "") {
//                           searchedimageList.clear();
//                           print(imageList.where((element) =>
//                               element.toLowerCase().contains(
//                                   s.toLowerCase())).toList());
//                           searchedimageList.addAll(imageList.where((element) =>
//                               element.toLowerCase().contains(
//                                   s.toLowerCase())).toList());
//                         }
//                         else{
//                           searchedimageList.clear();
//                         }
//                     innerSetState((){
//
//                     });
//                     },
//                     style: TextStyle(
//                           fontFamily: "PoppinRegular", color: Colors.grey[600]),
//                     controller: searchText,
//                     onEditingComplete: (){
//                         print(searchText);
//                     },
//                     decoration: InputDecoration(
//                           contentPadding: const EdgeInsets.only(left: 20),
//                           suffixIcon: IconButton(
//                             padding: const EdgeInsets.symmetric(horizontal: 20),
//                             onPressed: () {
//
//                             },
//                             icon:
//
//                             InkWell(
//                                 onTap: (){
//                                   if(searchText !=""){
//                                     searchText.clear();
//                                     searchedimageList.clear();
//
//                                     innerSetState((){
//
//                                     });
//                                   }
//                                 },
//                                 child:
//                             searchText.text ==""?
//                             Icon(Icons.search_outlined,
//                               color: Colors.lightBlueAccent,):
//                             Icon(Icons.close,
//                             color: Colors.black,)),
//
//                   ),
//                           label: const Text(
//                             "Search",
//                             style: TextStyle(
//                                 color: Colors.lightBlueAccent,
//                                 fontFamily: "PoppinRegular"),
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                               borderSide: BorderSide(color: Colors.blue,width: 1),
//                               borderRadius: BorderRadius.circular(20)
//                           )
//                     ),
//                   ),
//                 ),
//                      ),
//                     // SizedBox(
//                     //   height: MediaQuery
//                     //       .of(context)
//                     //       .size
//                     //       .height * 0.06,
//                     //   width: MediaQuery
//                     //       .of(context)
//                     //       .size
//                     //       .width * 1,
//                     //
//                     //
//                     //   child: Padding(
//                     //     padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
//                     //     child: Autocomplete<String>(
//                     //       optionsMaxHeight: 10,
//                     //       optionsViewBuilder: (context, Function onSelected,
//                     //           Iterable<String> options) {
//                     //         return Align(
//                     //           alignment: Alignment.topLeft,
//                     //           child: Material(
//                     //             elevation: 10,
//                     //             borderRadius: BorderRadius.circular(20),
//                     //             child: Container(
//                     //               padding: const EdgeInsets.symmetric(horizontal: 20),
//                     //               width: MediaQuery
//                     //                   .of(context)
//                     //                   .size
//                     //                   .width - 70,
//                     //               child: ListView.separated(
//                     //                 shrinkWrap: true,
//                     //                 padding: EdgeInsets.zero,
//                     //                 itemBuilder: (context, index) {
//                     //                   String option = options.elementAt(index);
//                     //                   return ListTile(
//                     //                     title: Text(
//                     //                       option,
//                     //                       style: const TextStyle(
//                     //                           fontFamily: "PoppinRegular"),
//                     //                     ),
//                     //                     subtitle: Text(option),
//                     //                     onTap: () {
//                     //
//                     //                     },
//                     //                   );
//                     //                 },
//                     //                 separatorBuilder: (context, index) =>
//                     //                 const Divider(
//                     //                   height: 0,
//                     //                 ),
//                     //                 itemCount: options.length,
//                     //               ),
//                     //             ),
//                     //           ),
//                     //         );
//                     //       },
//                     //       onSelected: (selectedString) {
//                     //         print(selectedString);
//                     //       },
//                     //       optionsBuilder: (TextEditingValue texteditingvalue) {
//                     //         if (texteditingvalue.text.isEmpty) {
//                     //           return const Iterable<String>.empty();
//                     //         } else {
//                     //           return imageList.where((element) =>
//                     //               element.toLowerCase().contains(
//                     //                   texteditingvalue.text.toLowerCase())).toList();
//                     //         }
//                     //       },
//                     //       fieldViewBuilder:
//                     //           (context, controller, focusmode, onEditingComplete) {
//                     //         return Material(
//                     //           clipBehavior: Clip.antiAlias,
//                     //           color: Colors.grey[100],
//                     //           borderRadius: BorderRadius.circular(20),
//                     //           child: TextField(
//                     //             onTapOutside: (p){
//                     //               controller.text = "";
//                     //             },
//                     //             onTap: (){
//                     //
//                     //
//                     //             },
//                     //             onSubmitted: (s){
//                     //             },
//                     //             onChanged: (s) {},
//                     //             style: TextStyle(
//                     //                 fontFamily: "PoppinRegular", color: Colors.grey[600]),
//                     //             controller: controller,
//                     //             focusNode: focusmode,
//                     //             onEditingComplete: onEditingComplete,
//                     //             decoration: InputDecoration(
//                     //                 contentPadding: const EdgeInsets.only(left: 20),
//                     //                 suffixIcon: IconButton(
//                     //                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                     //                   onPressed: () {
//                     //
//                     //                   },
//                     //                   icon: const Icon(Icons.search_outlined,color: Colors.lightBlueAccent,),
//                     //                 ),
//                     //                 label: const Text(
//                     //                   "Search",
//                     //                   style: TextStyle(
//                     //                       color: Colors.lightBlueAccent,
//                     //                       fontFamily: "PoppinRegular"),
//                     //                 ),
//                     //                 enabledBorder: OutlineInputBorder(
//                     //                     borderSide: BorderSide(color: Colors.blue,width: 1),
//                     //                     borderRadius: BorderRadius.circular(20)
//                     //                 )
//                     //             ),
//                     //           ),
//                     //         );
//                     //       },
//                     //     ),
//                     //   ),
//                     // ),
//                     SizedBox(height: 20,),
//                     searchedimageList.isEmpty?
//                     SizedBox(
//                       height: MediaQuery.of(context).size.height*0.7,
//                       child: ListView.builder(
//                         shrinkWrap: true,
//                         physics: ClampingScrollPhysics(),
//                         padding: const EdgeInsets.all(10),
//                         itemBuilder: (context, index) {
//                           return InkWell(
//                             onTap: (){
//                               selectedImage = imageList[index];
//                               undoStackList.add("sign");
//                               Navigator.pop(context);
//                               update();
//                             },
//                             child: Column(
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.symmetric(vertical: 10),
//                                   child: Image.asset(
//                                     "assets/${imageList[index]}.png",
//                                     height: MediaQuery.of(context).size.height*0.15,
//
//                                   ),
//                                 ),
//                                 Divider(thickness: 2,)
//                               ],
//                             ),
//                           );
//                         },
//                         itemCount: imageList.length,
//                       ),
//                     ):
//                     SizedBox(
//                       height: MediaQuery.of(context).size.height*0.7,
//                       child: ListView.builder(
//                         shrinkWrap: true,
//                         physics: ClampingScrollPhysics(),
//                         padding: const EdgeInsets.all(10),
//                         itemBuilder: (context, index) {
//                           return InkWell(
//                             onTap: (){
//                               selectedImage = searchedimageList[index];
//                               Navigator.pop(context);
//                               update();
//                             },
//                             child: Column(
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.symmetric(vertical: 10),
//                                   child: Image.asset(
//                                     "assets/${searchedimageList[index]}.png",
//                                     height: MediaQuery.of(context).size.height*0.15,
//
//                                   ),
//                                 ),
//                                 Divider(thickness: 2,)
//                               ],
//                             ),
//                           );
//                         },
//                         itemCount: searchedimageList.length,
//                       ),
//                     ),
//
//                   ],
//                 ),
//               ),
//             );
//           });
//         });
//   }
//
//   void update() {
//     setState(() {});
//   }
//
//   Widget DragableImage(){
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height ;
//
//     double middleX = screenWidth / 2;
//     double middleY = screenHeight / 2;
//     AssetImage apple = AssetImage('assets/noconnection.png');
//     position = Offset(0.0, 0.0);
//     return LongPressDraggable<AssetImage>(
//      data: apple,
//       child: Container(
//         color: Colors.red,
//         child: Image.asset("assets/noconnection.png",
//         height: 200,
//         ),
//       ),//
//       onDraggableCanceled: (velocity, offset) {
//         setState(() {
//           print("dfdsfdsfdsds");
//           print(dx);
//           print(dy);
//           position = Offset(dx, dy);
//
//         });
//       },
//       onDragStarted: () {
//         // setState(() {
//         //   print('drag started');
//         //   _imageToShow = new AssetImage('assets/images/answered_apple.png');
//         //   return _imageToShow;
//         // });
//       },
//       feedback:Text(""),
//       onDragUpdate: (e){
//
//        setState(() {
//          position = e.localPosition;
//          dx = e.localPosition.dx - 50;
//          dy = e.localPosition.dy - 50;
//        });
//       },
//       onDragCompleted: (){
//
//       },
//     );
//   }
//
// }
