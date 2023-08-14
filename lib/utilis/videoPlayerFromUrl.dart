import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';

class videoPlayerForUrl extends StatefulWidget {
  String url;

  videoPlayerForUrl({Key? key, required this.url}) : super(key: key);

  @override
  State<videoPlayerForUrl> createState() => _videoPlayerForUrlState();
}

class _videoPlayerForUrlState extends State<videoPlayerForUrl> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  bool showPause_btn = false;
  bool isLoaded = false;
  late WebViewController co;

  // late BetterPlayerController betterPlayerController;
  // late BetterPlayerController playerController;
  @override
  void initState() {
    super.initState();
    // BetterPlayerDataSource betterPlayerDataSource= BetterPlayerDataSource(BetterPlayerDataSourceType.network, widget.url);
    // betterPlayerController = BetterPlayerController(BetterPlayerConfiguration(
    //     autoPlay: true,
    //     fit: BoxFit.contain,
    //     controlsConfiguration: BetterPlayerControlsConfiguration(
    //         enableOverflowMenu: false,
    //         showControlsOnInitialize: false)
    //
    //
    //
    // ),betterPlayerDataSource: betterPlayerDataSource);

    setState(() {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.url),
      )..initialize().then((_){

        setState(() {
           isLoaded= true;
        });
      });
      _controller.play();
    });

    // playerController = BetterPlayerController(BetterPlayerConfiguration(
    //   autoPlay: true,
    //   fit: BoxFit.contain,
    //   controlsConfiguration: BetterPlayerControlsConfiguration(
    //     enableOverflowMenu: false,
    //     showControlsOnInitialize: false
    //
    //   )
    // ));
    // playerController.betterPlayerDataSource = BetterPlayerDataSource(BetterPlayerDataSourceType.network,"dsf");
    // _controller.initialize();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    // _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black.withOpacity(0.1),
        body: isLoaded ? Column(
          children: [
        SizedBox(
            width: MediaQuery.of(context).size.width*0.4,
            height: MediaQuery.of(context).size.height*0.4,
            child: VideoPlayer(_controller)),
        Container(
          width: MediaQuery.of(context).size.width*0.4,
          color: Colors.grey,
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: (){
                        if(_controller.value.isPlaying){
                          _controller.pause();
                        }else{
                          _controller.play();
                        }

                        setState(() {

                        });
                      },
                      icon:Icon(_controller.value.isPlaying?Icons.pause:Icons.play_arrow,size: 60,)
                  ),

                  IconButton(
                      onPressed: (){
                        _controller.seekTo(Duration(seconds: 0));

                        setState(() {

                        });
                      },
                      icon:Icon(Icons.stop,size: 60,)
                  )
                ],
              ),
            ],
          ),
        ),
          ],
        ):Center(
          child: CircularProgressIndicator(),
        )

    );

  }
  // getDuratio(){
  //   var d = Duration(milliseconds: _controller.value.duration.inMilliseconds.round());
  //   return [d.inMinutes,d.inSeconds].map((e) => e.remainder(60).toString().padLeft(2,'0')).join(':');
  //   setState(() {
  //
  //   });
  // }
}
