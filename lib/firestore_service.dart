import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveAuthCode(String code) async {
    await _db.collection('authCodes').add({'code': code});
  }

  Future<String?> getAuthCode() async {
    final snapshot = await _db.collection('authCodes').get();
    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.data()['code'];
    }
    return null;
  }
}
