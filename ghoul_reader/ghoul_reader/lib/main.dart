import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ghoul_reader/providers/last_chapter_provider.dart';
import 'package:ghoul_reader/providers/mangaUrl_provider.dart';
import 'package:ghoul_reader/providers/theme_provider.dart';
import 'package:ghoul_reader/screens/chapterList_page.dart';
import 'package:ghoul_reader/providers/chapter_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,    
    ));

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ChapterProvider()),
        ChangeNotifierProvider(create: (_) => MangaurlProvider()),
        ChangeNotifierProvider(create: (_) => LastOpenedChapterProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ghoul Project',
      home: const ChapterList(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
