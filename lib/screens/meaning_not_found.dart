import 'package:dictionary_application/screens/bookmarks.dart';
import 'package:dictionary_application/screens/home.dart';
import 'package:dictionary_application/screens/meaning.dart';
import 'package:flutter/material.dart';

class MeaningNotFound extends StatefulWidget {
  const MeaningNotFound({super.key, required this.words, required this.word});
  final String word;
  final List<String> words;

  @override
  State<MeaningNotFound> createState() => _MeaningNotFoundState();
}

class _MeaningNotFoundState extends State<MeaningNotFound> {
  int index = 0;
  List<Widget> screens = [
    const Home(),
    const Bookmarks(),
  ];
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    setState(() {
      textEditingController.text =
          "We could not find the meaning of the word ${widget.word} in our API. Try some other similar words";
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
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
        currentIndex: index,
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
                ],
              ),
            ),
            TextField(
              enabled: false,
              controller: textEditingController,
              textAlign: TextAlign.center,
              minLines: 2,
              maxLines: 3,
            ),
            Flexible(
              child: ListView.builder(
                itemCount: widget.words.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      String word = widget.words[index];
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Meaning(
                            word: word,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      padding:
                          const EdgeInsets.all(8).copyWith(top: 10, bottom: 10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Text(
                        widget.words[index].toString().replaceAll("\"", ""),
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
