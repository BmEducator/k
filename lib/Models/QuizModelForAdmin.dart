
import 'package:bmeducators/Models/question.dart';
import 'package:bmeducators/Models/studentModel.dart';
import 'package:flutter/cupertino.dart';

import 'QuizModel.dart';

class quizModelForAdmin {


  late String id;
  late String mode;
  late String timestamp;
  late List<dynamic> questions;
  late List<dynamic> students;


  quizModelForAdmin({
    required this.id,
    required this.questions,
    required this.mode,
    required this.students,
    required this.timestamp,

  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "questions": questions.map((e) => e.toMap()).toList(),
      "mode": mode,
      "timestamp": timestamp,
      "students": students.map((e) => e.toMap()).toList(),


    };
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'questions':questions,
    'mode': mode,
    'students': students,
    'timestamp': timestamp,

  };


  quizModelForAdmin.fromMap(Map<String,dynamic> data){
  id = data['id'];
  mode = data['mode'];
  timestamp = data['timestamp'];
  questions = data['questions'].map<QuestionModel>((mapString) => QuestionModel.fromMap(mapString)).toList();
  students = data['students'].map<studentModel>((mapString) => QuestionModel.fromMap(mapString)).toList();
  }

  //
  // quizToPerformModel.fromMap(snapshot):
  //       id = snapshot.data()['id'],
  //       mode = snapshot.data()['mode'],
  //       questions = snapshot.data()['questions'].map<QuestionModel>((mapString) => QuestionModel.fromSnapshot(mapString)).toList();
}
