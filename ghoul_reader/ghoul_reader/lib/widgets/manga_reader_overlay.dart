import 'package:flutter/material.dart';

class MangaReaderOverlay {
  OverlayEntry? _overlayEntry;
  late AnimationController _controller;
  late Animation<Offset> _animation;
  final BuildContext context;
  bool isVisible = false;

  MangaReaderOverlay({required this.context, required TickerProvider vsync}) {
    _controller = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 150),
    );

    _animation = Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    
  }

  void _createOverlay(String title, String chapterNum) {
    _overlayEntry = OverlayEntry(
      builder: (context) => AnimatedBuilder(
        animation: _animation,
        builder: (context, child) => Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SlideTransition(
            position: _animation,
            child: Material(
              color: Colors.transparent,
              child: Container(
                height: 70,
                color: Colors.grey[850],
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 18,
                      ),
                      onPressed: () {
                        hideOverlay();
                        Navigator.pop(context);
                      },
                    ),

                    title.isEmpty
                        ? SizedBox(
                            width: 10,
                            height: 10,
                            child: CircularProgressIndicator())
                        : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 5),

                            Text(
                                title,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),

                            Text(
                                'Chapter $chapterNum',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                          ],
                        ),

                    Spacer(),
                          
                    IconButton(
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                        size: 18,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showOverlay(String title, String chapterNum) {
    if (_overlayEntry == null) {
      _createOverlay(title, chapterNum);
      Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
    }
    _controller.forward();
    isVisible = true;
  }


  void hideOverlay() {
    _controller.reverse().then((_) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      isVisible = false;
    });
  }

  void updateTitle(String newTitle, String newChapterNum) {
    if (_overlayEntry != null) {
      _overlayEntry!.remove(); // Удаляем старый оверлей
      _createOverlay(newTitle, newChapterNum); // Создаем новый с обновленным заголовком
      Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
  }
}
  

  void dispose() {
    if (_overlayEntry != null) {
      hideOverlay();
    }
    _controller.dispose();
  }
}
