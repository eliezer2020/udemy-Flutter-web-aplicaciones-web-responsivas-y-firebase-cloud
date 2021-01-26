//Cloud noSQL database , needs UserID

import 'package:notes_webapp/models/note_model.dart';
import 'package:notes_webapp/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Firestore {
  Firestore(this.userObject);

  final User userObject;

  final firestore = FirebaseFirestore.instance;
  String path;
  String uid;

  //refresh user data and path
  void initUserPath() {
    this.uid = userObject.getCurrentUser();
    this.path = "users/$uid";
    print("making userpath ..." + path);
  }

  //create DB , set username
  Future<void> makeUserDB() async {
    initUserPath();
    print("making DB");
    await firestore
        .doc(path)
        .set({"username": "${userObject.username}"}).catchError(print);
  }

  // get streamsocket from firebase that contains document snapshots

  Stream<List<Note>> fetchStreamData() {
    initUserPath();
    print("getting firebase stream" + path);

    return firestore.collection(path + "/notes").snapshots().map(
        (snapshotList) =>
            snapshotList.docs.map((item) => Note.fromDocs(item)).toList());
  }

  //CRUD functions

  firebaseCREATE(Note data) async {
    await firestore.collection(path + "/notes").add({
      "title": "${data.title}",
      "body": "${data.body}",
    }).then((result) {
      data.documentID = result.id;
      print(" +1 added to firestore " + result.id);
    }).catchError(print);
  }

  firebaseDELETE(Note data) async {
    await firestore
        .collection(path + "/notes")
        .doc(data.documentID)
        .delete()
        .then((value) {
      print("successfully deleted " + data.title);
    }).catchError(print);
  }

  firebaseUPDATE(Note data) async {
    await firestore
        .collection(path + "/notes")
        .doc(data.documentID)
        .update(data.toMap())
        .then((value) {
      print("${data.title} successfully updated");
    }).catchError(print);
  }

  Future<String> getFirebaseUsername() async {
    String _username;

    await firestore
        .collection("users")
        .doc(this.userObject.userID)
        .get()
        .then((doc) {
      final docMapped = doc.data();
      _username = docMapped["username"];
      print("fetch user: " + _username);
    }).catchError(print);

    return _username;
  }
}
