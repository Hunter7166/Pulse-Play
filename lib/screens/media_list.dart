import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulse_play/color_constants.dart';
import 'package:pulse_play/music_player_provider.dart';
import 'package:pulse_play/utlis/dimensions.dart';
import 'player_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MediaList extends StatefulWidget {
  const MediaList({super.key});

  @override
  State<MediaList> createState() => _MediaListState();
}

class _MediaListState extends State<MediaList> {
  String songName = 'A SKY FULL OF STARS';

  OnAudioQuery audioQuery = OnAudioQuery();
  List<SongModel> mp3Songs = [];

  Future<void> fetchMp3() async {
    final mp3model = await audioQuery.querySongs();
    setState(() {
      mp3Songs = mp3model.toList();
    });
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
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: screenColor,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  ResuableBackArrow(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>  const PlayerScreen(
                              isPlaying:  true,
                              songName: 'hello',
                              uri: 'fffff',
                            )
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    width: widgetWidth(75),
                  ),
                  Text(
                    songName,
                    style: const TextStyle(
                      color: Color(0xFF6F787C),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ResuableButton(
                    containerWidth: widgetWidth(55),
                    containerHeight: widgetHeight(55),
                    icon: const Icon(
                      Icons.favorite_outlined,
                      color: Colors.grey,
                    ),
                  ),
                  Container(
                    height: widgetHeight(185),
                    width: widgetWidth(185),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/pic1.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                    // Load image from assets
                  ),
                  ResuableButton(
                    containerWidth: widgetWidth(55),
                    containerHeight: widgetHeight(55),
                    icon: const Icon(
                      Icons.more_horiz_outlined,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: mp3Songs.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return ResuableListTile(
                      text: mp3Songs[index].title,
                      filePath: mp3Songs[index].uri!,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResuableBackArrow extends StatelessWidget {
  const ResuableBackArrow({
    super.key,
    required this.onTap,
  });
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return ResuableButton(
      containerWidth: widgetWidth(50),
      containerHeight: widgetHeight(50),
      icon: const Icon(
        Icons.arrow_back,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }
}

class ResuableListTile extends StatefulWidget {
  const ResuableListTile({
    super.key,
    required this.text, required this.filePath,
  });
  final String text;
  final String filePath;
  @override
  State<ResuableListTile> createState() => _ResuableListTileState();
}

class _ResuableListTileState extends State<ResuableListTile> {
  bool isPlaying = false;
  @override
  Widget build(BuildContext context) {

    return ListTile(
    title: Text(
        widget.text,
        style: const TextStyle(
          color: Color(0xFFA5A8AA),
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: StartButton(
        containerWidth: widgetWidth(45),
        containerHeight: widgetHeight(45),
        isSelected: isPlaying,
        onPressed: () {
          setState(() {
            isPlaying = !isPlaying;
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>  PlayerScreen(
                    isPlaying:  isPlaying,
                    songName: widget.text,
                    uri: widget.filePath,
                  )
              ),
            );
          });
        },
      ),
      tileColor: isPlaying ? const Color(0xFF171717) : screenColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

class ResuableButton extends StatelessWidget {
  const ResuableButton({
    super.key,
    required this.containerWidth,
    required this.containerHeight,
    required this.icon,
    this.onTap,
  });

  final double containerWidth;
  final double containerHeight;
  final Icon icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: containerWidth,
        height: containerHeight,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF303439),
              Color(0xFF161718),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF101113),
              blurRadius: 20,
              offset: Offset(6, 2),
              spreadRadius: 2,
            ),
            BoxShadow(
              color: Color(0xFF95BEE6),
              blurRadius: 25,
              offset: Offset(-2, -3),
              spreadRadius: -10,
            )
          ],
          shape: BoxShape.circle,
        ),
        child: icon,
      ),
    );
  }
}

class StartButton extends StatefulWidget {
  const StartButton(
      {super.key,
      required this.containerWidth,
      required this.containerHeight,
      required this.isSelected,
      required this.onPressed});
  final double containerWidth;
  final double containerHeight;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  State<StartButton> createState() => _StartButtonState();
}

class _StartButtonState extends State<StartButton> {
  late bool selected;
  @override
  void initState() {
    super.initState();
    selected = widget.isSelected;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selected = !selected;
        });
        widget.onPressed();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        height: widget.containerWidth + 3,
        width: widget.containerHeight + 3,
        decoration: BoxDecoration(
            color: selected ? const Color(0xFF3f497a) : const Color(0xFF282A2F),
            shape: BoxShape.circle),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            width: widget.containerWidth,
            height: widget.containerHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: selected
                    ? [const Color(0xFF000000), const Color(0xFF7987FF)]
                    : [const Color(0xFF2F3338), const Color(0xFF161718)],
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0xFF101113),
                  blurRadius: 20,
                  offset: Offset(4, 2),
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: Color(0xFF95BEE6),
                  blurRadius: 25,
                  offset: Offset(-2, -3),
                  spreadRadius: -10,
                )
              ],
              shape: BoxShape.circle,
            ),
            child: Icon(
              selected ? Icons.pause_rounded : Icons.play_arrow_rounded,
              color: selected ? Colors.white : const Color(0xFFA5A8AA),
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}

