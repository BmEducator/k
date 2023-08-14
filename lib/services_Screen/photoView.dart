import 'dart:convert';
import 'dart:io';

import 'package:bmeducators/Screens/whiteboard/flutter_painte_mobile.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:photo_view/photo_view.dart';
import 'dart:math' as math;

import 'package:photo_view/photo_view_gallery.dart';

import '../Models/question.dart';
import '../Screens/whiteboard/flutter_paintef.dart';

class previewImage extends StatefulWidget {
  final PageController pageC;
  QuestionModel question;
  final List<dynamic> imageUrls;
  final int index;
  bool isFile;
  // const previewImage({Key? key, required this.pageC, required this.imageUrls, required this.index}):super(key: key);

  previewImage({super.key,
    required this.question,
    required this.imageUrls,
    required this.index,
    required this.isFile
}):pageC = PageController(initialPage: index);

  @override
  State<previewImage> createState() => _previewImageState();
}
class _previewImageState extends State<previewImage> {

  late List<dynamic> imageList;
  late int index = widget.index;

  @override
  void initState() {
    super.initState();
    imageList = widget.imageUrls;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            pageController: widget.pageC,
            scrollPhysics: const BouncingScrollPhysics(),
            builder: (BuildContext context, int index) {
              return widget.isFile?
              PhotoViewGalleryPageOptions(
                  imageProvider: FileImage(File(imageList[index])),
                  initialScale: PhotoViewComputedScale.contained * 1,
                  heroAttributes: const PhotoViewHeroAttributes(tag:3)):
              PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(imageList[index]),
                initialScale: PhotoViewComputedScale.contained * 1,
                heroAttributes: const PhotoViewHeroAttributes(tag:3),

              );
            },
            itemCount: imageList.length,
            loadingBuilder: (context, event) =>  Center(

              child: Container(
                margin: const EdgeInsets.only(bottom: 100),
                child: Center(
                  child: Center(
                    child: Stack(
                      children: [

                        const SizedBox(
                            width: 70,
                            height: 70,

                            child: CircularProgressIndicator()),
                        SizedBox(
                            width: 70,
                            height: 70,

                            child: Center(
                              child: Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.rotationY(math.pi),
                                child: const SizedBox(
                                  width: 40,
                                  height: 40,

                                  child: CircularProgressIndicator(


                                  ),
                                ),
                              ),
                            )),

                      ],
                    ),
                  ),
                ),
              ),
            ),
            onPageChanged: (index) => setState(() => this.index = index),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                    onTap: (){Navigator.pop(context);},
                    child: Icon(Icons.close,color: Colors.white,)),
                InkWell(
                  onTap: () async {

                    Navigator.of(context).push(new MaterialPageRoute<Null>(
                        builder: (BuildContext context) {
                          return new FlutterPainter_mobile(image: widget.imageUrls[0], question: widget.question, height:0,width:0);
                        },
                        fullscreenDialog: true));
                  },
                  child: Material(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.blue ,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                      child: Row(
                        children: [
                          Icon(PhosphorIcons.pen,color: Colors.white,size: 30,),
                          Text("  Whiteboard",style: TextStyle(color: Colors.white),)

                        ],
                      ),
                    )
                    ,
                  ),
                ),
              ],
            ),
          ),

        ],

      ),
    );  }
}
