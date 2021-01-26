import 'package:flutter/material.dart';
import 'package:notes_webapp/controllers/note_controller.dart';
import 'package:notes_webapp/firebase/firestore_service.dart';
import 'package:notes_webapp/models/note_model.dart';
import 'package:notes_webapp/widgets/CustomAlert_widget.dart';
import 'package:provider/provider.dart';

Widget detailNotes(BuildContext context) {
  ScrollController _myScroll = new ScrollController();

  return Container(
    child: Card(
      elevation: 8.0,
      color: Colors.yellow[50],
      child: Column(
        children: [
          appbarDetail(context),
          Expanded(
            child: SingleChildScrollView(
              controller: _myScroll,
              scrollDirection: Axis.vertical,
              child: Container(
                padding: EdgeInsets.all(20),
                child: TextField(
                  decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                    color: Colors.blue,
                  ))),
                  scrollController: _myScroll,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: Provider.of<NoteController>(context, listen: true)
                      .myTextController,
                  enabled: Provider.of<NoteController>(context, listen: true)
                      .editing,
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );
}

Widget appbarDetail(BuildContext context) {
  return Container(
    height: 80,
    color: Colors.yellow[100],
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text("Detail Notes"),
        SizedBox(
          width: 30.0,
        ),
        FloatingActionButton(
          tooltip: "edit",
          heroTag: "tag1",
          elevation: 2.0,
          hoverColor: Colors.blue[200],
          backgroundColor: Colors.transparent,
          mini: true,
          onPressed: () {
            Provider.of<NoteController>(context, listen: false).enableEditing();
          },
          child: Icon(
            Icons.edit,
            color: Colors.blue[400],
          ),
        ),
        FloatingActionButton(
          heroTag: "tag2",
          tooltip: "save",
          elevation: 2.0,
          hoverColor: Colors.blue[200],
          backgroundColor: Colors.transparent,
          mini: true,
          onPressed: () async {
            Note currentNote =
                Provider.of<NoteController>(context, listen: false)
                    .getSelectedNote();
            //save -> firebaseUpdate

            currentNote.body =
                Provider.of<NoteController>(context, listen: false)
                    .myTextController
                    .text;

            Provider.of<NoteController>(context, listen: false).enableEditing();

            //crud firebase
            await Provider.of<Firestore>(context, listen: false)
                .firebaseUPDATE(currentNote);
          },
          child: Icon(
            Icons.save,
            color: Colors.blue[400],
          ),
        ),
        FloatingActionButton(
          tooltip: "delete",
          heroTag: "tag3",
          elevation: 2.0,
          hoverColor: Colors.red[200],
          backgroundColor: Colors.transparent,
          mini: true,
          onPressed: () {
            //delete -> firebasedelete
            onDeleteAlert(context, "Do you want to delete this note?");
          },
          child: Icon(
            Icons.delete,
            color: Colors.red[400],
          ),
        ),
        SizedBox(
          width: 30.0,
        ),
      ],
    ),
  );
}
