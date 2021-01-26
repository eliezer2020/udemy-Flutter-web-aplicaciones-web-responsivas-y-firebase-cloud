import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_webapp/controllers/note_controller.dart';
import 'package:notes_webapp/firebase/authentication_service.dart';

import 'package:notes_webapp/models/user_model.dart';
import 'package:notes_webapp/widgets/DetaiNotes_widget.dart';
import 'package:notes_webapp/widgets/MenuNotes_widget.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  final Stream myFirebaseStream;

  const HomePage({Key key, this.myFirebaseStream}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      //disable back button
      onWillPop: () async => false,
      child: Scaffold(
        appBar: _customAppbar(context),
        body: Container(
          padding: EdgeInsets.all(25),
          child: Row(children: [
            Expanded(flex: 3, child: menuNotes(context, myFirebaseStream)),
            Expanded(flex: 1, child: Container()),
            Expanded(flex: 5, child: detailNotes(context)),
          ]),
        ),
      ),
    );
  }

  _customAppbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      actions: [
        Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Icon(
            Icons.person,
            color: Colors.blue,
          ),
        ),
        Center(
          child: Text(
            Provider.of<User>(context, listen: false).username,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        Spacer(),
        Center(
          child: Text(
            "Logout",
            style: TextStyle(color: Colors.blueAccent),
          ),
        ),
        IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.blueAccent,
            ),
            onPressed: () {
              //logout
              //1. firebase logout
              Provider.of<Authentication>(context, listen: false).singOut();
              //2.clear user
              Provider.of<User>(context, listen: false).clearUser();
              //3.dispose note controller
              Provider.of<NoteController>(context, listen: false)
                  .disposeNoteController();
              //navigate to login
              Navigator.of(context).popAndPushNamed("/");
            }),
        Container(
          width: 20.0,
        ),
      ],
    );
  }
}
