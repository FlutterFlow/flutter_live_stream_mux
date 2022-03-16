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

exports.createLiveStream = functions.https.onCall(
    async (data, context) => {
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
    },
);
