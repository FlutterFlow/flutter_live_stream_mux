import 'package:flutter/material.dart';
import 'package:flutter_mux_live/models/mux_stream.dart';
import 'package:flutter_mux_live/res/app_theme.dart';
import 'package:flutter_mux_live/res/strings.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';

class PlaybackPage extends StatefulWidget {
  const PlaybackPage({
    Key? key,
    required this.streamData,
  }) : super(key: key);

  final MuxStream streamData;

  @override
  State<PlaybackPage> createState() => _PlaybackPageState();
}

class _PlaybackPageState extends State<PlaybackPage> {
  late final VideoPlayerController _videoController;
  late final MuxStream _streamData;
  late final String _dateTimeString;

  @override
  void initState() {
    super.initState();

    _streamData = widget.streamData;
    String playbackId = _streamData.playbackIds[0].id;

    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
        int.parse(_streamData.createdAt) * 1000);
    DateFormat formatter = DateFormat.yMd().add_jm();
    _dateTimeString = formatter.format(dateTime);

    _videoController = VideoPlayerController.network(
        '$muxStreamBaseUrl/$playbackId.$videoExtension')
      ..initialize().then((_) {
        setState(() {});
      });

    _videoController.play();
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: _videoController.value.isInitialized
            ? ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: AspectRatio(
                  aspectRatio: _videoController.value.aspectRatio,
                  child: VideoPlayer(_videoController),
                ),
            )
            : AspectRatio(
                aspectRatio: 9 / 16,
                child: Container(
                  color: Colors.black,
                  width: double.maxFinite,
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        CustomColors.muxPink,
                      ),
                      strokeWidth: 2,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
