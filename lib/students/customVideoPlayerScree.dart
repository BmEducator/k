import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';

class customVideoPlayer extends StatefulWidget {
  String url;

  customVideoPlayer({Key? key, required this.url}) : super(key: key);

  @override
  State<customVideoPlayer> createState() => _customVideoPlayerState();
}

class _customVideoPlayerState extends State<customVideoPlayer> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  bool showPause_btn = false;
  bool isLoaded = false;
  bool isPlaying = false;
  late WebViewController co;

  @override
  void initState() {
    super.initState();
    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    setState(() {
      _controller = VideoPlayerController.network(
        widget.url,
      )..initialize().then((_){
        setState(() {
          isLoaded= true;
        });
      });
    });

    // playerController = BetterPlayerController(BetterPlayerConfiguration(
    //   autoPlay: true,
    //   fit: BoxFit.contain,
    //   controlsConfiguration: BetterPlayerControlsConfiguration(
    //     enableOverflowMenu: false,
    //     showControlsOnInitialize: fa
    //
    //   )
    // ));
    _controller.initialize();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black.withOpacity(0.1),
        body: isLoaded ? Stack(children: [
          VideoPlayer(_controller),
          Visibility(
            visible: isPlaying,
            child: InkWell(
              onTap: (){
                  _controller.play();
                  setState(() {
                    isPlaying= true;
                  });
              },
              child: Center(child:
                Icon(
                  Icons.play_arrow_outlined,color: Colors.white70,size: 150,)
                ,),
            ),
          ),
          Visibility(
            visible: !isPlaying,
            child: InkWell(
              onTap: (){
                _controller.pause();
                setState(() {
                  isPlaying= true;
                });
              },
              child: Center(child:
              Icon(
                Icons.play_arrow_outlined,color: Colors.white70,size: 150,)
                ,),
            ),
          )
        ]):Center(
          child: CircularProgressIndicator(),
        )

    );

  }
  getDuratio(){
    var d = Duration(milliseconds: _controller.value.duration.inMilliseconds.round());
    return [d.inMinutes,d.inSeconds].map((e) => e.remainder(60).toString().padLeft(2,'0')).join(':');
    setState(() {

    });
  }
}
