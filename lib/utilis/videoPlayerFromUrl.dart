// import 'dart:io';
//
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
// import 'package:better_player/better_player.dart';
// import 'package:webview_flutter/webview_flutter.dart';
//
// class videoPlayerForUrl extends StatefulWidget {
//   String url;
//
//   videoPlayerForUrl({Key? key, required this.url}) : super(key: key);
//
//   @override
//   State<videoPlayerForUrl> createState() => _videoPlayerForUrlState();
// }
//
// class _videoPlayerForUrlState extends State<videoPlayerForUrl> {
//   // late VideoPlayerController _controller;
//   late Future<void> _initializeVideoPlayerFuture;
//
//   bool showPause_btn = false;
//   bool isLoaded = false;
//   late WebViewController co;
//
//   late BetterPlayerController betterPlayerController;
//   late BetterPlayerController playerController;
//   @override
//   void initState() {
//     super.initState();
//     BetterPlayerDataSource betterPlayerDataSource= BetterPlayerDataSource(BetterPlayerDataSourceType.network, widget.url);
//     betterPlayerController = BetterPlayerController(BetterPlayerConfiguration(
//         autoPlay: true,
//         fit: BoxFit.contain,
//         controlsConfiguration: BetterPlayerControlsConfiguration(
//             enableOverflowMenu: false,
//             showControlsOnInitialize: false)
//
//
//
//     ),betterPlayerDataSource: betterPlayerDataSource);
//
//     // setState(() {
//     //   _controller = VideoPlayerController.network(
//     //     widget.url,
//     //   )..initialize().then((_){
//     //     setState(() {
//     //        isLoaded= true;
//     //     });
//     //   });
//     // });
//
//     playerController = BetterPlayerController(BetterPlayerConfiguration(
//       autoPlay: true,
//       fit: BoxFit.contain,
//       controlsConfiguration: BetterPlayerControlsConfiguration(
//         enableOverflowMenu: false,
//         showControlsOnInitialize: false
//
//       )
//     ));
//     // playerController.betterPlayerDataSource = BetterPlayerDataSource(BetterPlayerDataSourceType.network,"dsf");
//     // _controller.initialize();
//   }
//
//   @override
//   void dispose() {
//     // Ensure disposing of the VideoPlayerController to free up resources.
//     // _controller.dispose();
//
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.black.withOpacity(0.1),
//         body: isLoaded ? Stack(children: [
//
//           // AspectRatio(aspectRatio: 16/9,
//           // child: BetterPlayer(controller: betterPlayerController)
//           // ),
//           // VideoPlayer(_controller),
//           // Positioned(
//           //     right: 0,
//           //     child: Padding(
//           //     padding: EdgeInsets.all(5),
//           //       child:               Material(
//           //           elevation: 8,
//           //           borderRadius: BorderRadius.circular(10),
//           //           color: Colors.black.withOpacity(0.3),
//           //           child: Text("  ${getDuratio()}  ",style: TextStyle(color: Colors.white),))),
//           //
//           //     )
//
//
//         ]):Center(
//           child: CircularProgressIndicator(),
//         )
//
//     );
//
//   }
//   // getDuratio(){
//   //   var d = Duration(milliseconds: _controller.value.duration.inMilliseconds.round());
//   //   return [d.inMinutes,d.inSeconds].map((e) => e.remainder(60).toString().padLeft(2,'0')).join(':');
//   //   setState(() {
//   //
//   //   });
//   // }
// }
