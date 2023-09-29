import 'package:dictionary_application/screens/bookmarks.dart';
import 'package:dictionary_application/screens/home.dart';
import 'package:dictionary_application/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Meaning extends StatefulWidget {
  const Meaning({super.key, required this.map});
  final Map<String, dynamic> map;

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
  List<Widget> screens = [Home(), Bookmarks()];
  DatabaseHelper database = DatabaseHelper();

  String format(List<String> list) {
    String ret = "";
    for (String i in list) {
      ret += "-\t\t\t\t$i\n";
    }
    return ret;
  }

  // tts -> text to speech
  Future speak() async {
    await flutterTts.speak(widget.map["word"]);
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
        items: [
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
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          widget.map["word"],
                          style: const TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "/${widget.map["pronunciation"]}/",
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        widget.map["pos"],
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
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
                            database.insertData(widget.map);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: const Duration(milliseconds: 1500),
                                content: Center(
                                  child: Text(
                                      '${widget.map["word"]} added to bookmarks'),
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
                  const SizedBox(height: 10),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
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
                        format(widget.map["meanings"]),
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
                        format(widget.map["examples"]),
                        style: const TextStyle(
                          fontSize: 17.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
