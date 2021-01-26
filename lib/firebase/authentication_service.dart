//auth service for login and new accounts
import 'package:firebase_auth/firebase_auth.dart' as fb;

class Authentication {
  //control firebase auth instance
  final authInstance = fb.FirebaseAuth.instance;

  //user credential
  var credential = fb.UserCredential;

  String resultMessage;

  fb.User newUser;
// FirebaseAuthException:
//      this.message,
//       this.code,
//       this.email,
//       this.credential,

// new user = [resultMassage, UserMap]
  Future<List<dynamic>> newUserWithErrorMessage(
      String _username, String _email, String _pass) async {
    credential = await authInstance
        .createUserWithEmailAndPassword(email: _email, password: _pass)
        .then((result) {
      newUser = result.user;
      resultMessage = "success";
      print("succes creating user " + newUser.uid);
    }).catchError((e) {
      print(e.message);
      resultMessage = e.message;
    });

    return [resultMessage, userToMap(newUser)];
  }

  //login user = [resultMassage, UserMap]
  Future<List<dynamic>> loginWithErrorMessage(
      String _email, String _pass) async {
    credential = await authInstance
        .signInWithEmailAndPassword(email: _email, password: _pass)
        .then((result) {
      newUser = result.user;
      resultMessage = "success";
      print("success " + newUser.uid);
    }).catchError((e) {
      print(e.message);
      resultMessage = e.message;
    });

    return [resultMessage, userToMap(newUser)];
  }

  //logout
  singOut() async {
    await authInstance.signOut().then((value) => null).catchError(print);
  }

  Map<String, dynamic> userToMap(fb.User _user) {
    if (_user == null) return {};
    print("user to map :" + _user.uid);
    return {
      "userID": _user.uid,
      "username": "",
      "email": _user.email,
    };
  }
}
