
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';


class MusicPlayerProvider with ChangeNotifier {

   String currentlyPlayingSong="";
   final audioPlayer = AudioPlayer();


  void playSong (String songPath, bool isPlaying) async{
    //songPath = "https://djmaza.me/files/128/Hindi/1172544/Heeriye%20-%20DjMaza.ME.mp3";
    // if(currentlyPlayingSong != songPath){
    //   await audioPlayer.stop();
    //   currentlyPlayingSong = songPath;
    //   AudioSource.uri(Uri.parse(songPath),);
    //   isPlaying = true;
    // }
    // else {
    //   if(isPlaying){
    //     await audioPlayer.pause();
    //   }
    //   else {
    //     await audioPlayer.resume();
    //   }
    //   isPlaying = !isPlaying;
    //   notifyListeners();
    // }
    if(isPlaying){
      audioPlayer.setAudioSource(
          AudioSource.uri(Uri.parse(songPath),)
      );
      audioPlayer.play();
      notifyListeners();
    }
    else{
      audioPlayer.stop();
      notifyListeners();
    }
    // audioPlayer.setAudioSource(
    //     AudioSource.uri(Uri.parse(songPath),)
    // );
  }
}
