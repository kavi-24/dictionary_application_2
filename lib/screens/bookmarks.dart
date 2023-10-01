import 'package:dictionary_application/screens/home.dart';
import 'package:dictionary_application/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Bookmarks extends StatefulWidget {
  const Bookmarks({super.key});

  @override
  State<Bookmarks> createState() => _BookmarksState();
}

class _BookmarksState extends State<Bookmarks> {
  int index = 1;
  List<Widget> screens = [const Home(), const Bookmarks()];
  // List<Map<String, dynamic>> dbData = [];
  DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  void initState() {
    // readDBData();
    super.initState();
  }

  // void readDBData() async {
  //   List<Map<String, dynamic>> data = await databaseHelper.readData();
  //   setState(() {
  //     dbData = data;
  //   });
  // }

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
              child: Consumer<DatabaseHelper>(
                builder: (context, dbProvider, child) {
                  return FutureBuilder(
                    future: dbProvider.readData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.all(10),
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        snapshot.data![index]["word"],
                                        style: const TextStyle(
                                          fontSize: 30,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          // remove data
                                          dbProvider.deleteData(
                                              snapshot.data![index]["word"]);
                                        },
                                        child: const BookmarkRemove(),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        snapshot.data![index]["pos"],
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                      Text(
                                        "/${snapshot.data![index]["pronunciation"]}/",
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
                                  Text(formatStr(snapshot.data![index]
                                          ["meanings"]
                                      .toString())),
                                  const SizedBox(height: 5),
                                  const Text(
                                    "Example(s)",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(formatStr(snapshot.data![index]
                                          ["examples"]
                                      .toString())),
                                ],
                              ),
                            );
                          },
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
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

class BookmarkRemove extends StatelessWidget {
  const BookmarkRemove({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Icon(Icons.bookmark),
        Positioned(
          right: 1,
          bottom: 7,
          child: Container(
            padding: const EdgeInsets.all(1),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Text(
              "-",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
