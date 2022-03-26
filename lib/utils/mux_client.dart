import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_mux_live/models/mux_live_data.dart';

class MuxClient {
  FirebaseFunctions functions = FirebaseFunctions.instance;

  Future<MuxLiveData> createLiveStream() async {
    final callable = functions.httpsCallable('createLiveStream');
    final response = await callable();
    final muxLiveData = MuxLiveData.fromJson(response.data);
    return muxLiveData;
  }

  Future<List<MuxLiveData>> getLiveStreams() async {
    final callable = functions.httpsCallable('retrieveLiveStreams');
    final response = await callable();

    Iterable l = response.data;
    List<MuxLiveData> streamList = List<MuxLiveData>.from(
      l.map(
        (model) => MuxLiveData.fromJson(
          Map<String, dynamic>.from(model),
        ),
      ),
    );

    return streamList;
  }

  Future<MuxLiveData> getLiveStream({required String liveStreamId}) async {
    final callable = functions.httpsCallable('retrieveLiveStream');
    final response = await callable.call({
      'liveStreamId': liveStreamId,
    });
    final muxLiveData = MuxLiveData.fromJson(response.data);
    return muxLiveData;
  }

  Future<void> deleteLiveStream({required String liveStreamId}) async {
    final callable = functions.httpsCallable('deleteLiveStream');
    await callable.call({
      'liveStreamId': liveStreamId,
    });
  }
}
