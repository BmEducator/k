import 'package:flutter/cupertino.dart';

class QuestionModel {


  late String Message;
  late String time;
  late String status;

  QuestionModel({
    required this.Message,
    required this.time,
    required this.status,


  });

  Map<String, dynamic> toMap() {
    return {
      "Message": Message,
      "status": status,
      "time": time,

    };
  }

  Map<String, dynamic> toJson() => {
    'Message': Message,
    'status': status,
    'time': time,
  };

  QuestionModel.fromSnapshot(snapshot):
        Message = snapshot.data()['Message'],
        status = snapshot.data()['status'],

        time = snapshot.data()['time'];

  QuestionModel.fromMap(Map<String,dynamic> data){
    Message = data['Message'];
    status = data['status'];
    time = data['time'];

  }
}
