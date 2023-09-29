import 'package:dictionary_application/screens/bookmarks.dart';
import 'package:dictionary_application/screens/meaning.dart';
import 'package:dictionary_application/services/get_meaning.dart';
import 'package:dictionary_application/services/search_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int index = 0;
  List<Widget> screens = [Home(), Bookmarks()];
  final TextEditingController _searchController = TextEditingController();
  List<String> words = [];
  FocusNode searchBarFocusNode = FocusNode();
  bool isSearchBarFocused = false;

  @override
  void initState() {
    _searchController.addListener(_onSearchBarFocus);
    super.initState();
  }

  void _onSearchBarFocus() async {
    setState(() {
      isSearchBarFocused = searchBarFocusNode.hasFocus;
    });
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
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 50,
                        child: TextField(
                          focusNode: searchBarFocusNode,
                          controller: _searchController,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                          ),
                          decoration: const InputDecoration(
                            hintText: "Search...",
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontStyle: FontStyle.italic,
                            ),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Container(
            //   color: Colors.grey.shade200,
            //   child: const SizedBox(
            //     height: 20,
            //   ),
            // ),
            isSearchBarFocused && _searchController.text != ""
                ? Flexible(
                    child: Container(
                      color: Colors.grey.shade200,
                      child: FutureBuilder(
                        // initially no text
                        // so, check if focus on the search bar
                        future:
                            SearchWords().searchWords(_searchController.text),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData)
                          // check if the future data is received fully
                          {
                            return ListView.builder(
                              itemCount: snapshot.data!
                                  .length, // the array/list received from future -> snapshot
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () async {
                                    Map<String, dynamic> map =
                                        await GetMeaning()
                                            .getMeaning(snapshot.data![index]);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Meaning(map: map),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 2),
                                    padding: const EdgeInsets.all(8)
                                        .copyWith(top: 10, bottom: 10),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    child: Text(
                                      snapshot.data![index].toString(),
                                      style: const TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            return SpinKitRipple(
                              color: Colors.deepPurple.shade300,
                            );
                          }
                        },
                      ),
                    ),
                  )
                : Flexible(
                    child: Center(
                      child: Text(
                        "Use the search bar",
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
