import 'package:dictionary_application/screens/bookmarks.dart';
import 'package:dictionary_application/screens/home.dart';
import 'package:dictionary_application/services/database.dart';
import 'package:dictionary_application/services/get_meaning.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:skeletons/skeletons.dart';

class Meaning extends StatefulWidget {
  const Meaning({super.key, required this.word});
  final String word;

  @override
  State<Meaning> createState() => _MeaningState();
}

/*
word
(small case) pronunciation
(small case) pos

list- meanings
list- examples
*/

class _MeaningState extends State<Meaning> {
  FlutterTts flutterTts = FlutterTts();
  int index = 0;
  List<Widget> screens = const [Home(), Bookmarks()];
  DatabaseHelper database = DatabaseHelper();
  Map<String, dynamic> map = {};
  bool isLoaded = false;

  @override
  void initState() {
    getMeaning();
    super.initState();
  }

  void getMeaning() async {
    Map<String, dynamic> mapp =
        await GetMeaning().getMeaning(widget.word, context);
    // if (mapp.isEmpty) {
    //   dispose();
    // } else {
    setState(() {
      map = mapp;
      isLoaded = true;
    });
    // }
  }

  @override
  void dispose() {
    super.dispose();
  }

  String format(List<String> list) {
    String ret = "";
    for (String i in list) {
      ret += "-\t\t\t\t$i\n";
    }
    return ret;
  }

  // tts -> text to speech
  Future speak() async {
    await flutterTts.speak(map["word"]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (value) {
          if (value != index) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => screens[value],
              ),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: "Bookmarks",
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade400,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "DICTIONARY",
                          style: TextStyle(
                            fontFamily: "Times New Roman",
                            fontSize: 25,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  isLoaded
                      ? Container(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                map["word"],
                                style: const TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SkeletonLine(
                            style: SkeletonLineStyle(
                              alignment: Alignment.center,
                              width: 200,
                              height: 50,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                  const SizedBox(height: 20),
                  isLoaded
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              
                              map["pronunciation"] != '' ? "/${map["pronunciation"]}/" : "",
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        )
                      : const SkeletonLine(
                          style: SkeletonLineStyle(
                            alignment: Alignment.center,
                            width: 100,
                          ),
                        ),
                  const SizedBox(height: 10),
                  isLoaded
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              map["pos"],
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        )
                      : const SkeletonLine(
                          style: SkeletonLineStyle(
                            alignment: Alignment.center,
                            width: 100,
                          ),
                        ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: IconButton(
                          onPressed: () {
                            speak();
                          },
                          icon: const Icon(
                            Icons.volume_up,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: IconButton(
                          onPressed: () {
                            database.insertData(map);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: const Duration(milliseconds: 1500),
                                content: Center(
                                  child:
                                      Text('${map["word"]} added to bookmarks'),
                                ),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.bookmark_add,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // isLoaded
                  //     ? Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //         children: [
                  //           Container(
                  //             decoration: BoxDecoration(
                  //               color: Colors.white.withOpacity(0.1),
                  //               borderRadius: BorderRadius.circular(5),
                  //             ),
                  //             child: IconButton(
                  //               onPressed: () {
                  //                 speak();
                  //               },
                  //               icon: const Icon(
                  //                 Icons.volume_up,
                  //                 color: Colors.white,
                  //               ),
                  //             ),
                  //           ),
                  //           const SizedBox(width: 20),
                  //           Container(
                  //             decoration: BoxDecoration(
                  //               color: Colors.white.withOpacity(0.1),
                  //               borderRadius: BorderRadius.circular(5),
                  //             ),
                  //             child: IconButton(
                  //               onPressed: () {
                  //                 database.insertData(map);
                  //                 ScaffoldMessenger.of(context).showSnackBar(
                  //                   SnackBar(
                  //                     duration:
                  //                         const Duration(milliseconds: 1500),
                  //                     content: Center(
                  //                       child: Text(
                  //                           '${map["word"]} added to bookmarks'),
                  //                     ),
                  //                   ),
                  //                 );
                  //               },
                  //               icon: const Icon(
                  //                 Icons.bookmark_add,
                  //                 color: Colors.white,
                  //               ),
                  //             ),
                  //           ),
                  //         ],
                  //       )
                  //     : SkeletonListTile(),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            Flexible(
              child: isLoaded
                  ? SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Meaning(s)",
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.deepPurple.shade400,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              format(map["meanings"]),
                              style: const TextStyle(
                                fontSize: 17.5,
                              ),
                            ),
                            Text(
                              "Example(s)",
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.deepPurple.shade400,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              format(map["examples"]),
                              style: const TextStyle(
                                fontSize: 17.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SkeletonParagraph(),
                        SkeletonParagraph(),
                      ],
                    ),
            )
          ],
        ),
      ),
    );
  }
}
