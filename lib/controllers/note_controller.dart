//controls NOte UI

import 'package:flutter/material.dart';
import 'package:notes_webapp/models/note_model.dart';

class NoteController extends ChangeNotifier {
  bool editing = false;
  TextEditingController myTextController = new TextEditingController();
  Note selectedNote;

  //Edit textfield
  void enableEditing() {
    editing = (editing == true) ? false : true;
    notifyListeners();
  }

  void setSelectedNote(Note note) {
    editing = false;
    selectedNote = note;
    myTextController.text = note.body;
    notifyListeners();
  }

  Note getSelectedNote() => this.selectedNote;

  void disposeNoteController() {
    this.myTextController.clear();
  }
}
