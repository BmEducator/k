import 'package:bmeducators/Models/videoLectureModel.dart';
import 'package:bmeducators/utilis/videoPlayerFromUrl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';


import '../Models/videoListModel.dart';
import '../utilis/videos_Lecture_Scree.dart';
import 'customVideoPlayerScree.dart';

class Video_Lectures_students extends StatefulWidget {
  const Video_Lectures_students({Key? key}) : super(key: key);

  @override
  State<Video_Lectures_students> createState() => _Video_Lectures_studentsState();
}

class _Video_Lectures_studentsState extends State<Video_Lectures_students> {

  List<videoLectureModel> videosList = [] ;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getlecture();
    String url = "https://www.youtube.com/watch?v=YE7VzlLtp-4";


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        body:SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: ClampingScrollPhysics(),
          child: SafeArea(
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(onPressed: () {
                        Navigator.pop(context);
                      },
                          icon: const Icon(
                            Icons.arrow_back_ios, color: Colors.blue,)),
                    ],
                  ),
                ),

                Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    padding: const EdgeInsets.fromLTRB(20, 0, 10, 4),
                    child:FittedBox(
                      child: Text(
                        "Video Lectures",
                        style: const TextStyle(
                            fontFamily: "Poppins"),
                      ),
                    )
                ),

                SizedBox(height: 10,),

               !isLoading?
               SizedBox(
                 child: AnimationLimiter(
                   child: ListView.builder(
                     shrinkWrap: true,
                     physics: ClampingScrollPhysics(),
                     scrollDirection: Axis.vertical,
                     padding: const EdgeInsets.symmetric(horizontal: 20),
                     itemCount:videosList.length,
                     itemBuilder: (BuildContext context, int i) {
                       return AnimationConfiguration.staggeredList(
                         position: i,
                         duration: const Duration(milliseconds: 675),
                         child: SlideAnimation(
                           verticalOffset: 54.0,
                           child: FadeInAnimation(
                               child:InkWell(
                                 onTap: (){

                                   Navigator.of(context).push(
                                       MaterialPageRoute(
                                           builder: (context) =>
                                               videoLectureScreen(url: videosList[i].url,)));
                                 },
                                 child: Padding(
                                   padding: const EdgeInsets.only(top: 20),
                                   child: Material(
                                     borderRadius: BorderRadius.circular(10),
                                     clipBehavior: Clip.antiAlias,
                                     elevation: 5,
                                     child: Container(
                                       height: MediaQuery.of(context).size.height*0.12,

                                       child: Row(
                                         children: [
                                           Stack(
                                             alignment: Alignment.center,
                                             children: [
                                               Image.network(videosList[i].thumbnail,
                                                 width: MediaQuery.of(context).size.width * 0.35,
                                                 height: MediaQuery.of(context).size.height*0.12,
                                                 fit: BoxFit.cover,
                                                 errorBuilder:(BuildContext context,Object exception,StackTrace? stacktrace){
                                                   return Padding(
                                                     padding: const EdgeInsets.only(bottom: 1),
                                                     child: Center(
                                                         child:CircularProgressIndicator()
                                                     ),
                                                   );
                                                 },
                                               ),
                                               Icon(Icons.play_arrow,color: Colors.grey[100],size: 50,)
                                             ],
                                           ),
                                           Padding(
                                             padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                                             child:Column(
                                               crossAxisAlignment: CrossAxisAlignment.start,
                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                               children: [
                                                 SizedBox(
                                                     width:MediaQuery.of(context).size.width*0.5,
                                                     child: Text( videosList[i].caption,maxLines: 3,style: TextStyle(fontFamily: "PoppinRegular" ,fontSize: 12,),)),
                                                 Container(
                                                   width: MediaQuery.of(context).size.width * 0.12,
                                                   padding: EdgeInsets.symmetric(horizontal: 5),
                                                   color: Colors.black.withOpacity(0.5),
                                                   child: FittedBox(child: Text(videosList[i].duration,maxLines: 2,style: TextStyle(color: Colors.white,fontFamily: "PoppinRegular"),)),
                                                 ),
                                               ],
                                             )
                                           )
                                         ],
                                       ),
                                     ),
                                   ),
                                 ),
                               )


                           ),
                         ),
                       );
                     },
                   ),
                 ),
               )
                   :Container
                 (
                 width: MediaQuery.of(context).size.width,
                 height: MediaQuery.of(context).size.height*0.4,
                 color: Colors.white,
                 child: Center(
                     child: LoadingAnimationWidget.discreteCircle(
                       color: Colors.lightBlueAccent,
                       size: 50,
                     )),
               ),

      ],
            ),),
        )

    );
  }


  Future<void> getlecture() async {
    isLoading = true;
    setState(() {

    });


    await FirebaseFirestore.instance.collection("admin")
        .doc(
        "data").collection("videos")
        .doc("lecture").collection("all").get(GetOptions(source: Source.server)).then((value) => {
      value.docs.forEach((element) {
        videoListModel q = videoListModel(
            videos: element['videos']);

        q.videos.forEach((element) {
          videoLectureModel l = videoLectureModel(
            caption: element['caption'],
            url: element['url'],
            thumbnail: element['thumbnail'],
            duration: element['duration'],);
          videosList.add(l);
        });
      })});

    setState(() {
       isLoading =false;
    });

  }
  Future<void> getlectures() async {
    isLoading = true;
    setState(() {

    });
    var data =  await FirebaseFirestore.instance.collection("admin").doc(
        "data").collection("videos")
        .doc("lecture").collection("all")
        .get(const GetOptions(source: Source.server));

    if (data.docs.isNotEmpty) {
      print("exisr");
      videosList =
          List.from(data.docs.map((doc) => videoLectureModel.fromSnapshot(doc)));

      setState(() {
        isLoading = false;
        print(videosList.length);
      });
    }
    else{
      isLoading = false;
      setState(() {

      });
    }
  }
}
