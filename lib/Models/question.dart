import 'package:flutter/cupertino.dart';

class QuestionModel {


  late String image;
  late String statement;
  late String optionA;
  late String option2;
  late String optionC;
  late String optionD;
  late String answer;

  QuestionModel({
    required this.image,
    required this.statement,
    required this.optionA,
    required this.option2,
    required this.optionC,
    required this.optionD,
    required this.answer

  });

  Map<String, dynamic> toMap() {
    return {
      "statement": statement,
      "image": image,
      "optionA": optionA,
      "option2": option2,
      "optionC": optionC,
      "optionD": optionD,
      "answer": answer,
    };
  }

  Map<String, dynamic> toJson() => {
    'statement': statement,
    'image': image,
    'optionA': optionA,
    'option2': option2,
    'optionC': optionC,
    'optionD': optionD,
    'answer': answer,

  };

  QuestionModel.fromSnapshot(snapshot):
        statement = snapshot.data()['statement'],
        image = snapshot.data()['image'],
        optionA = snapshot.data()['optionA'],
        option2 = snapshot.data()['option2'],
        optionC = snapshot.data()['optionC'],
        optionD = snapshot.data()['optionD'],
        answer = snapshot.data()['answer'];

  QuestionModel.fromMap(Map<String,dynamic> data){
    statement = data['statement'];
    image = data['image'];
    optionA = data['optionA'];
    option2 = data['option2'];
    optionC = data['optionC'];
    optionD = data['optionD'];
    answer = data['answer'];
  }
}
