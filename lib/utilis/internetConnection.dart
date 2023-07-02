// import 'package:connectivity/connectivity.dart';
//
// class InternetConnection{
//   Future<bool> checkConnection() async{
//
//     final r = await Connectivity().checkConnectivity();
//     switch(r) {
//       case ConnectivityResult.wifi:
//         return true;
//       case ConnectivityResult.mobile:
//         return true;
//       case ConnectivityResult.none:
//         return false;
//       default:
//         return true;
//     }
//
//   }
//   Future<bool> checkConnect(ConnectivityResult r) async{
//
//     switch(r) {
//       case ConnectivityResult.wifi:
//         return true;
//       case ConnectivityResult.mobile:
//         return true;
//       case ConnectivityResult.none:
//         return false;
//       default:
//         return true;
//     }
//   }
// }