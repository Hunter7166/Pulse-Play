import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MusicListProvider with ChangeNotifier {

  OnAudioQuery audioQuery = OnAudioQuery();
  List<SongModel> mp3Songs = [];

  Future<void> fetchMp3() async {
    final mp3model = await audioQuery.querySongs();
      mp3Songs = mp3model.toList();
      notifyListeners();
  }
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    LogConfig logConfig = LogConfig(logType: LogType.DEBUG);
    audioQuery.setLogConfig(logConfig);

    // Check and request for permission.
    checkAndRequestPermissions();
  }

  checkAndRequestPermissions({bool retry = false}) async {
    // The param 'retryRequest' is false, by default.
    _hasPermission = await audioQuery.checkAndRequest(
      retryRequest: retry,
    );

    // Only call update the UI if application has all required permissions.
    _hasPermission ? setState(() {}) : null;
    if (_hasPermission) {
      fetchMp3();
    }
  }



}