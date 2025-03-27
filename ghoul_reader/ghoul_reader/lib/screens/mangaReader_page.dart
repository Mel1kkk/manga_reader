import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ghoul_reader/providers/last_chapter_provider.dart';
import 'package:ghoul_reader/providers/mangaUrl_provider.dart';
import 'package:ghoul_reader/providers/chapter_provider.dart';
import 'package:ghoul_reader/widgets/manga_reader_overlay.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class MangaReaderPage extends StatefulWidget {
  final String chapterId;
  final String title;
  final String chapterNum;

  const MangaReaderPage({
    Key? key,
    required this.chapterId,
    required this.title,
    required this.chapterNum,
  }) : super(key: key);

  @override
  State<MangaReaderPage> createState() => _MangaReaderPageState();
}

class _MangaReaderPageState extends State<MangaReaderPage> with SingleTickerProviderStateMixin {
  String? _currentChapterId;
  String? _currentTitle;
  String? _currentChapterNum;
  late MangaReaderOverlay _overlay;

  @override
  void initState() {
    super.initState();
    _currentChapterId = widget.chapterId;
    _currentTitle = widget.title;
    _currentChapterNum = widget.chapterNum;

    // Загружаем главы
    Future.microtask(() {
      Provider.of<MangaurlProvider>(context, listen: false).loadMangsUrls(_currentChapterId!);
    });

    // Создаем оверлей
    _overlay = MangaReaderOverlay(context: context, vsync: this);

    // Показываем оверлей сразу
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _overlay.showOverlay(_currentTitle!, _currentChapterNum!);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LastOpenedChapterProvider>(context, listen: false)
        .saveLastChapter(_currentChapterId!, _currentChapterNum!, _currentTitle!);
    });        
    
  }

  @override
  void dispose() {
    _overlay.dispose();
    super.dispose();
  }
  
  void _toggleOverlay() {
    if (_overlay.isVisible) {
      _overlay.hideOverlay();
    } else {
      _overlay.showOverlay(_currentTitle!, _currentChapterNum!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final chapterProvider = Provider.of<ChapterProvider>(context);
    final nextChapterId = chapterProvider.getNextChapterId(_currentChapterId!);
    final previousChapterId = chapterProvider.getPreviousChapterId(_currentChapterId!);

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (_overlay.isVisible) {
          _overlay.hideOverlay();
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: GestureDetector(
          onTap: _toggleOverlay,
          behavior: HitTestBehavior.opaque,
          child: Consumer<MangaurlProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return Center(child: Lottie.network(
                  'https://lottie.host/899cdfc7-5292-428b-a066-4a2c1b22d534/a6K1O3f6xU.json',
                  height: 200,
                  width: 200,
                ));
              }
      
              final mangaUrls = provider.mangaUrls;
              final allPages = mangaUrls.expand((manga) => manga.mangaPagesUrl).toList();
      
              return NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  if (scrollNotification is UserScrollNotification && _overlay.isVisible) {
                    _overlay.hideOverlay();
                  }
                  return true;
                },
                child: Column(
                  children: [
                    Expanded(
                      child: InteractiveViewer(
                        scaleEnabled: true,
                        panEnabled: true,
                        minScale: 1.0,
                        maxScale: 3.0,
                      
                        child: ListView.builder(
                          itemCount: allPages.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: CachedNetworkImage(
                                imageUrl: allPages[index],
                                cacheKey: allPages[index],
                                fit: BoxFit.contain,
                                fadeInDuration: Duration.zero,
                                fadeOutDuration: Duration.zero,
                                placeholder: (context, url) => SizedBox(
                                  height: 600,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.orange[600],
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                      
                    Row(
                      children: [
                        previousChapterId != null 
                        ? GestureDetector(
                          onTap: () {
                            String previousTitle = chapterProvider.getPreviousChapterTitle(_currentChapterId!) ?? _currentTitle!;
                            String previousChapterNum = chapterProvider.getPreviousChapterNumber(_currentChapterId!) ?? _currentChapterNum!;
                            setState(() {
                              _currentChapterId = previousChapterId;
                              _currentTitle = previousTitle;
                              _currentChapterNum = previousChapterNum;
                            });

                            Provider.of<MangaurlProvider>(context, listen: false)
                                .loadMangsUrls(_currentChapterId!);

                            Provider.of<LastOpenedChapterProvider>(context, listen: false)
                                .saveLastChapter(_currentChapterId!, _currentChapterNum!, _currentTitle!);        
                      
                            _overlay.updateTitle(_currentTitle!, _currentChapterNum!);                        
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              "Previous",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 14,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        )
                        : const SizedBox(width: 50),
                      
                        Spacer(),
                      
                        nextChapterId != null 
                        ? GestureDetector(
                          onTap: () {
                            String nextTitle = chapterProvider.getNextChapterTitle(_currentChapterId!) ?? _currentTitle!;
                            String nextChapterNum = chapterProvider.getNextChapterNumber(_currentChapterId!) ?? _currentChapterNum!;
                            setState(() {
                              _currentChapterId = nextChapterId;
                              _currentTitle = nextTitle;
                              _currentChapterNum = nextChapterNum;
                            }); 
                            Provider.of<MangaurlProvider>(context, listen: false)
                                .loadMangsUrls(_currentChapterId!);

                            Provider.of<LastOpenedChapterProvider>(context, listen: false)
                                .saveLastChapter(_currentChapterId!, _currentChapterNum!, _currentTitle!);                                       
                      
                            _overlay.updateTitle(_currentTitle!, _currentChapterNum!);                        
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              "Next",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 14, 
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        )
                        : const SizedBox(width: 50),                    
                      
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
