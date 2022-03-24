import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_mux_live/models/mux_live_data.dart';
import 'package:flutter_mux_live/res/strings.dart';
import 'package:flutter_mux_live/utils/mux_client.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_stream/camera.dart';
import 'package:wakelock/wakelock.dart';

import '../../main.dart';

class LiveStreamPage extends StatefulWidget {
  const LiveStreamPage({Key? key}) : super(key: key);

  @override
  State<LiveStreamPage> createState() => _LiveStreamPageState();
}

class _LiveStreamPageState extends State<LiveStreamPage> {
  CameraController? _controller;
  late final MuxClient _muxClient;

  MuxLiveData? _sessionData;

  bool _isCameraPermissionGranted = false;
  bool _isCameraInitialized = false;
  bool _isInitializing = false;
  bool _isStreaming = false;
  bool _isFrontCamSelected = true;

  Timer? _timer;
  String? _durationString;
  final _stopwatch = Stopwatch();

  _startTimer() {
    _stopwatch.start();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _durationString = _getDurationString(_stopwatch.elapsed);
        });
      }
    });
  }

  _stopTimer() {
    _stopwatch.stop();
    _stopwatch.reset();
    _durationString = _getDurationString(_stopwatch.elapsed);

    _timer?.cancel();
  }

  String _getDurationString(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  _getPermissionStatus() async {
    await Permission.camera.request();
    var status = await Permission.camera.status;

    if (status.isGranted) {
      log('Camera Permission: GRANTED');
      setState(() {
        _isCameraPermissionGranted = true;
      });
      // Set and initialize the new camera
      // with front camera
      _onNewCameraSelected(cameras[1]);
    } else {
      log('Camera Permission: DENIED');
    }
  }

  _createSession() async {
    setState(() {
      _isInitializing = true;
    });

    final sessionData = await _muxClient.createLiveStream();

    setState(() {
      _sessionData = sessionData;
      _isInitializing = false;
    });
  }

  _startVideoStreaming() async {
    await _createSession();

    String url = streamBaseURL + _sessionData!.streamKey;

    try {
      await _controller!.startVideoStreaming(url, androidUseOpenGL: false);
    } on CameraException catch (e) {
      log(e.toString());
    }
  }

  _stopVideoStreaming() async {
    try {
      await _controller!.stopVideoStreaming();
    } on CameraException catch (e) {
      log(e.toString());
    }
  }

  @override
  void initState() {
    _muxClient = MuxClient();
    _getPermissionStatus();

    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _stopwatch.stop();
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (_controller == null || !_controller!.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      _controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (_controller != null) {
        _onNewCameraSelected(_controller!.description!);
      }
    }
  }

  void _onNewCameraSelected(CameraDescription cameraDescription) async {
    setState(() {
      _isCameraInitialized = false;
    });

    final previousCameraController = _controller;

    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      enableAudio: true,
      androidUseOpenGL: true,
    );

    await previousCameraController?.dispose();

    if (mounted) {
      setState(() {
        _controller = cameraController;
      });
    }

    _controller!.addListener(() {
      _isStreaming = _controller!.value.isStreamingVideoRtmp;
      _isCameraInitialized = _controller!.value.isInitialized;

      if (_isStreaming) {
        _startTimer();
        Wakelock.enable();
      } else {
        _stopTimer();
        Wakelock.disable();
      }

      if (mounted) setState(() {});
    });

    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      log('Error initializing camera: $e');
    }

    // if (mounted) {
    //   setState(() {
    //     _isCameraInitialized = _controller!.value.isInitialized;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: _isCameraInitialized
          ? _isInitializing || _isStreaming
              ? const SizedBox()
              : FloatingActionButton.extended(
                  label: const Text(
                    'Start Streaming',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      // letterSpacing: 1,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: _startVideoStreaming,
                  icon: const FaIcon(FontAwesomeIcons.video),
                )
          : const SizedBox(),
      body: SafeArea(
        child: Stack(
          children: [
            _isCameraPermissionGranted
                ? _isCameraInitialized
                    ? Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: AspectRatio(
                              aspectRatio: _controller!.value.aspectRatio,
                              child: CameraPreview(_controller!),
                            ),
                          ),
                          _isStreaming
                              ? const SizedBox()
                              : AspectRatio(
                                  aspectRatio: _controller!.value.aspectRatio,
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 16.0,
                                        bottom: 16.0,
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          _isFrontCamSelected
                                              ? _onNewCameraSelected(cameras[0])
                                              : _onNewCameraSelected(
                                                  cameras[1]);

                                          setState(() {
                                            _isFrontCamSelected =
                                                !_isFrontCamSelected;
                                          });
                                        },
                                        child: const CircleAvatar(
                                          radius: 30,
                                          backgroundColor: Colors.black54,
                                          child: Center(
                                            child: Icon(
                                              Icons.flip_camera_android,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(),
                      const Text(
                        'Permission denied',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          _getPermissionStatus();
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Give permission',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
            _isCameraInitialized && _controller!.value.isStreamingVideoRtmp
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                      ),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 600),
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          color: Colors.pink,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Stream ID',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 1,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _sessionData!.id,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 1,
                                          color: Colors.white70,
                                        ),
                                        // overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                _isCameraInitialized
                                    ? InkWell(
                                        onTap: _stopVideoStreaming,
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color: Colors.black26,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.stop_rounded,
                                              size: 60,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            )),
                      ),
                    ),
                  )
                : _isInitializing
                    ? Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                          ),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 600),
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                              color: Colors.pink,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.fromLTRB(16, 24, 16, 24),
                              child: Text(
                                'Initializing...',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
            _isStreaming
                ? Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      top: 16.0,
                      right: 16.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.redAccent,
                                    shape: BoxShape.circle,
                                  ),
                                  width: 16,
                                  height: 16,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'LIVE',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // IconButton(
                        //   onPressed: () async {
                        //     final newData = await _muxClient.getLiveStream(
                        //       liveStreamId: _sessionData!.id,
                        //     );

                        //     setState(() {
                        //       _sessionData = newData;
                        //     });
                        //   },
                        //   icon: Icon(Icons.refresh),
                        // ),
                        Text(
                          _durationString ?? '',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
