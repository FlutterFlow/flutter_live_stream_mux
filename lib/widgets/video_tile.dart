import 'package:flutter/material.dart';

import 'package:flutter_mux_live/res/app_theme.dart';

import '../models/mux_stream.dart';
import '../screens/playback_page.dart';

class VideoTile extends StatefulWidget {
  final MuxStream streamData;
  final String? thumbnailUrl;
  final String dateTimeString;
  final bool isReady;
  final bool showId;
  final Function(String id) onTap;

  const VideoTile({
    Key? key,
    required this.streamData,
    required this.thumbnailUrl,
    required this.dateTimeString,
    required this.isReady,
    required this.showId,
    required this.onTap,
  }) : super(key: key);

  @override
  State<VideoTile> createState() => _VideoTileState();
}

class _VideoTileState extends State<VideoTile> {
  bool _isLongPressed = false;

  @override
  Widget build(BuildContext context) {
    const snackBar = SnackBar(
      content: Text('The video is not active'),
    );

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 8.0,
          ),
          child: Container(
            decoration: _isLongPressed
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.red,
                      width: 4,
                    ),
                  )
                : null,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(5.0),
              ),
              child: InkWell(
                onTap: () {
                  widget.isReady
                      ? Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PlaybackPage(
                              streamData: widget.streamData,
                            ),
                          ),
                        )
                      : ScaffoldMessenger.of(context).showSnackBar(
                          snackBar,
                        );
                },
                onLongPress: () {
                  setState(() {
                    _isLongPressed = true;
                  });
                },
                child: Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.showId
                          ? Container(
                              width: double.maxFinite,
                              color: Colors.pink.shade300,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 8.0,
                                  top: 8.0,
                                  bottom: 8.0,
                                ),
                                child: Text(
                                  widget.streamData.id,
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widget.isReady && widget.thumbnailUrl != null
                              ? SizedBox(
                                  width: 150,
                                  height: 100,
                                  child: Image.network(
                                    widget.thumbnailUrl!,
                                    fit: BoxFit.cover,
                                    alignment: Alignment.bottomCenter,
                                  ),
                                )
                              : Container(
                                  width: 150,
                                  height: 100,
                                  color: Colors.black26,
                                  child: const Center(
                                    child: Text(
                                      'MUX',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 26,
                                      ),
                                    ),
                                  ),
                                ),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 8.0,
                                top: 8.0,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    maxLines: 1,
                                    softWrap: false,
                                    overflow: TextOverflow.fade,
                                    text: TextSpan(
                                      text: 'Status: ',
                                      style: const TextStyle(
                                        color: CustomColors.muxGray,
                                        fontSize: 14.0,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: widget.streamData.status,
                                          style: TextStyle(
                                            // fontSize: 12.0,
                                            color: CustomColors.muxGray
                                                .withOpacity(0.6),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 4.0),
                                  RichText(
                                    maxLines: 2,
                                    overflow: TextOverflow.clip,
                                    text: TextSpan(
                                      text: 'Created on: ',
                                      style: const TextStyle(
                                        color: CustomColors.muxGray,
                                        fontSize: 14.0,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: '\n${widget.dateTimeString}',
                                          style: TextStyle(
                                            // fontSize: 12.0,
                                            color: CustomColors.muxGray
                                                .withOpacity(0.6),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        _isLongPressed
            ? InkWell(
                onTap: () => widget.onTap(widget.streamData.id),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
