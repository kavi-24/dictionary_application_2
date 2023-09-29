import 'dart:convert';

import 'package:http/http.dart' as http;

class SearchWords {
  // return a few words
  // from online API
  // Datamuse

  Future<List<String>> searchWords(String text) async {
    String url = "https://api.datamuse.com/words?sp=$text*&max=30";
    http.Response response = await http.get(Uri.parse(url));
    /*
     [{"word":"up","score":64659},{"word":"upon","score":4144},{"word":"upset","score":2675},{"word":"uphold","score":1960},{"word":"upfront","score":1695},{"word":"update","score":1672},{"word":"upend","score":1198},{"word":"upheaval","score":1071},{"word":"upgrade","score":1067},{"word":"upbeat","score":952}]
    */
    // response.body -> string
    // convert it to map
    List maps = jsonDecode(response.body);
    List<String> words = [];
    for (Map i in maps) {
      words.add(i["word"]);
    }
    return words;
  }
}

void main() {
  SearchWords().searchWords("up");
}
