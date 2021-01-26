import 'package:flutter/material.dart';
import 'package:notes_webapp/controllers/note_controller.dart';
import 'package:notes_webapp/models/note_model.dart';
import 'package:notes_webapp/utils/date_utils.dart';
import 'package:notes_webapp/widgets/CustomAlert_widget.dart';
import 'package:provider/provider.dart';

Widget menuNotes(BuildContext context, Stream<List<Note>> suscribedStream) {
  return Card(
    elevation: 8.0,
    color: Colors.blue[50],
    child: Column(
      children: [
        Container(
          height: 80,
          width: double.infinity,
          color: Colors.blue[100],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                  heroTag: "tag0",
                  tooltip: "add new",
                  elevation: 2.0,
                  backgroundColor: Colors.transparent,
                  child: Icon(Icons.add),
                  onPressed: () {
                    String _dateNow = getCustomDate();
                    onCreateAlert(context, _dateNow);
                  }),
              Text("Menu Notes"),
              SizedBox(
                width: 30.0,
              ),
            ],
          ),
        ),
        Expanded(
            child: Container(
          //declares type
          child: StreamBuilder<List<Note>>(
            stream: suscribedStream,
            initialData: [],
            builder: (context, snapshot) {
              if (snapshot.data.length == 0) {
                return Container(
                  child: ListTile(
                    onTap: null,
                    leading: Icon(
                      Icons.file_copy,
                      color: Colors.blueGrey,
                    ),
                    title: Text("no data..."),
                  ),
                );
              } else {
                return Scrollbar(
                    child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, i) => ListTile(
                              leading: Icon(
                                Icons.file_copy,
                                color: Colors.blueGrey,
                              ),
                              title: Text(snapshot.data[i].title),
                              onTap: () {
                                Note thisNote = snapshot.data[i];

                                Provider.of<NoteController>(context,
                                        listen: false)
                                    .setSelectedNote(thisNote);
                              },
                            )));
              }
            },
          ),
        )),
        buildFooter(),
      ],
    ),
  );
}

buildFooter() {
  return Container(
    color: Colors.blueGrey[300],
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.arrow_drop_down_sharp,
          color: Colors.blueGrey[400],
        ),
        Icon(
          Icons.arrow_drop_down_sharp,
          color: Colors.blueGrey[400],
        ),
      ],
    ),
  );
}
