import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mux_live/models/mux_live_data.dart';
import 'package:flutter_mux_live/models/mux_stream.dart';

class MuxClient {
  FirebaseFunctions functions = FirebaseFunctions.instance;

  Future<MuxLiveData> createLiveStream() async {
    final callable = functions.httpsCallable('createLiveStream');
    final response = await callable();
    final muxLiveData = MuxLiveData.fromJson(response.data);
    return muxLiveData;
  }

  Future<List<MuxStream>> getLiveStreams() async {
    final callable = functions.httpsCallable('retrieveLiveStreams');
    final response = await callable();

    Iterable l = response.data;
    List<MuxStream> streamList = List<MuxStream>.from(
      l.map(
        (model) => MuxStream.fromJson(
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
    final response = await callable.call({
      'liveStreamId': liveStreamId,
    });
    debugPrint('deleted response: ${response.toString()}');
  }
}
