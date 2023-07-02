import 'package:flutter/cupertino.dart';

class quizModelForExam {


  late String id;
  late String date;
  late String totalQuestions;
  late String correct;
  late String time;
  late List<dynamic> mistakes;
  late List<dynamic> selectedOptions;


  quizModelForExam({
    required this.id,
    required this.date,
    required this.totalQuestions,
    required this.correct,
    required this.time,
    required this.mistakes,
    required this.selectedOptions

  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "date": date,
      "totalQuestions": totalQuestions,
      "correct": correct,
      "mistakes": mistakes,
      "time": time,
      "selectedOptions": selectedOptions,

    };
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date,
    'totalQuestions': totalQuestions,
    'correct': correct,
    'mistakes': mistakes,
    'time': time,
    'selectedOptions': selectedOptions,

  };

  quizModelForExam.fromSnapshot(snapshot):
        id = snapshot.data()['id'],
        date = snapshot.data()['date'],
        totalQuestions = snapshot.data()['totalQuestions'],
        correct = snapshot.data()['correct'],
        mistakes = snapshot.data()['mistakes'],
        selectedOptions = snapshot.data()['selectedOptions'],
        time = snapshot.data()['time'];
}
