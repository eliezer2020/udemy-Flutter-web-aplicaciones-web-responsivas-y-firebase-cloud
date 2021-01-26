import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  String title;
  String body;
  String documentID;

  //constructor
  Note({this.title, this.body, this.documentID});

  //convert to map
  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "body": body,
      "documentID": documentID,
    };
  }

  static Note fromDocs(DocumentSnapshot docs) {
    //verify if documents exist
    if (!docs.exists) return null;

    //holds document inside map
    final docMapped = docs.data();

    return Note(
      title: docMapped["title"],
      body: docMapped["body"],
      documentID: docs.id,
    );
  }
}
