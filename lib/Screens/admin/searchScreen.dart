import 'package:bmeducators/Models/question.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class searchScreen extends StatefulWidget {
  const searchScreen({Key? key}) : super(key: key);

  @override
  State<searchScreen> createState() => _searchScreenState();
}

class _searchScreenState extends State<searchScreen> {
  late List<QuestionModel> questionList;

  @override
  void initState() {
    super.initState();
    getQuestions();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.06,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(50, 0, 20, 5),
                child: Autocomplete<QuestionModel>(
                  optionsMaxHeight: 10,
                  optionsViewBuilder: (context, Function onSelected,
                      Iterable<QuestionModel> options) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        elevation: 10,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          width: MediaQuery
                              .of(context)
                              .size
                              .width - 70,
                          child: ListView.separated(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              QuestionModel option = options.elementAt(index);
                              return ListTile(
                                title: Text(
                                option.statement,
                                  style: const TextStyle(
                                      fontFamily: "PoppinRegular"),
                                ),
                                subtitle: Text("dsfdsf"),
                                onTap: () {

                                },
                              );
                            },
                            separatorBuilder: (context, index) =>
                            const Divider(
                              height: 0,
                            ),
                            itemCount: options.length,
                          ),
                        ),
                      ),
                    );
                  },
                  onSelected: (selectedString) {
                    print(selectedString);
                  },
                  optionsBuilder: (TextEditingValue texteditingvalue) {
                    if (texteditingvalue.text.isEmpty) {
                      return const Iterable<QuestionModel>.empty();
                    } else {
                      return questionList.where((element) =>
                          element.statement.toLowerCase().contains(
                              texteditingvalue.text.toLowerCase())).toList();
                    }
                  },
                  fieldViewBuilder:
                      (context, controller, focusmode, onEditingComplete) {
                    return TextField(
                      onTapOutside: (p){
                        controller.text = "";
                      },
                      onTap: (){
                        // getQuestions()

                      },
                      onChanged: (s) {},
                      style: TextStyle(
                          fontFamily: "PoppinRegular", color: Colors.grey[600]),
                      controller: controller,
                      focusNode: focusmode,
                      onEditingComplete: onEditingComplete,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 20),
                          suffixIcon: IconButton(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            onPressed: () {},
                            icon: const Icon(Icons.search_outlined),
                          ),
                          label: const Text(
                            "Search",
                            style: TextStyle(
                                color: Colors.grey,
                                fontFamily: "PoppinRegular"),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                          )),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }

  Future<void> getQuestions() async {
    var data = await FirebaseFirestore.instance
        .collection('questions')
        .get(const GetOptions(source: Source.server));

    if (data.docs.isNotEmpty) {
      print("exisr");
      setState(() {
        questionList =
            List.from(data.docs.map((doc) => QuestionModel.fromSnapshot(doc)));
        // isEndLoading = true;
        print(questionList[0].statement);
      });
    }
  }
}
