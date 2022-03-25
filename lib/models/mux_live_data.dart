import 'dart:convert';

class MuxLiveData {
  MuxLiveData({
    required this.streamKey,
    required this.status,
    required this.reconnectWindow,
    required this.playbackIds,
    required this.id,
    required this.createdAt,
    required this.latencyMode,
    required this.maxContinuousDuration,
  });

  String? streamKey;
  String status;
  int? reconnectWindow;
  List<PlaybackId> playbackIds;
  String id;
  String createdAt;
  String? latencyMode;
  int? maxContinuousDuration;

  factory MuxLiveData.fromRawJson(String str) =>
      MuxLiveData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MuxLiveData.fromJson(Map<String, dynamic> json) => MuxLiveData(
        streamKey: json["stream_key"],
        status: json["status"],
        reconnectWindow: json["reconnect_window"],
        playbackIds: List<PlaybackId>.from(json["playback_ids"]
            .map((x) => PlaybackId.fromJson(Map<String, dynamic>.from(x)))),
        id: json["id"],
        createdAt: json["created_at"],
        latencyMode: json["latency_mode"],
        maxContinuousDuration: json["max_continuous_duration"],
      );

  Map<String, dynamic> toJson() => {
        "stream_key": streamKey,
        "status": status,
        "reconnect_window": reconnectWindow,
        "playback_ids": List<dynamic>.from(playbackIds.map((x) => x.toJson())),
        "id": id,
        "created_at": createdAt,
        "latency_mode": latencyMode,
        "max_continuous_duration": maxContinuousDuration,
      };
}

class PlaybackId {
  PlaybackId({
    required this.policy,
    required this.id,
  });

  String policy;
  String id;

  factory PlaybackId.fromRawJson(String str) =>
      PlaybackId.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PlaybackId.fromJson(Map<String, dynamic> json) => PlaybackId(
        policy: json["policy"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "policy": policy,
        "id": id,
      };
}
