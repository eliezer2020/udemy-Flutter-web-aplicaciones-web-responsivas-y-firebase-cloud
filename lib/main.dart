import 'package:flutter/material.dart';
import 'package:notes_webapp/controllers/note_controller.dart';
import 'package:notes_webapp/firebase/authentication_service.dart';
import 'package:notes_webapp/firebase/firestore_service.dart';

import 'package:notes_webapp/models/user_model.dart';
import 'package:notes_webapp/pages/home_page.dart';

import 'package:notes_webapp/pages/unknown_page.dart';
import 'package:notes_webapp/widgets/CustomHyperLink_widget.dart';
import 'package:notes_webapp/widgets/pageRouter_widget.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //user provider
        Provider<User>(
          create: (context) => new User(),
        ),

        //auth service
        Provider<Authentication>(create: (context) => new Authentication()),

        //firestore service
        ProxyProvider<User, Firestore>(
          update: (_, user, __) => new Firestore(user),
        ),

        //note controller
        ChangeNotifierProvider<NoteController>(
            create: (_) => new NoteController()),
      ],
      child: MaterialApp(
        title: "Note APP",
        debugShowCheckedModeBanner: false,
        home: PageRouter("/"),
        onUnknownRoute: (settings) {
          return MaterialPageRoute(
              builder: (context) => Unknowpage(
                    routname: settings.name,
                  ));
        },
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
              builder: (context) => PageRouter(settings.name));
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Container(
        child: Center(
          child: CustomHyperLink(
            callback: () {},
            hoverColor: Colors.purple,
            defaultColor: Colors.white,
            label: "myCUstom Link ",
          ),
        ),
      ),
    );
  }
}
