import 'package:flutter/material.dart';
import 'package:notes_webapp/firebase/firestore_service.dart';
import 'package:notes_webapp/models/user_model.dart';
import 'package:notes_webapp/pages/home_page.dart';
import 'package:notes_webapp/pages/login_page.dart';
import 'package:notes_webapp/pages/register_page.dart';
import 'package:notes_webapp/pages/unknown_page.dart';
import 'package:notes_webapp/widgets/CustomHyperLink_widget.dart';
import 'package:provider/provider.dart';

class PageRouter extends StatelessWidget {
  final String parseRoute;

  PageRouter(this.parseRoute);
  @override
  Widget build(BuildContext context) {
    //1. verify mobile screen

    final screenSize = MediaQuery.of(context).size.width;
    if (screenSize < 768) return mobileAlert;

    //2. verify is user has login
    String userID = Provider.of<User>(context, listen: false).getCurrentUser();
    print("Routing user = $userID");

    if (parseRoute == "/") {
      return LoginPage();
    } else if (parseRoute == "/registerpage") {
      return RegisterPage();
    } else if (parseRoute == "/homepage" && userID != "Empty") {
      final _myFirebaseStream =
          Provider.of<Firestore>(context, listen: true).fetchStreamData();

      return HomePage(
        myFirebaseStream: _myFirebaseStream,
      );
    } else {
      return Unknowpage(routname: parseRoute);
    }
  }
}

final mobileAlert = Material(
  child: Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("This app only works on full screen"),
        Text("for mobile devices download it here"),
        CustomHyperLink(
          callback: () {},
          defaultColor: Colors.blue,
          hoverColor: Colors.purple,
          label: "soon...",
        ),
      ],
    ),
  ),
);
