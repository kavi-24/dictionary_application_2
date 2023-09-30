import 'dart:convert';

import 'package:dictionary_application/screens/meaning_not_found.dart';
import 'package:flutter/material.dart';

import 'api_key.dart';
import 'package:http/http.dart' as http;

class GetMeaning {
  Future<Map<String, dynamic>> getMeaning(
      String text, BuildContext context) async {
    String url =
        "https://www.dictionaryapi.com/api/v3/references/collegiate/json/$text?key=$apiKey";
    http.Response response = await http.get(Uri.parse(url));
    try {
      Map respMap = jsonDecode(response.body)[0];
      String word = respMap["meta"]["id"].replaceAll(RegExp(r':.*'), '');
      String pos = respMap["fl"];

      // sometimes, prs can be null...
      String pronunciation = respMap["hwi"]["prs"] != null
          ? respMap["hwi"]["prs"][0]["mw"]
          : respMap["hwi"]["hw"];

      List<String> meanings = [];
      List<String> examples = [];

      for (var i in respMap["shortdef"]) {
        meanings.add(i.toString());
      }
      List sseq = respMap["def"][0]["sseq"];

      for (var i in sseq) {
        try {
          meanings.add(
            /*
          { <- special char in terms of RegEx
          \{ <- denotes that you have to look for this character
          . <- match any character
          * ? <- occures more than once
          */
            i[0][1]["dt"][0][1].replaceAll(RegExp(r'\{.*?\}'), ''),
          );
          // to remove {} and contents inside, use RegEx (Regular Expression)
        } catch (e) {
          continue;
        }

        try {
          examples.add(
            i[0][1]["dt"][1][1]["t"].replaceAll(RegExp(r'\{.*?\}'), ''),
          );
        } catch (e) {
          continue;
        }
      }
      // if same meanings occur, remove duplicates
      meanings.toSet().toList();
      examples.toSet().toList();
      // Set <- does not contain duplicate elements
      // Order is not maintained.

      if (meanings.isEmpty) {
        meanings.add("No meanings found");
      }
      if (examples.isEmpty) {
        examples.add("No examples found");
      }

      // print("$word $pos $pronunciation $meanings $examples");

      Map<String, dynamic> map = {
        "word": word,
        "pos": pos,
        "pronunciation": pronunciation,
        "meanings": meanings,
        "examples": examples
      };
      return map;
    } catch (e) {
      // "["self","shelf","self-","Guelf","selfie","delf","elf","pelf","selfs","skald","skean","sked","skeds","skeet","skeg","skegs","skei…"
      List<String> words =
          response.body.substring(1, response.body.length - 1).split(",");
      // words = words.map((e) => e.replaceAll("\"", "")).toList();
      Navigator.pop(context); // remove Meaning widget
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MeaningNotFound(word: text, words: words),
        ),
      );
      return {};
    }

    /*
    [{"meta":{"id":"voluminous","uuid":"0d01b967-971f-4ec5-8fe0-10513d29c39b","sort":"220130400","src":"collegiate","section":"alpha","stems":["voluminous","voluminously","voluminousness","voluminousnesses"],"offensive":false},"hwi":{"hw":"vo*lu*mi*nous","prs":[{"mw":"v\u0259-\u02c8l\u00fc-m\u0259-n\u0259s","sound":{"audio":"volumi02","ref":"c","stat":"1"}}]},"fl":"adjective","def":[{"sseq":[[["sense",{"sn":"1 a","dt":[["text","{bc}having or marked by great {a_link|volume} or bulk {bc}{sx|large||} "],["vis",[{"t":"long {wi}voluminous{\/wi} tresses"}]]],"sdsense":{"sd":"also","dt":[["text","{bc}{sx|full||} "],["vis",[{"t":"a {wi}voluminous{\/wi} skirt"}]]]}}],["sense",{"sn":"b","dt":[["text","{bc}{sx|numerous||} "],["vis",[{"t":"trying to keep track of {wi}voluminous{\/wi} slips of paper"}]]]}]],[["sense",{"sn":"2 a","dt":[["text","{bc}filling or capable of filling a large volume or several {a_link|volumes} "],["vis",[{"t":"a {wi}voluminous{\/wi} literature on the subject"}]]]}],["sense",{"sn":"b","dt":[["text","{bc}writing or speaking much or at great length "],["vis",[{"t":"a {wi}voluminous{\/wi} correspondent"}]]]}]],[["sense",{"sn":"3","dt":[["text","{bc}consisting of many folds, coils, or convolutions {bc}{sx|winding|winding:2|}"]]}]]]}],"uros":[{"ure":"vo*lu*mi*nous*ly","fl":"adverb"},{"ure":"vo*lu*mi*nous*ness","fl":"noun"}],"et":[["text","Late Latin {it}voluminosus{\/it}, from Latin {it}volumin-, volumen{\/it}"]],"date":"1611{ds||3||}","shortdef":["having or marked by great volume or bulk : large; also : full","numerous","filling or capable of filling a large volume or several volumes"]}]*/
  }
}

void main(List<String> args) {}
