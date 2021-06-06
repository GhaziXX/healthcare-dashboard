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
      await _usersCollectionReference.doc(uid).get().then((doc) {
        Map<String, dynamic> d = doc.data();
        data = UserData.fromJson(d);
        return data;
      });
    } catch (e) {
      print(e.toString());
    }
    return data;
  }

  Future<bool> isUserConnected({String uid}) async {
    bool isConnected;
    try {
      await _usersCollectionReference.doc(uid).get().then((doc) {
        Map<String, dynamic> d = doc.data();
        isConnected = d["isConnected"] as bool;
        return isConnected;
      });
    } catch (e) {
      print(e.toString());
    }
    return isConnected;
  }

  Future<String> getUserId({String first4, String gid}) async {
    String id;
    bool isReal;
    try {
      await _usersCollectionReference.get().then((doc) {
        doc.docs.forEach((element) {
          print(element.id);
          if (element.id.startsWith(first4)) {
            id = element.id;
            return element.id;
          }
        });
      });
    } catch (e) {
      print("fama mochkel ${e.toString()}");
    }
    try {
      if (id != null) {
        await getUserData(uid: id)
            .then((value) => value.gid == gid ? isReal = true : isReal = false);
      }
    } catch (e) {
      print("fama mochkel ${e.toString()}");
    }

    return (id != null || isReal == false) ? id : "No user found";
  }

  Future<List<UserData>> getUsersData({List<dynamic> uids}) async {
    List<UserData> datas;
    UserData data;
    try {
      uids.forEach((uid) {
        _usersCollectionReference.doc(uid).get().then((doc) {
          Map<String, dynamic> d = doc.data();
          data = UserData.fromJson(d);
          datas.add(data);
        });
      });
    } catch (e) {
      print("Fama error ${e.toString()}");
    }
    return datas;
  }

  Future<bool> deleteIdInOthersId({String currentId, String otherId}) async {
    try {
      await _usersCollectionReference.doc(currentId).update({
        'otherIds': FieldValue.arrayRemove([otherId])
      }).then((value) {
        return true;
      });
    } catch (e) {
      print(e.toString());
    }
    return false;
  }

  Future<List<UserData>> getUsersDataFromCurrentUserId(
      {String currentUid}) async {
    List<UserData> userDatas;
    try {
      await getUserData(uid: currentUid).then((value) async {
        await getUsersData(uids: value.otherIds)
            .then((value) => userDatas = value);
      });
    } on Exception catch (e) {
      print("fama mochkla $e");
    }
    return userDatas;
  }

  Future<void> setConnectionStatus({String userId, bool isConnected}) async {
    try {
      await _usersCollectionReference
          .doc(userId)
          .update({'isConnected': isConnected});
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updatePhotoURL({String userId, String url}) async {
    try {
      await _usersCollectionReference.doc(userId).update({'photoURL': url});
    } catch (e) {
      print(e.toString());
    }
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
