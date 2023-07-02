import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'dart:math' as math;

import 'package:photo_view/photo_view_gallery.dart';

class previewImage extends StatefulWidget {
  final PageController pageC;
  final List<dynamic> imageUrls;
  final int index;
  bool isFile;
  // const previewImage({Key? key, required this.pageC, required this.imageUrls, required this.index}):super(key: key);

  previewImage({super.key,
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
          SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child:   IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.close),color: Colors.white,),
              )),

        ],

      ),
    );  }
}
