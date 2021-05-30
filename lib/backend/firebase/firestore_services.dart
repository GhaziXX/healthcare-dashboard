import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin/models/data_models/UserData.dart';

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

  Future<UserData> getUserData({String uid}) async {
    UserData data;
    try {
      searchUser(uid).then((value) async {
        if (value == true) {
          await _usersCollectionReference.doc(uid).get().then((doc) {
            Map<String, dynamic> d = doc.data();
            data = UserData.fromJson(d);
          });
        } else {
          data = null;
        }
      });
    } catch (e) {
      print(e.toString());
    }
    return data;
  }

  Future<bool> addOtherId({String currentUserId, String otherID}) async {
    try {
      await _usersCollectionReference.doc(currentUserId).update({
        'otherIds': FieldValue.arrayUnion([otherID])
      }).then((value) {
        return true;
      });
    } catch (e) {
      print(e.toString());
    }
    return false;
  }
}
