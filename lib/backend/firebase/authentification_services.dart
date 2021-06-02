import 'package:admin/backend/notifiers/auth_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

signOut(AuthNotifier authNotifier) async {
  await FirebaseAuth.instance.signOut();
  authNotifier.setUser(null);
}

Future<String> signIn(
    {String email, String password, AuthNotifier authNotifier}) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    authNotifier.setUser(FirebaseAuth.instance.currentUser);
    return "Signed in";
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      return 'No user found for that email.';
    } else if (e.code == 'wrong-password') {
      return 'Wrong password provided.';
    } else {
      return 'An error has occured, Please try again.';
    }
  }
}

Future<bool> checkSignIn({String email, String password}) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return true;
  } on FirebaseAuthException catch (e) {
    print(e);
    return false;
  }
}

Future<bool> updateProfile({String imageURI}) async {
  User currentUser = FirebaseAuth.instance.currentUser;
  try {
    await currentUser.updateProfile(photoURL: imageURI);
    return true;
  } on FirebaseAuthException catch (e) {
    print(e);
    return false;
  }
}

bool updateEmail({String email}) {
  bool result;
  User currentUser = FirebaseAuth.instance.currentUser;

  currentUser.updateEmail(email).then((value) {
    result = true;
  }).catchError((onError) {
    result = false;
    print("value is $onError");
  });
  return result;
}

bool resetPassword(String password) {
  bool result;
  User currentUser = FirebaseAuth.instance.currentUser;
  currentUser
      .updatePassword(password)
      .then((value) => result = true)
      .catchError((onError) => result = false);
  return result;
}

initCurrentUser(AuthNotifier authNotifier) {
  User user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    print("notifiying");
    authNotifier.setUser(user);
  }
}

notifyUser(AuthNotifier authNotifier) async {
  User user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    authNotifier.setUser(user);
  }
}

Future<String> signUp(
    {String email, String password, AuthNotifier authNotifier}) async {
  try {
    UserCredential uc = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    authNotifier.setUserWithoutNotif(FirebaseAuth.instance.currentUser);
    await FirebaseChatCore.instance
        .createUserInFirestore(types.User(id: uc.user.uid));
    return "Signed Up";
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      return 'The password provided is too weak.';
    } else if (e.code == 'email-already-in-use') {
      return 'An account already exists for that email.';
    } else {
      return 'An error has occured, Please try again.';
    }
  }
}
