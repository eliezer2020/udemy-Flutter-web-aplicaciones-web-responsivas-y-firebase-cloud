import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_webapp/firebase/authentication_service.dart';
import 'package:notes_webapp/firebase/firestore_service.dart';
import 'package:notes_webapp/models/user_model.dart';
import 'package:notes_webapp/widgets/CustomAlert_widget.dart';
import 'package:notes_webapp/widgets/CustomHyperLink_widget.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void dispose() {
    _formKey.currentState.dispose();
    super.dispose();
  }

  var _emailController = new TextEditingController();
  var _passController = new TextEditingController();
  var _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      //disable back button
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.blueGrey.shade100,
        body: Center(
          child: SizedBox(
            height: 300,
            width: 280,
            child: Card(
              elevation: 20.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Welcome to Note App",
                          style: Theme.of(context).textTheme.headline6),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: "Email: ",
                          hintText: "example@expample.com",
                        ),
                        //autovalide=false,
                        autovalidateMode: AutovalidateMode.disabled,
                        validator: (String value) {
                          return (!value.contains("@"))
                              ? "Enter valid Email"
                              : null;
                        },
                      ),
                      TextFormField(
                        obscureText: true,
                        controller: _passController,
                        decoration: InputDecoration(
                          labelText: "Password: ",
                        ),
                        //autovalide=false,
                        autovalidateMode: AutovalidateMode.disabled,
                        validator: (String value) {
                          return (value.isEmpty) ? "Enter Password" : null;
                        },
                      ),
                      Spacer(),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomHyperLink(
                              label: "create account",
                              defaultColor: Colors.blue,
                              hoverColor: Colors.purple,
                              callback: () {
                                Navigator.of(context)
                                    .pushNamed("/registerpage");
                              },
                            ),
                            FlatButton(
                              color: Colors.blue,
                              onPressed: () async {
                                print("on login clicked....");
                                _formKey.currentState.validate();
                                if (_formKey.currentState.validate()) {
                                  onAlertWait(context);

                                  List<dynamic> results =
                                      await Provider.of<Authentication>(context,
                                              listen: false)
                                          .loginWithErrorMessage(
                                              _emailController.text,
                                              _passController.text);
                                  print(results[0]);
                                  if (results[0] == "success") {
                                    //1. building user from map
                                    Provider.of<User>(context, listen: false)
                                        .setFromMap(results[1]);

                                    //2.  make user path
                                    Provider.of<Firestore>(context,
                                            listen: false)
                                        .initUserPath();
                                    //3. get username
                                    String _username =
                                        await Provider.of<Firestore>(context,
                                                listen: false)
                                            .getFirebaseUsername();
                                    //4. set username
                                    Provider.of<User>(context, listen: false)
                                        .setUsername(_username);

                                    //END STEP navigate to homepage
                                    Navigator.of(context)
                                        .pushNamed("/homepage");
                                  } else {
                                    onErrorAuth(context, results[0]);
                                  }
                                }
                              },
                              child: Text("login"),
                              hoverColor: Colors.blue[300],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
