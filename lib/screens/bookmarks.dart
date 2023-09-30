import 'package:dictionary_application/screens/home.dart';
import 'package:dictionary_application/services/database.dart';
import 'package:flutter/material.dart';

class Bookmarks extends StatefulWidget {
  const Bookmarks({super.key});

  @override
  State<Bookmarks> createState() => _BookmarksState();
}

class _BookmarksState extends State<Bookmarks> {
  int index = 1;
  List<Widget> screens = [const Home(), const Bookmarks()];
  List<Map<String, dynamic>> dbData = [];

  @override
  void initState() {
    readDBData();
    super.initState();
  }

  void readDBData() async {
    List<Map<String, dynamic>> data = await DatabaseHelper().readData();
    setState(() {
      dbData = data;
    });
  }

  String format(List<String> list) {
    String ret = "";
    for (String i in list) {
      ret += "-\t\t\t\t$i\n";
    }
    return ret;
  }

  String formatStr(String str) {
    return str.substring(1, str.length - 1);
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
            const SizedBox(height: 10),
            Flexible(
              child: ListView.builder(
                itemCount: dbData.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    /*
                    Word (big size)
                    Row -> pos and pronun
                    Meanings
                    Examples
                    */
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dbData[index]["word"],
                          style: const TextStyle(
                            fontSize: 30,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              dbData[index]["pos"],
                              style: const TextStyle(
                                fontSize: 17,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            Text(
                              "/${dbData[index]["pronunciation"]}/",
                              style: const TextStyle(
                                fontSize: 17,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Meaning(s)",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        Text(formatStr(dbData[index]["meanings"].toString())),
                        const SizedBox(height: 5),
                        const Text(
                          "Example(s)",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        Text(formatStr(dbData[index]["examples"].toString())),
                      ],
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
