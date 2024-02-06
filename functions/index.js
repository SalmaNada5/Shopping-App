const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
exports.checkEmail = functions.https.onRequest(async (req, res) => {
  const email = req.query.email;
  const users = admin.firestore().collection("users");
  const userSnapshot = await users.where("email", "==", email).get();
  if (userSnapshot.empty) {
    res.status(404).send("Email not found");
  } else {
    res.status(200).send("Email found");
  }
});
