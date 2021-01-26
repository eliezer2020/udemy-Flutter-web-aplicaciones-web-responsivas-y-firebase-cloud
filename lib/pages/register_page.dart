import 'package:flutter/material.dart';
import 'package:notes_webapp/firebase/authentication_service.dart';
import 'package:notes_webapp/firebase/firestore_service.dart';
import 'package:notes_webapp/models/user_model.dart';
import 'package:notes_webapp/widgets/CustomAlert_widget.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  void dispose() {
    _formKey.currentState.dispose();
    super.dispose();
  }

  var _emailController = new TextEditingController();
  var _passController = new TextEditingController();
  var _nameController = new TextEditingController();
  var _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade100,
      body: Center(
        child: SizedBox(
          height: 420,
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
                    Text("User Register",
                        style: Theme.of(context).textTheme.headline6),
                    SizedBox(
                      height: 50,
                    ),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: "Username: ",
                      ),
                      //autovalide=false,
                      autovalidateMode: AutovalidateMode.disabled,
                      validator: (String value) {
                        return (value.isEmpty) ? "Enter username" : null;
                      },
                    ),
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
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FlatButton(
                            color: Colors.blue,
                            onPressed: () async {
                              _formKey.currentState.validate();

                              if (_formKey.currentState.validate()) {
                                print(_emailController.text +
                                    _passController.text);

                                onAlertWait(context);

                                //User register AUTH_FIRESBASE
                                final List<dynamic> results =
                                    await Provider.of<Authentication>(context,
                                            listen: false)
                                        .newUserWithErrorMessage(
                                            _nameController.text,
                                            _emailController.text,
                                            _passController.text);

                                if (results[0] == "success") {
                                  //1. set user from map
                                  Provider.of<User>(context, listen: false)
                                      .setFromMap(results[1]);
                                  //2. set username for 1st time, DB needed
                                  Provider.of<User>(context, listen: false)
                                      .setUsername(_nameController.text);
                                  //3. make user path
                                  await Provider.of<Firestore>(context,
                                          listen: false)
                                      .makeUserDB();

                                  //END STED navigate to homepage
                                  Navigator.of(context).pushNamed("/homepage");
                                } else {
                                  onErrorAuth(context, results[0]);
                                }
                              }
                            },
                            child: Text("Register"),
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
    );
  }
}
