import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulse_play/music_player_provider.dart';
import 'screens/media_list.dart';
import 'utlis/dimensions.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MusicPlayerProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    initMediaQuerySize(context);
    return const MaterialApp(
      title: 'Flutter Demo',
      home: MediaList(),
    );
  }
}
