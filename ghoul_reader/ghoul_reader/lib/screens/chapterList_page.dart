import 'package:flutter/material.dart';
import 'package:ghoul_reader/providers/chapter_provider.dart';
import 'package:ghoul_reader/providers/last_chapter_provider.dart';
import 'package:ghoul_reader/providers/theme_provider.dart';
import 'package:ghoul_reader/screens/mangaReader_page.dart';
import 'package:provider/provider.dart';

class ChapterList extends StatelessWidget {
  const ChapterList({super.key});

  @override
  Widget build(BuildContext context) {
    String imageUrl = 
    "https://avatars.mds.yandex.net/get-kinopoisk-image/1900788/e5d98938-605a-4c8a-b0d6-5f93d926aa0c/600x900";

    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: isPortrait
          ? Column(
              children: [
                BackgroundCover(imageUrl: imageUrl),
                ChapterView(),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: BackgroundCover(imageUrl: imageUrl),
                ),
                Expanded(child: ChapterView()),
              ],
            ),
    );
  }
}

class ChapterView extends StatelessWidget {
  const ChapterView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Consumer<ChapterProvider>(
          builder:(context, provider, child) {
            if(provider.chapters.isEmpty) {
              provider.loadChapters();
              return Center(
                child: CircularProgressIndicator(
                color: Colors.orange[600],
              ));
            }
        
            return ListView.builder(
              itemCount: provider.chapters.length,
              itemBuilder: (context, index) {
                final chapter = provider.chapters[index];
                return ListTile(
                  splashColor: Colors.transparent,
                  selectedTileColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  tileColor: Colors.transparent,
                  leading: IconButton(
                    icon: Icon(
                      Icons.radio_button_on_rounded,
                    ),
                    onPressed: () {
                      Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                    },
                  ),
                  onTap:() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MangaReaderPage(
                          chapterId: chapter.chapterId,
                          title: chapter.title,
                          chapterNum: chapter.chapterNum,                        
                        ),
                      ),
                    );
                  },
                  title: Text(
                    'Chapter ${chapter.chapterNum} ${chapter.title}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    ),
                );
              },
              
            );
          },
        ),
      ),
    );
  }
}

class BackgroundCover extends StatelessWidget {
  const BackgroundCover({
    super.key,
    required this.imageUrl,
  });

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Stack(
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: Opacity(
              opacity: 0.2,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: isPortrait ? 60 : 30),
            Center(
              child: Container(
                height: isPortrait ? 250 : 180,
                width: isPortrait ? 170 : 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.5),
                      blurRadius: 10,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: isPortrait ? 20 : 10),
            Center(
              child: Text(
                'Tokyo Ghoul',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: isPortrait ? 24 : 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Center(
              child: Text(
                'Toukyou Kushu',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: isPortrait ? 18 : 16,
                  fontWeight: FontWeight.w200,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Center(
              child: Consumer<LastOpenedChapterProvider>(
                builder: (context, lastChapter, child) {
                  return GestureDetector(
                    onTap: () {
                      if (lastChapter.chapterId != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MangaReaderPage(
                              chapterId: lastChapter.chapterId!,
                              title: lastChapter.title!,
                              chapterNum: lastChapter.chapterNum!,
                            ),
                          ),
                        );
                      }
                    },
                    child: Text(
                      lastChapter.lastChapterText,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: isPortrait ? 18 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: isPortrait ? 30 : 15),
          ],
        ),
      ],
    );
  }
}