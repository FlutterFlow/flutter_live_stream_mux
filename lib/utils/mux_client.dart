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
}
