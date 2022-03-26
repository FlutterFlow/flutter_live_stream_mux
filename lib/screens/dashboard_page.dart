import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mux_live/res/strings.dart';
import 'package:flutter_mux_live/utils/mux_client.dart';
import 'package:flutter_mux_live/widgets/video_tile.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../models/mux_live_data.dart';
import 'live_stream_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late final MuxClient _muxClient;

  List<MuxLiveData>? _streams;
  bool _isRetrieving = false;

  _getStreams() async {
    setState(() {
      _isRetrieving = true;
    });

    var streams = await _muxClient.getLiveStreams();

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
      backgroundColor: Colors.pink.shade50,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.pink,
        title: const Text(
          'MUX Live Stream',
          style: TextStyle(
            fontSize: 22,
            color: Colors.white,
            fontWeight: FontWeight.w600,
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
                ? const Center(
                    child: Text('Empty'),
                  )
                : ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: _streams!.length,
                    itemBuilder: (context, index) {
                      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                        int.parse(_streams![index].createdAt) * 1000,
                      );
                      DateFormat formatter =
                          DateFormat.yMMMMd().addPattern('|').add_jm();
                      String dateTimeString = formatter.format(dateTime);

                      String currentStatus = _streams![index].status;
                      bool isReady = currentStatus == 'active';

                      String? playbackId =
                          isReady ? _streams![index].playbackIds[0].id : null;

                      String? thumbnailURL = isReady
                          ? '$muxImageBaseUrl/$playbackId/$imageTypeSize'
                          : null;

                      return VideoTile(
                        streamData: _streams![index],
                        thumbnailUrl: thumbnailURL,
                        isReady: isReady,
                        dateTimeString: dateTimeString,
                        onTap: (id) async {
                          await _muxClient.deleteLiveStream(liveStreamId: id);
                          _getStreams();
                        },
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(
                      height: 16.0,
                    ),
                  )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
