import 'package:flutter/cupertino.dart';

class quizModel {


  late String id;
  late String date;
  late String totalQuestions;
  late String correct;
  late String time;
  late String mode;
  late List<dynamic> mistakes;


  quizModel({
    required this.id,
    required this.date,
    required this.totalQuestions,
    required this.correct,
    required this.time,
    required this.mode,
    required this.mistakes

  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "date": date,
      "totalQuestions": totalQuestions,
      "correct": correct,
      "mode": mode,
      "mistakes": mistakes,
      "time": time,

    };
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date,
    'totalQuestions': totalQuestions,
    'correct': correct,
    'mistakes': mistakes,
    'time': time,
    'mode': mode,

  };

  quizModel.fromSnapshot(snapshot):
        id = snapshot.data()['id'],
        date = snapshot.data()['date'],
        totalQuestions = snapshot.data()['totalQuestions'],
        correct = snapshot.data()['correct'],
        mistakes = snapshot.data()['mistakes'],
        mode = snapshot.data()['mode'],
        time = snapshot.data()['time'];
}
