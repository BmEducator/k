import 'package:flutter/cupertino.dart';

class videoLectureModel {


  late String caption;
  late String url;
  late String thumbnail;
  late String duration;


  videoLectureModel({
    required this.caption,
    required this.url,
    required this.thumbnail,
    required this.duration,

  });

  Map<String, dynamic> toMap() {
    return {
      "caption": caption,
      "url": url,
      "thumbnail": thumbnail,
      "duration": duration,

    };
  }

  Map<String, dynamic> toJson() => {
    'caption': caption,
    'thumbnail': thumbnail,
    'url': url,
    'duration': duration,

  };

  videoLectureModel.fromSnapshot(snapshot):
        caption = snapshot.data()['caption'],
        thumbnail = snapshot.data()['thumbnail'],
        duration = snapshot.data()['duration'],
        url = snapshot.data()['url'];


  videoLectureModel.fromMap(Map<String,dynamic> data){
    caption = data['caption'];
    thumbnail =data['thumbnail'];
    duration = data['duration'];
    url = data['url'];

  }
}
