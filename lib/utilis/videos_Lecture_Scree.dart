import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';

class videoLectureScreen extends StatefulWidget {
  String url;
  videoLectureScreen({Key? key,required this.url}) : super(key: key);

  @override
  State<videoLectureScreen> createState() => _videoLectureScreenState();
}

class _videoLectureScreenState extends State<videoLectureScreen> {

  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  bool showPause_btn = false;
  bool isLoading = true;
  late WebViewController co;

  String url = "";

  @override
  void initState() {
    super.initState();

    url = widget.url;
    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    // _controller = VideoPlayerController.network(
    //   'https://www.tiktok.com/@Scout2015/video/6718335390845095173',
    // );
    // _initializeVideoPlayerFuture = _controller.initialize();
    //
    // // Use the controller to loop the video.
    // _controller.setLooping(true);
    //

    co = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {

          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
             isLoading = false;
             setState(() {

             });
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));

  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: WebViewWidget(

          controller: co,
        )
      ));
    //   Stack(
    //     alignment: Alignment.center,
    //     children:[
    //       Container(
    //         height: MediaQuery.of(context).size.height * 0.25,
    //         width: MediaQuery.of(context).size.width,
    //         child: FutureBuilder(
    //         future: _initializeVideoPlayerFuture,
    //         builder: (context, snapshot) {
    //           if (snapshot.connectionState == ConnectionState.done) {
    //             // If the VideoPlayerController has finished initialization, use
    //             // the data it provides to limit the aspect ratio of the video.
    //             return AspectRatio(
    //               aspectRatio: _controller.value.aspectRatio,
    //               // Use thie VideoPlayer widget to display the video.
    //               child: InkWell(
    //                   onTap: (){
    //                     if(!showPause_btn && _controller.value.isPlaying) {
    //                       showPause_btn = true;
    //                       setState(() {
    //
    //                       });
    //                       Future.delayed(Duration(seconds: 2),(){
    //                         showPause_btn = false;
    //                         setState(() {
    //
    //                         });
    //                       });
    //                     }
    //                     else {
    //                       showPause_btn = false;
    //                       setState(() {
    //
    //                       });
    //
    //
    //                     }},
    //                   child: VideoPlayer(_controller)),
    //             );
    //           } else {
    //             // If the VideoPlayerController is still initializing, show a
    //             // loading spinner.
    //             return const Center(
    //               child: CircularProgressIndicator(),
    //             );
    //           }
    //         },
    //     ),
    //       ),
    //
    //       Visibility(
    //
    //           visible: !_controller.value.isPlaying,
    //           child: InkWell(
    //               onTap: (){
    //                 _controller.play();
    //                 setState(() {
    //
    //                 });
    //               },
    //               child: Icon(Icons.play_arrow_outlined,color: Colors.white,size: 70,))),
    //       Container(
    //         height: MediaQuery.of(context).size.height * 0.25,
    //         width: MediaQuery.of(context).size.width,
    //
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: [
    //             Text("data"),
    //             Visibility(
    //
    //                 visible: showPause_btn,
    //                 child: InkWell(
    //                     onTap: (){
    //                       _controller.pause();
    //                       showPause_btn = false;
    //                       setState(() {
    //
    //                       });
    //                     },
    //                     child: Padding(
    //                       padding: const EdgeInsets.symmetric(vertical: 20),
    //                       child: Icon(Icons.pause_circle_filled_outlined,color: Colors.white,size: 70,),
    //                     ))),
    //             VideoProgressIndicator(_controller,
    //
    //                 allowScrubbing: true),
    //
    //           ],
    //         ),
    //       ),
    //
    //
    //     ]
    //
    //   ),
    //   floatingActionButton: FloatingActionButton(
    //     onPressed: () {
    //       // Wrap the play or pause in a call to `setState`. This ensures the
    //       // correct icon is shown.
    //       setState(() {
    //         // If the video is playing, pause it.
    //         if (_controller.value.isPlaying) {
    //           _controller.pause();
    //         } else {
    //           // If the video is paused, play it.
    //           _controller.play();
    //         }
    //       });
    //     },
    //     // Display the correct icon depending on the state of the player.
    //     child: Icon(
    //       _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
    //     ),
    //   ),
    // );
}}
