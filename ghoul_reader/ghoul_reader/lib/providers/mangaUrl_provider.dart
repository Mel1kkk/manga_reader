import 'package:flutter/material.dart';
import 'package:ghoul_reader/models/manga_reader.dart';
import 'package:ghoul_reader/services/mangadex_api.dart';

class MangaurlProvider extends ChangeNotifier {
  List<MangaReader> _mangaUrls = [];
  bool _isLoading = false;
  String? _currentChapterId;

  List<MangaReader> get mangaUrls => _mangaUrls;
  bool get isLoading => _isLoading;

  Future<void> loadMangsUrls(String chapterId) async {
    if (_isLoading || _currentChapterId == chapterId) return;

    _isLoading = true;
    _currentChapterId = chapterId; // Сохраняем текущую главу
    _mangaUrls = []; // Очистка перед загрузкой
    notifyListeners();

    print('Loading chapter: $chapterId');
    
    if (_currentChapterId == chapterId) {
      _mangaUrls = await MangadexApi.fetchManga(chapterId);
      _isLoading = false;
      notifyListeners();
    }
  }
}


