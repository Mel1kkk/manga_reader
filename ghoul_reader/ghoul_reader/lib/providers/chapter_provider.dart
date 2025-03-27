import 'package:flutter/material.dart';
import 'package:ghoul_reader/models/chapter.dart';
import 'package:ghoul_reader/services/chapterList_api.dart';

class ChapterProvider extends ChangeNotifier {
  List<Chapter> _chapters = [];

  List<Chapter> get chapters => _chapters;

  Future<void> loadChapters() async {
    _chapters = await ChapterApi.fetchChapters();
    notifyListeners();
  }

  // Getting the next chapterId to make a Next Button
  String? getNextChapterId(String currentChapterId) {
    for (int i = 0; i < _chapters.length - 1; i++) {
      if (_chapters[i].chapterId == currentChapterId) {
        return _chapters[i + 1].chapterId;
      }
    }
    return null;
  }

  String? getNextChapterTitle(String currentChapterId) {
    for (int i = 0; i < _chapters.length - 1; i++) {
      if(_chapters[i].chapterId == currentChapterId) {
        return _chapters[i+1].title;
      }
    }
    return null;
  }

  String? getNextChapterNumber(String currentChapterId) {
    for (int i = 0; i < _chapters.length - 1; i++) {
      if(_chapters[i].chapterId == currentChapterId) {
        return _chapters[i+1].chapterNum;
      }
    }
    return null;
  }  

  // Getting the previous chapterId to make a Previous Button
  String? getPreviousChapterId(String currentChapterId) {
    for(int i = 1; i < _chapters.length; i++) {
      if (_chapters[i].chapterId == currentChapterId) {
        return _chapters[i - 1].chapterId;
      }
    }
    return null;
  }

  String? getPreviousChapterTitle(String currentChapterId) {
    for(int i = 1; i < _chapters.length; i++) {
      if (_chapters[i].chapterId == currentChapterId) {
        return _chapters[i - 1].title;
      }
    }
    return null;
  }

  String? getPreviousChapterNumber(String currentChapterId) {
    for(int i = 1; i < _chapters.length; i++) {
      if (_chapters[i].chapterId == currentChapterId) {
        return _chapters[i - 1].chapterNum;
      }
    }
    return null;
  }    


}

