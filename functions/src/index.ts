import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import * as corsLib from 'cors';

const cors = corsLib({ origin: true });

admin.initializeApp();

export const getAuthCode = functions.https.onRequest((request, response) => {
  cors(request, response, () => {
    const authCode = request.query.code as string | undefined;
    if (authCode) {
      response.json({ code: authCode });
    } else {
      response.status(400).send('No auth code provided');
    }
  });
});
