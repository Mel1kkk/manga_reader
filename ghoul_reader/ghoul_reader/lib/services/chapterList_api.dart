import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ghoul_reader/models/chapter.dart';

class ChapterApi {
  static Future<List<Chapter>> fetchChapters() async {
    String? apiUrl = dotenv.env['API_BASE_URL'];
    String? authToken = dotenv.env['AUTH_TOKEN'];
    String mangaId = "6a1d1cb1-ecd5-40d9-89ff-9d88e40b136b";

    int limit = 100;
    int offset = 0;
    List<Chapter> allChapters = [];

    while (true) {
      var url = Uri.https('$apiUrl', 'chapter', {
        'manga': mangaId,
        'limit': limit.toString(),
        'offset': offset.toString(),
        'translatedLanguage[]': 'en',
        'order[chapter]': 'asc',
        'uploader': 'bddd1e55-fabe-4ac9-b251-107f6355d11c',
      });

      try {
        var response = await http.get(
          url,
          headers: {
            "Authorization": "Bearer $authToken",
            "Content-Type": "application/json",
          },
        );

        if (response.statusCode == 200) {
          print('Data is fetched');
          final responseBody = jsonDecode(response.body);
          final List<dynamic> chapterList = responseBody['data'];

          if (chapterList.isEmpty) break;

          for (int i = 0; i < chapterList.length; i++) {
            var chapter = chapterList[i];

            String title = chapter["attributes"]["title"] ?? "No name";
            String chapterNum = chapter["attributes"]["chapter"] ?? "?";
            String chapterId = chapter["id"] ?? "No Id";

            allChapters.add(Chapter(
                title: title,
                chapterNum: chapterNum, 
                chapterId: chapterId,
              ));
          }

          offset += chapterList.length;
        } else {
          print('Error Status: ${response.statusCode}, body: ${response.body}');
          break;
        }
      } catch (e) {
        print('$e');
        break;
      }
    }

    return allChapters;
  }
}
