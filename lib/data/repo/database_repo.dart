import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/user_info_model.dart';

class DatabaseRepository {
  final String uid;

  DatabaseRepository({required this.uid});

  final CollectionReference _collectionReference = FirebaseFirestore.instance.collection('users');

  Future<void> updateUserRecord({String? name, String? phone, String? gmail}) async {
    await _collectionReference.doc(uid).set({
      'name': name,
      'phone': phone,
      'gmail': gmail,
    });
  }

  Future<void> getUserFcmToken({required String token}) async {
    await _collectionReference.doc(uid).set({
      'userFcmToken': token,
    });
  }

  Stream<List<UserInfoModel>> getUserRecord() {
    return _collectionReference.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return UserInfoModel.fromMap(data);
      }).toList();
    });
  }

  // Stream<QuerySnapshot> get brewCollection => _collectionReference.snapshots();
}
