import 'package:bmeducators/Models/question.dart';
import 'package:bmeducators/Models/videoLectureModel.dart';
import 'package:flutter/cupertino.dart';

import 'QuizModel.dart';

class videoListModel {

  late List<dynamic> videos;



  videoListModel({
    required this.videos,

  });

  Map<String, dynamic> toMap() {
    return {
      "videos": videos.map((e) => e.toMap()).toList(),


    };
  }

  Map<String, dynamic> toJson() => {
    'videos':videos,
  };


  videoListModel.fromMap(Map<String,dynamic> data){
    videos = data['videos'].map<videoLectureModel>((mapString) => videoLectureModel.fromMap(mapString)).toList();
  }

  //
  // quizToPerformModel.fromMap(snapshot):
  //       id = snapshot.data()['id'],
  //       mode = snapshot.data()['mode'],
  //       questions = snapshot.data()['questions'].map<QuestionModel>((mapString) => QuestionModel.fromSnapshot(mapString)).toList();
}
