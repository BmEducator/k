// import 'package:agora_rtc_engine/rtc_engine.dart';
// import 'package:bmeducators/utilis/appIds.dart';
// import 'package:flutter/material.dart';
// import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
// import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
//
// import 'RealTimeMessaging.dart';
//
// class BroadcastPage extends StatefulWidget {
//   final String channelName;
//   final String userName;
//   String myid = "";
//   final bool isBroadcaster;
//   BroadcastPage({Key? key, required this.channelName,
//     required this.userName, required this.isBroadcaster}) : super(key: key);
//
//
//   @override
//   _BroadcastPageState createState() => _BroadcastPageState();
// }
//
// class _BroadcastPageState extends State<BroadcastPage> {
//   final _users = <int>[];
//   final _infoStrings = <String>[];
//   late RtcEngine _engine;
//   int myid = 0;
//   bool muted = false;
//   String appId = "5caa8fd8470741ef98b57d85ecdc95a0";
//
//   @override
//   void dispose() {
//     // clear users
//     _users.clear();
//     // destroy sdk and leave channel
//     _engine.destroy();
//     super.dispose();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     // initialize agora sdk
//     initialize();
//   }
//   Future<void> initialize() async {
//     print('Client Role: ${widget.isBroadcaster}');
//     if (appId.isEmpty) {
//       setState(() {
//         _infoStrings.add(
//           "5caa8fd8470741ef98b57d85ecdc95a0"
//         );
//         _infoStrings.add('Agora Engine is not starting');
//       });
//       return;
//     }
//     await _initAgoraRtcEngine();
//     _addAgoraEventHandlers();
//     await _engine.joinChannelWithUserAccount(
//       tokenId,
//       widget.channelName,
//       "myid",
//     );
//     // await _engine.joinChannel(null, widget.channelName, null, 0);
//   }
//
//
//   Future<void> _initAgoraRtcEngine() async {
//     _engine = await RtcEngine.create(appId);
//     await _engine.enableVideo();
//     await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
//     if (widget.isBroadcaster) {
//       await _engine.setClientRole(ClientRole.Broadcaster);
//     } else {
//       await _engine.setClientRole(ClientRole.Audience);
//     }
//   }
//   void _addAgoraEventHandlers() {
//     _engine.setEventHandler(RtcEngineEventHandler(error: (code) {
//       setState(() {
//         final info = 'onError: $code';
//         _infoStrings.add(info);
//       });
//     }, joinChannelSuccess: (channel, uid, elapsed) {
//
//       myid = uid;
//       setState(() {
//         final info = 'onJoinChannel: $channel, uid: $uid';
//         _infoStrings.add(info);
//       });
//     }, leaveChannel: (stats) {
//       setState(() {
//         _infoStrings.add('onLeaveChannel');
//         _users.clear();
//       });
//     }, userJoined: (uid, elapsed) {
//       setState(() {
//         final info = 'userJoined: $uid';
//         _infoStrings.add(info);
//         _users.add(uid);
//       });
//     }, userOffline: (uid, elapsed) {
//       setState(() {
//         final info = 'userOffline: $uid';
//         _infoStrings.add(info);
//         _users.remove(uid);
//       });
//     },
//     ));
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Stack(
//           children: <Widget>[
//             _renderVideo("adminChannel", false),
//             _toolbar(),
//           ],
//         ),
//       ),
//     );
//   }
//
//
//   // List<Widget> _getRenderViews() {
//   //   final List<StatefulWidget> list = [];
//   //   if(widget.isBroadcaster) {
//   //     list.add(RtcRemoteView.SurfaceView());
//   //   }
//   //   _users.forEach((int uid) => list.add(RtcRemoteView.SurfaceView(uid: uid)));
//   //   return list;
//   // }
//
//   /// Video view wrapper
//   Widget _videoView(view) {
//     return Expanded(child: Container(child: view));
//   }
//
//   /// Video view row wrapper
//   Widget _expandedVideoRow(List<Widget> views) {
//     final wrappedViews = views.map<Widget>(_videoView).toList();
//     return Expanded(
//       child: Row(
//         children: wrappedViews,
//       ),
//     );
//   }
//
//   /// Video layout wrapper
//   // Widget _viewRows() {
//   //   final views = _getRenderViews();
//   //   switch (views.length) {
//   //     case 1:
//   //       return Container(
//   //           child: Column(
//   //             children: <Widget>[_videoView(views[0])],
//   //           ));
//   //     case 2:
//   //       return Container(
//   //           child: Column(
//   //             children: <Widget>[
//   //               _expandedVideoRow([views[0]]),
//   //               _expandedVideoRow([views[1]])
//   //             ],
//   //           ));
//   //     case 3:
//   //       return Container(
//   //           child: Column(
//   //             children: <Widget>[
//   //               _expandedVideoRow(views.sublist(0, 2)),
//   //               _expandedVideoRow(views.sublist(2, 3))
//   //             ],
//   //           ));
//   //     case 4:
//   //       return Container(
//   //           child: Column(
//   //             children: <Widget>[
//   //               _expandedVideoRow(views.sublist(0, 2)),
//   //               _expandedVideoRow(views.sublist(2, 4))
//   //             ],
//   //           ));
//   //     default:
//   //   }
//   //   return Container();
//   // }
//
//   Widget _toolbar() {
//     return widget.isBroadcaster
//         ? Container(
//       alignment: Alignment.bottomCenter,
//       padding: const EdgeInsets.symmetric(vertical: 48),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           RawMaterialButton(
//             onPressed: _onToggleMute,
//             child: Icon(
//               muted ? Icons.mic_off : Icons.mic,
//               color: muted ? Colors.white : Colors.blueAccent,
//               size: 20.0,
//             ),
//             shape: CircleBorder(),
//             elevation: 2.0,
//             fillColor: muted ? Colors.blueAccent : Colors.white,
//             padding: const EdgeInsets.all(12.0),
//           ),
//           RawMaterialButton(
//             onPressed: () => _onCallEnd(context),
//             child: Icon(
//               Icons.call_end,
//               color: Colors.white,
//               size: 35.0,
//             ),
//             shape: CircleBorder(),
//             elevation: 2.0,
//             fillColor: Colors.redAccent,
//             padding: const EdgeInsets.all(15.0),
//           ),
//           RawMaterialButton(
//             onPressed: _onSwitchCamera,
//             child: Icon(
//               Icons.switch_camera,
//               color: Colors.blueAccent,
//               size: 20.0,
//             ),
//             shape: CircleBorder(),
//             elevation: 2.0,
//             fillColor: Colors.white,
//             padding: const EdgeInsets.all(12.0),
//           ),
//           RawMaterialButton(
//             onPressed: _goToChatPage,
//             child: Icon(
//               Icons.message_rounded,
//               color: Colors.blueAccent,
//               size: 20.0,
//             ),
//             shape: CircleBorder(),
//             elevation: 2.0,
//             fillColor: Colors.white,
//             padding: const EdgeInsets.all(12.0),
//           ),
//         ],
//       ),
//     )
//         : Container(
//       alignment: Alignment.bottomCenter,
//       padding: EdgeInsets.only(bottom: 48),
//       child: RawMaterialButton(
//         onPressed: _goToChatPage,
//         child: Icon(
//           Icons.message_rounded,
//           color: Colors.blueAccent,
//           size: 20.0,
//         ),
//         shape: CircleBorder(),
//         elevation: 2.0,
//         fillColor: Colors.white,
//         padding: const EdgeInsets.all(12.0),
//       ),
//     );
//   }
//   void _onToggleMute() {
//     setState(() {
//       muted = !muted;
//     });
//     _engine.muteLocalAudioStream(muted);
//   }
//   void _onSwitchCamera() {
//     _engine.switchCamera();
//   }
//   void _onCallEnd(BuildContext context) {
//     Navigator.pop(context);
//   }
//
//   void _goToChatPage() {
//     // Navigator.of(context).push(
//     //     MaterialPageRoute(
//     //       builder: (context) => RealTimeMessaging(
//     //         channelName: widget.channelName,
//     //         userName: widget.userName,
//     //         isBroadcaster: widget.isBroadcaster,
//     //       ),)
//     // );
//   }
//
//   _renderVideo(user, isScreenSharing) {
//     return AspectRatio(
//       aspectRatio: 16 / 9,
//       child: RtcRemoteView.SurfaceView(
//         uid: myid,
//         channelId: "adminChannel",
//       )
//     );
//   }
// }
