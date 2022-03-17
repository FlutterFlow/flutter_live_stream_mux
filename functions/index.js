const functions = require("firebase-functions");

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

const Mux = require("@mux/mux-node");
const dotenv = require("dotenv");
dotenv.config();

const {Video} = new Mux(
    process.env.MUX_TOKEN_ID,
    process.env.MUX_TOKEN_SECRET,
);

exports.createLiveStream = functions.https.onCall(async (data, context) => {
  // Checking that the user is authenticated.
  if (!context.auth) {
    throw new functions.https.HttpsError(
        "failed-precondition",
        "The function must be called " + "while authenticated.",
    );
  } else {
    try {
      const response = await Video.LiveStreams.create({
        playback_policy: "public",
        new_asset_settings: {playback_policy: "public"},
      });

      return response;
    } catch (err) {
      console.error(
          `Unable to start the live stream ${context.auth.uid}. 
          Error ${err}`,
      );
      throw new functions.https.HttpsError(
          "aborted",
          "Could not create live stream",
      );
    }
  }
});

exports.retrieveLiveStreams = functions.https.onCall(async (data, context) => {
  // Checking that the user is authenticated.
  if (!context.auth) {
    throw new functions.https.HttpsError(
        "failed-precondition",
        "The function must be called " + "while authenticated.",
    );
  } else {
    try {
      const liveStreams = await Video.LiveStreams.list();

      const responseList = liveStreams.map((liveStream) => ({
        id: liveStream.id,
        status: liveStream.status,
        playback_ids: liveStream.playback_ids,
        created_at: liveStream.created_at,
      }));

      return responseList;
    } catch (err) {
      console.error(
          `Unable to retrieve live streams. 
          Error ${err}`,
      );
      throw new functions.https.HttpsError(
          "aborted",
          "Could not retrieve live streams",
      );
    }
  }
});

exports.retrieveLiveStream = functions.https.onCall(async (data, context) => {
  // Checking that the user is authenticated.
  if (!context.auth) {
    throw new functions.https.HttpsError(
        "failed-precondition",
        "The function must be called " + "while authenticated.",
    );
  } else {
    try {
      const liveStreamId = data.liveStreamId;
      const liveStream = await Video.LiveStreams.get(liveStreamId);

      return liveStream;
    } catch (err) {
      console.error(
          `Unable to retrieve live stream, id: ${data.liveStreamId}. 
          Error ${err}`,
      );
      throw new functions.https.HttpsError(
          "aborted",
          "Could not retrieve live stream",
      );
    }
  }
});

exports.deleteLiveStream = functions.https.onCall(async (data, context) => {
  // Checking that the user is authenticated.
  if (!context.auth) {
    throw new functions.https.HttpsError(
        "failed-precondition",
        "The function must be called " + "while authenticated.",
    );
  } else {
    try {
      const liveStreamId = data.liveStreamId;
      const response = await Video.LiveStreams.del(liveStreamId);

      return response;
    } catch (err) {
      console.error(
          `Unable to delete live stream, id: ${data.liveStreamId}. 
        Error ${err}`,
      );
      throw new functions.https.HttpsError(
          "aborted",
          "Could not delete live stream",
      );
    }
  }
});
