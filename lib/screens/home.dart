import 'package:dictionary_application/screens/bookmarks.dart';
import 'package:dictionary_application/screens/meaning.dart';
// import 'package:dictionary_application/services/get_meaning.dart';
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
  List<Widget> screens = [
    const Home(),
    const Bookmarks(),
  ];
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

  Future<bool> _onWillPop() async {
    // check if the search bar has focus
    if (searchBarFocusNode.hasFocus) {
      // if it does, unfocus it
      setState(() {
        searchBarFocusNode.unfocus();
        _searchController.clear();
        isSearchBarFocused = false;
      });
      // and return false so that the app doesn't close
      return false;
    }
    // if it doesn't, ask the user if they want to exit the app
    return true;
    // return await showDialog(
    //       context: context,
    //       builder: (context) => AlertDialog(
    //         title: const Text("Are you sure?"),
    //         content: const Text("Do you want to exit the app?"),
    //         actions: [
    //           TextButton(
    //             onPressed: () => Navigator.of(context).pop(false),
    //             child: const Text("No"),
    //           ),
    //           TextButton(
    //             onPressed: () => Navigator.of(context).pop(true),
    //             child: const Text("Yes"),
    //           ),
    //         ],
    //       ),
    //     ) ??
    //     false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
            mainAxisSize: MainAxisSize.min,
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
                                    onTap: () {
                                      String word = snapshot.data![index];
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Meaning(
                                            word: word,
                                          ),
                                        ),
                                      );
                                      // Map<String, dynamic> map =
                                      //     await GetMeaning()
                                      //         .getMeaning(snapshot.data![index]);
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) => Meaning(map: map),
                                      //   ),
                                      // );
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 2),
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
      ),
    );
  }
}
