import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin/models/UserData.dart';

class FirestoreServices {
  final CollectionReference _usersCollectionReference =
      FirebaseFirestore.instance.collection("users");

  Future createUser(UserData user) async {
    try {
      await _usersCollectionReference.doc(user.id).set(user.toJson());
    } catch (e) {
      print(e.message);
    }
  }

  Future<bool> searchUser(String uid) async {
    bool exists = false;
    try {
      await _usersCollectionReference.doc(uid).get().then((doc) {
        if (doc.exists)
          exists = true;
        else
          exists = false;
      });
      return exists;
    } catch (e) {
      print(e.message);
      return false;
    }
  }

  Future<UserData> getCurrentUser(String uid) async {
    UserData data;
    try {
      await _usersCollectionReference.doc(uid).get().then((doc) {
        Map<String, dynamic> d = doc.data();
        data = UserData.fromJson(d);
      });
    } catch (e) {
      print(e.toString());
    }
    return data;
  }
}
