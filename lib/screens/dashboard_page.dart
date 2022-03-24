import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mux_live/models/mux_stream.dart';
import 'package:flutter_mux_live/res/strings.dart';
import 'package:flutter_mux_live/utils/mux_client.dart';
import 'package:flutter_mux_live/widgets/video_tile.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'live_stream_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late final MuxClient _muxClient;
  List<MuxStream>? _streams;

  bool _activeStreamToggle = true;
  bool _idToggle = false;
  bool _isRetrieving = false;

  _getStreams() async {
    setState(() {
      _isRetrieving = true;
    });
    var streams = await _muxClient.getLiveStreams();
    if (_activeStreamToggle) {
      streams = streams.where((element) => element.status == 'active').toList();
    }

    setState(() {
      _streams = streams;
      _isRetrieving = false;
    });
  }

  @override
  void initState() {
    _muxClient = MuxClient();
    _getStreams();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.pink,
        title: RichText(
          text: const TextSpan(
            style: TextStyle(
              fontSize: 22,
              color: Colors.white,
            ),
            children: [
              TextSpan(
                text: 'MUX ',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(
                text: 'Live Stream',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size(double.maxFinite, 100),
          child: Container(
            color: Colors.pink,
            width: double.maxFinite,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Show active streams',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      Switch(
                        activeColor: Colors.white,
                        value: _activeStreamToggle,
                        onChanged: (value) async {
                          setState(() {
                            _activeStreamToggle = value;
                          });
                          _getStreams();
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Show IDs',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      Switch(
                        activeColor: Colors.white,
                        value: _idToggle,
                        onChanged: (value) => setState(() {
                          _idToggle = value;
                        }),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const LiveStreamPage(),
            ),
          );
        },
        child: const FaIcon(FontAwesomeIcons.video),
      ),
      body: RefreshIndicator(
        onRefresh: () => _getStreams(),
        child: !_isRetrieving && _streams != null
            ? _streams!.isEmpty
                ? Container(
                    color: Colors.pink.shade50,
                    child: const Center(
                      child: Text('Empty'),
                    ),
                  )
                : Container(
                    color: Colors.pink.shade50,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemCount: _streams!.length,
                        itemBuilder: (context, index) {
                          DateTime dateTime =
                              DateTime.fromMillisecondsSinceEpoch(
                            int.parse(_streams![index].createdAt) * 1000,
                          );
                          DateFormat formatter =
                              DateFormat.yMMMMd().addPattern('|').add_jm();
                          String dateTimeString = formatter.format(dateTime);

                          String currentStatus = _streams![index].status;
                          bool isReady = currentStatus == 'active';

                          String? playbackId = isReady
                              ? _streams![index].playbackIds[0].id
                              : null;

                          String? thumbnailURL = isReady
                              ? '$muxImageBaseUrl/$playbackId/$imageTypeSize'
                              : null;

                          return VideoTile(
                            showId: _idToggle,
                            streamData: _streams![index],
                            thumbnailUrl: thumbnailURL,
                            isReady: isReady,
                            dateTimeString: dateTimeString,
                            onTap: (id) async {
                              await _muxClient.deleteLiveStream(
                                  liveStreamId: id);
                              _getStreams();
                            },
                          );
                        },
                        separatorBuilder: (_, __) => const SizedBox(
                          height: 16.0,
                        ),
                      ),
                    ),
                  )
            : Container(
                color: Colors.pink.shade50,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
      ),
    );
  }
}
