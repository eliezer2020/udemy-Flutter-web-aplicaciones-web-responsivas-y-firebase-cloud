import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:notes_webapp/controllers/note_controller.dart';
import 'package:notes_webapp/firebase/firestore_service.dart';
import 'package:notes_webapp/models/note_model.dart';
import 'package:provider/provider.dart';

onAlertWait(BuildContext context) {
  showDialog(
      context: context,
      child: SimpleDialog(
        title: Center(
          child: Column(
            children: [
              Text("Please wait..."),
              Container(
                width: 150,
                height: 150,
                child: Image.asset("assets/Loading_2.gif"),
              ),
            ],
          ),
        ),
      ));
}

onErrorAuth(BuildContext context, String error) {
  showDialog(
    context: context,
    child: SimpleDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(
            Icons.error,
            color: Colors.red,
          ),
          Text("Error on Authentication"),
        ],
      ),
      children: [
        SimpleDialogOption(
          child: Container(
            width: 350.0,
            child: Text(error),
          ),
        ),
        SimpleDialogOption(
          child: FlatButton(
            color: Colors.blueAccent,
            onPressed: () => Navigator.of(context).popAndPushNamed("/"),
            child: Text("okey"),
          ),
        )
      ],
    ),
  );
}

onCreateAlert(BuildContext context, String texto) {
  final titleController = TextEditingController();
  titleController.text = texto;

  showDialog(
      context: context,
      child: SimpleDialog(
        title: Row(
          children: [
            Icon(
              Icons.file_copy,
              color: Colors.blueGrey,
            ),
            Center(
              child: Text("New Note"),
            )
          ],
        ),
        children: [
          Container(
            padding: EdgeInsets.all(15),
            child: TextFormField(
              //show editable
              autofocus: true,
              controller: titleController,
              decoration: InputDecoration(
                labelStyle: TextStyle(
                  color: Colors.blue,
                ),
                labelText: "title",
                hintText: "add title",
              ),
              autovalidateMode: AutovalidateMode.disabled,
            ),
          ),
          SimpleDialogOption(
            child: FlatButton(
                onPressed: () {
                  //create new note

                  final newNote = new Note(
                    body: "...",
                    title: titleController.text,
                  );

                  Provider.of<Firestore>(context, listen: false)
                      .firebaseCREATE(newNote);

                  Provider.of<NoteController>(context, listen: false)
                      .setSelectedNote(newNote);
                  Navigator.of(context).pop();
                },
                color: Colors.blueAccent,
                child: Text("Accept")),
          ),
        ],
      ));
}

onDeleteAlert(BuildContext context, String texto) {
  showDialog(
    context: context,
    child: SimpleDialog(
      children: [
        SimpleDialogOption(
          child: Container(
            width: 350.0,
            child: Text(texto),
          ),
        ),
        SimpleDialogOption(
          child: Container(
            padding: EdgeInsets.only(right: 60, left: 60),
            child: FlatButton(
              color: Colors.blueAccent,
              onPressed: () async {
                Note currentNote =
                    Provider.of<NoteController>(context, listen: false)
                        .getSelectedNote();
                await Provider.of<Firestore>(context, listen: false)
                    .firebaseDELETE(currentNote);

                //clear noteController
                Provider.of<NoteController>(context, listen: false)
                    .disposeNoteController();

                //end step
                Navigator.of(context).pop();
              },
              child: Text("okey"),
            ),
          ),
        )
      ],
    ),
  );
}
