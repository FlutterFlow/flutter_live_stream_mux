import 'dart:convert';

class MuxStream {
  MuxStream({
    required this.streamKey,
    required this.status,
    required this.reconnectWindow,
    required this.playbackIds,
    required this.newAssetSettings,
    required this.id,
    required this.createdAt,
    required this.maxContinuousDuration,
    required this.recentAssetIds,
  });

  String? streamKey;
  String status;
  int reconnectWindow;
  List<PlaybackId> playbackIds;
  NewAssetSettings? newAssetSettings;
  String id;
  String createdAt;
  int? maxContinuousDuration;
  List<String>? recentAssetIds;

  factory MuxStream.fromRawJson(String str) =>
      MuxStream.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MuxStream.fromJson(Map<String, dynamic> json) => MuxStream(
        streamKey: json["stream_key"],
        status: json["status"],
        reconnectWindow: json["reconnect_window"] ?? 0,
        playbackIds: List<PlaybackId>.from(json["playback_ids"]
            .map((x) => PlaybackId.fromJson(Map<String, dynamic>.from(x)))),
        newAssetSettings: json["new_asset_settings"] != null
            ? NewAssetSettings.fromJson(json["new_asset_settings"])
            : null,
        id: json["id"],
        createdAt: json["created_at"],
        maxContinuousDuration: json["max_continuous_duration"],
        recentAssetIds: json["recent_asset_ids"] != null
            ? List<String>.from(json["recent_asset_ids"].map((x) => x))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "stream_key": streamKey,
        "status": status,
        "reconnect_window": reconnectWindow,
        "playback_ids": List<dynamic>.from(playbackIds.map((x) => x.toJson())),
        "new_asset_settings": newAssetSettings?.toJson() ?? '',
        "id": id,
        "created_at": createdAt,
        "max_continuous_duration": maxContinuousDuration,
        "recent_asset_ids": recentAssetIds != null
            ? List<dynamic>.from(recentAssetIds!.map((x) => x))
            : null,
      };
}

class NewAssetSettings {
  NewAssetSettings({
    required this.playbackPolicies,
  });

  List<String> playbackPolicies;

  factory NewAssetSettings.fromRawJson(String str) =>
      NewAssetSettings.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NewAssetSettings.fromJson(Map<String, dynamic> json) =>
      NewAssetSettings(
        playbackPolicies:
            List<String>.from(json["playback_policies"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "playback_policies": List<dynamic>.from(playbackPolicies.map((x) => x)),
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
