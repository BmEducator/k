import 'package:flutter/cupertino.dart';

class notificationModel {


  late String message;
  late String timestamp;
  late String status;

  notificationModel({
    required this.message,
    required this.timestamp,
    required this.status,


  });

  Map<String, dynamic> toMap() {
    return {
      "message": message,
      "timestamp": timestamp,
      "status": status,
    };
  }

  Map<String, dynamic> toJson() => {
    'message': message,
    'timestamp': timestamp,
    'status': status,
  };

  notificationModel.fromSnapshot(snapshot):
        message = snapshot.data()['message'],
        timestamp = snapshot.data()['timestamp'],
        status = snapshot.data()['status'];

  notificationModel.fromMap(Map<String,dynamic> data){
    message = data['message'];
    timestamp = data['timestamp'];
    status = data['status'];
}
}
