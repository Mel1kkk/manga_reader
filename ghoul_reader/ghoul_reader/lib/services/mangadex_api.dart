import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ghoul_reader/models/manga_reader.dart';

class MangadexApi {
  static Future<List<MangaReader>> fetchManga(String chapterId) async {
    String? apiUrl = dotenv.env['API_BASE_URL'];
    String? authToken = dotenv.env['AUTH_TOKEN'];
    List<MangaReader> mangaReader = [];

    var url = Uri.https('$apiUrl', 'at-home/server/${chapterId}');

    try {
      var response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $authToken",
          "Content-Type": "application/json",
        },        
      );

      if(response.statusCode == 200) {
        print('Manga Chapters are fetched');
        final responseBody = jsonDecode(response.body);
        
        String baseUrl = responseBody["baseUrl"] ?? "No url";
        String hash = responseBody["chapter"]["hash"] ?? "No hash";
        print('$baseUrl + $hash');
        List<String> mangaPages = List<String>.from(responseBody["chapter"]["data"]);
        List<String> finalMangaUrl = [];

        for(int i = 0; i < mangaPages.length; i++) {
          String tempUrl = '${baseUrl}/data/${hash}/${mangaPages[i]}';
          finalMangaUrl.add(tempUrl);
        }

        mangaReader.add(MangaReader(mangaPagesUrl: finalMangaUrl));
      } else {
        print('error code - ${response.statusCode}, error body: ${response.body}');
      }

    } catch(e) {
      print('Error - $e');

    }

    return mangaReader; 
  }
}