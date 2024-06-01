import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createUser(String userId, String name) async {
    await _db.collection('users').doc(userId).set({
      'name': name,
    });
  }

  Future<DocumentSnapshot> getUser(String userId) async {
    return _db.collection('users').doc(userId).get();
  }
}