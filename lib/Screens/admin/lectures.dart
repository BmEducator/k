import 'package:flutter/material.dart';

class lectures extends StatefulWidget {
  const lectures({Key? key}) : super(key: key);

  @override
  State<lectures> createState() => _lecturesState();
}

class _lecturesState extends State<lectures> {

  var videosList = [
    { 'name':'first Video',
      'url':'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      'thum':'https://i1.sndcdn.com/avatars-mSjabGhOFCnzsPaF-EzYUeQ-t240x240.jpg'
    },
    { 'name':'Secod Video',
      'url':'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      'thum':'https://i1.sndcdn.com/avatars-mSjabGhOFCnzsPaF-EzYUeQ-t240x240.jpg'
    },

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: Column(
          children: [
            SizedBox(height: 129,),
            GridView.count(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              scrollDirection: Axis.vertical,
              crossAxisCount: 4,
              childAspectRatio: (1 / 1.2),
              crossAxisSpacing: 20,
              mainAxisSpacing: 10,
              children: List.generate(
                videosList.length ,
                    (int index) {
                  return Image.network(videosList[index]['thum']!);
                },
              ),
            )
          ],
        )


    );
  }
}
