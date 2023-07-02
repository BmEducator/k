// import 'package:flutter/material.dart';
// import 'package:googleapis/youtube/v3.dart' as YT;
//
// import 'package:google_sign_in/google_sign_in.dart';
//
// class googleSignInScreen extends StatefulWidget {
//   const googleSignInScreen({Key? key}) : super(key: key);
//
//   @override
//   State<googleSignInScreen> createState() => _googleSignInScreenState();
// }
//
// class _googleSignInScreenState extends State<googleSignInScreen> {
//   GoogleSignIn _googleSignIn = GoogleSignIn(
//       scopes: <String>[
//         YT.YouTubeApi.youtubeUploadScope,
//         YT.YouTubeApi.youtubeReadonlyScope
//       ]
//   );
//   late GoogleSignInAccount? _currentUser;
//   late Future<YT.Video> videoInsertRequest;
//   List<Widget> widgetList = [];
//   List<String> id= [];
//
//   @override
//   void initState() {
//     super.initState();
//     _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
//       setState(() {
//         _currentUser = account;
//       });
//     });
//     _googleSignIn.signInSilently();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: ConstrainedBox(
//           constraints: BoxConstraints.expand(),
//           child: _BuildBody(),
//         ),
//     );
//   }
//   Widget _BuildBody(){
//     GoogleSignInAccount? user = _currentUser;
//     if(user != null) return Column();
//     return Column();
// /   }
// }
