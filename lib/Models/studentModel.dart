import 'package:flutter/cupertino.dart';

class studentModel {


  late String name;
  late String id;
  late String contact;
  late String profileImage;
  late String dateofBirth;
  late String dni;
  late String email;
  late String address;
  late String education;
  late String language;
  late String accessDate;
  late String translation;
  late String token;
  late String mode;
  late String revise;
  late String licenseType;


  studentModel({
    required this.id,
    required this.name,
    required this.contact,
    required this.profileImage,
    required this.dateofBirth,
    required this.email,
    required this.dni,
    required this.token,
    required this.address,
    required this.education,
    required this.language,
    required this.translation,
    required this.accessDate,
    required this.mode,
    required this.revise,
    required this.licenseType,
  });

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "id": id,
      "contact": contact,
      "profileImage": profileImage,
      "dateofBirth": dateofBirth,
      "email":email ,
      "education": education,
      "language": language,
      "address": address,
      "dni": dni,
      "translation": translation,
      "accessDate": accessDate,
      "mode": mode,
      "revise": revise,
      "token": token,
      "licenseType": licenseType,

    };
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'id': id,
    'contact': contact,
    'profileImage': profileImage,
    'dateofBirth': dateofBirth,
    'email': email,
    'education': education,
    'dni': dni,
    'address': address,
    'language': language,
    'translation': translation,
    'token': token,
    'mode': mode,
    'accessDate': accessDate,
    'revise': revise,
    'licenseType': licenseType,

  };

  studentModel.fromSnapshot(snapshot):
        id = snapshot.data()['id'],
        name = snapshot.data()['name'],
        contact = snapshot.data()['contact'],
        profileImage = snapshot.data()['profileImage'],
        email = snapshot.data()['email'],
        dateofBirth = snapshot.data()['dateofBirth'],
        language = snapshot.data()['language'],
        address = snapshot.data()['address'],
        translation = snapshot.data()['translation'],
        education = snapshot.data()['education'],
        accessDate = snapshot.data()['accessDate'],
        token = snapshot.data()['token'],
        licenseType = snapshot.data()['licenseType'],
        revise = snapshot.data()['revise'],
        dni = snapshot.data()['dni'],
       mode = snapshot.data()['mode'];


  studentModel.fromMap(Map<String,dynamic> data){
    id = data['id'];
    name = data['name'];
    contact =data['contact'];
    profileImage = data['profileImage'];
    email = data['email'];
    dateofBirth = data['dateofBirth'];
    language = data['language'];
    address = data['address'];
    translation = data['translation'];
    education = data['education'];
    accessDate = data['accessDate'];
    token = data['token'];
    revise = data['revise'];
    licenseType = data['licenseType'];
    mode = data['mode'];
    dni = data['dni'];}
}
