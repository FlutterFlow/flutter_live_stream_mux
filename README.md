# flutter_mux_live

`POST https://api.mux.com/video/v1/live-streams`

```json
{
  "playback_policy": "public",
  "new_asset_settings": {
    "playback_policy": "public"
  }
}
```

API Response Body:

```json
{
  "data": {
    "stream_key": "your-secret-stream-key",
    "status": "idle",
    "reconnect_window": 60,
    "playback_ids": [{
      "policy": "public",
      "id": "your-public-playback-id"
    }],
    "new_asset_settings": {
      "playback_policies": [
        "public"
      ]
    },
    "id": "your-live-stream-id",
    "created_at": "1589547489"
  }
}
```

Sample playback ID:

`https://stream.mux.com/{PLAYBACK_ID}.m3u8`
