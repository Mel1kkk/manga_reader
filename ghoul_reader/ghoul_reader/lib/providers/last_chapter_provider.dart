import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LastOpenedChapterProvider extends ChangeNotifier {
  String? _chapterId;
  String? _chapterNum;
  String? _title;

  String? get chapterId => _chapterId;
  String? get chapterNum => _chapterNum;
  String? get title => _title;

  LastOpenedChapterProvider() {
    loadLastChapter();
  }

  Future<void> saveLastChapter(String chapterId, String chapterNum, String title) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastChapterId', chapterId);
    await prefs.setString('lastChapterNum', chapterNum);
    await prefs.setString('lastTitle', title);
    _chapterId = chapterId;
    _chapterNum = chapterNum;
    _title = title;
    notifyListeners();
  }

  Future<void> loadLastChapter() async {
    final prefs = await SharedPreferences.getInstance();
    _chapterId = prefs.getString('lastChapterId');
    _chapterNum = prefs.getString('lastChapterNum');
    _title = prefs.getString('lastTitle');
    notifyListeners();
  }

  String get lastChapterText {
    if (chapterId == null) return "Last Time: Never opened";
    return "Last Time: Chapter $chapterNum";
  }
}