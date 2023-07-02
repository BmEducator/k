import 'package:bmeducators/Models/question.dart';
import 'package:bmeducators/Models/videoLectureModel.dart';
import 'package:flutter/cupertino.dart';

import 'QuizModel.dart';

class progressQuizModel {

  late List<dynamic> quizes;



  progressQuizModel({
    required this.quizes,

  });

  Map<String, dynamic> toMap() {
    return {
      "quizes": quizes.map((e) => e.toMap()).toList(),


    };
  }

  Map<String, dynamic> toJson() => {
    'quizes':quizes,
  };


  progressQuizModel.fromMap(Map<String,dynamic> data){
    quizes = data['quizes'].map<videoLectureModel>((mapString) => videoLectureModel.fromMap(mapString)).toList();
  }


 }
