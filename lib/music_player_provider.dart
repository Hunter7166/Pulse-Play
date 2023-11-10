
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';


class MusicPlayerProvider with ChangeNotifier {

   String currentlyPlayingSong="";
   final audioPlayer = AudioPlayer();


//   void playSong (String songPath, bool isPlaying) async{
//
//     if(isPlaying){
//       audioPlayer.setAudioSource(
//           AudioSource.uri(Uri.parse(songPath),)
//       );
//       audioPlayer.play();
//       notifyListeners();
//     }
//     else{
//       audioPlayer.stop();
//       notifyListeners();
//     }
//     // audioPlayer.setAudioSource(
//     //     AudioSource.uri(Uri.parse(songPath),)
//     // );
//   }
// }
void playSong(String songPath, bool isPlaying) async {
  if (isPlaying) {
    if (currentlyPlayingSong != songPath) {
      await audioPlayer.stop();
      await audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(songPath)));
      currentlyPlayingSong = songPath;
    }
    await audioPlayer.play();
  } else {
    await audioPlayer.pause();
  }
  notifyListeners();
}
}

// void playSong(String songPath, bool isPlaying) async {
//   if (isPlaying) {
//     if (currentlyPlayingSong != songPath) {
//       await audioPlayer.stop();
//       await audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(songPath)));
//       currentlyPlayingSong = songPath;
//     }
//     await audioPlayer.play();
//   } else {
//     await audioPlayer.pause();
//   }
//   notifyListeners();
// }
// }


