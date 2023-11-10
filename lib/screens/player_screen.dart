//import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulse_play/color_constants.dart';
import 'package:pulse_play/music_player_provider.dart';
import 'media_list.dart';
import 'package:pulse_play/utlis/dimensions.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen(
      {super.key,
      required this.isPlaying,
      required this.songName,
      required this.uri});
  final bool isPlaying;
  final String songName;
  final String uri;
  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<MusicPlayerProvider>(context, listen: false)
        .playSong(widget.uri, widget.isPlaying);
  }

  @override
  Widget build(BuildContext context) {
    String text = 'Playing Now';
    Duration? duration = Duration.zero;
    Duration position = Duration.zero;
    bool isPlaying = widget.isPlaying;
    return SafeArea(
      child: Scaffold(
        backgroundColor: screenColor,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  ResuableBackArrow(onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MediaList(),
                      ),
                    );
                  }),
                  SizedBox(
                    width: widgetWidth(90),
                  ),
                  Text(
                    text,
                    style: const TextStyle(
                      color: Color(0xFF6F787C),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: widgetHeight(390),
                width: widgetWidth(390),
                child: Image.asset('images/Ellipse9.png'),
              ),
              Text(
                widget.songName,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFFA5A8AA),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'ColdPlay',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFFA5A8AA),
                ),
              ),
              const SizedBox(
                height: 90,
              ),
              SliderTheme(
                data: const SliderThemeData(
                  activeTrackColor: Color(0xFF7987FF),
                  inactiveTrackColor: Color(0xFF000000),
                  thumbColor: Color(0xFF7987FF),
                  thumbShape: RoundSliderThumbShape(
                    enabledThumbRadius: 8,
                    elevation: 12,
                  ),
                  overlayColor: Color(0xFF000000),
                  overlayShape: RoundSliderOverlayShape(
                    overlayRadius: 17,
                  ),
                ),
                child: Consumer<MusicPlayerProvider>(
                  builder: (context, musicProvider, child) {
                     position = musicProvider.audioPlayer.position;
                     duration = musicProvider.audioPlayer.duration;

                    return Slider(
                      min: 0,
                      max: duration?.inSeconds.toDouble() ?? 0,
                      value: position.inSeconds.toDouble(),
                      onChanged: (value) {
                        // You may add logic to seek to a specific position when the user interacts with the slider.
                        musicProvider.audioPlayer.seek(Duration(seconds: value.toInt()));
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formatTime(position),
                      style: const TextStyle(color: Colors.grey),
                    ),
                    Text(
                      formatTime(duration!),
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ResuableButton(
                    containerWidth: widgetWidth(78),
                    containerHeight: widgetHeight(78),
                    icon: const Icon(
                      Icons.skip_previous_sharp,
                      size: 20,
                      color: Colors.grey,
                    ),
                  ),
                  StartButton(
                    containerWidth: widgetWidth(80),
                    containerHeight: widgetHeight(80),
                    isSelected: isPlaying,
                    onPressed: () {
                      Provider.of<MusicPlayerProvider>(context, listen: false)
                          .playSong(widget.uri, isPlaying);
                    },
                  ),
                  ResuableButton(
                    containerWidth: widgetWidth(78),
                    containerHeight: widgetHeight(78),
                    icon: const Icon(
                      Icons.skip_next_sharp,
                      size: 20,
                      color: Colors.grey,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

String formatTime(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final hours = twoDigits(duration.inHours);
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));

  String formattedTime = [
    if (duration.inHours > 0) hours,
    minutes,
    seconds,
  ].join(':');

  return formattedTime;
}
