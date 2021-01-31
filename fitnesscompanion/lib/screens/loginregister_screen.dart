import 'package:flutter/material.dart';
import '../api/firebase_api.dart';
import '../models/user_credentials.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

enum AuthMode { Register, Login }

class LoginRegister extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginRegisterState();
  }
}

class _LoginRegisterState extends State<LoginRegister> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  AuthMode _authMode = AuthMode.Login;

  UserCredentials _userCredentials = UserCredentials();

  void _submitForm() {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    if (_authMode == AuthMode.Login) {
      login(_userCredentials);
    } else {
      signup(_userCredentials);
    }
  }

  Widget _buildEmailField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Email",
        labelStyle: TextStyle(color: Colors.white),
      ),
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(fontSize: 16, color: Colors.white),
      cursorColor: Colors.white,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Email is required';
        }

        if (!RegExp(
                r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
          return 'Please enter a valid email address';
        }

        return null;
      },
      onSaved: (String value) {
        _userCredentials.email = value;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Password",
        labelStyle: TextStyle(color: Colors.white),
      ),
      style: TextStyle(fontSize: 16, color: Colors.white),
      cursorColor: Colors.white,
      obscureText: true,
      controller: _passwordController,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Password is required';
        }

        if (value.length < 6 || value.length > 20) {
          return 'Password must be betweem 5 and 20 characters';
        }

        return null;
      },
      onSaved: (String value) {
        _userCredentials.password = value;
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Confirm Password",
        labelStyle: TextStyle(color: Colors.white),
      ),
      style: TextStyle(fontSize: 16, color: Colors.white),
      cursorColor: Colors.white,
      obscureText: true,
      validator: (String value) {
        if (_passwordController.text != value) {
          return 'Passwords do not match';
        }

        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[900],
      resizeToAvoidBottomPadding: false,
      body: Container(
        padding: EdgeInsets.all(16),
        child: Form(
          autovalidateMode: AutovalidateMode.always,
          key: _formKey,
          child: Neumorphic(
            style: NeumorphicStyle(
              border: NeumorphicBorder(
                  isEnabled: true, width: 2, color: Colors.deepPurple[700]),
              oppositeShadowLightSource: false,
              shadowLightColor: Colors.deepPurple[900],
              color: Colors.deepPurple[900],
              depth: 0,
            ),
            padding: EdgeInsets.fromLTRB(16, 32, 16, 16),
            margin: EdgeInsets.only(top: 32),
            child: Column(
              children: <Widget>[
                Neumorphic(
                  padding: EdgeInsets.all(8),
                  style: NeumorphicStyle(
                      shadowLightColor: Colors.deepPurple[700],
                      oppositeShadowLightSource: false,
                      color: Colors.deepPurple[900],
                      boxShape: NeumorphicBoxShape.circle()),
                  child: Neumorphic(
                    padding: EdgeInsets.all(8),
                    style: NeumorphicStyle(
                        shadowLightColor: Colors.deepPurple[700],
                        oppositeShadowLightSource: false,
                        color: Colors.deepPurple[900],
                        boxShape: NeumorphicBoxShape.circle()),
                    child: Image.asset(
                      'assets/launcher_icon.png',
                      scale: 4,
                    ),
                  ),
                ),
                SizedBox(height: 32),
                _buildEmailField(),
                _buildPasswordField(),
                _authMode == AuthMode.Register
                    ? _buildConfirmPasswordField()
                    : Container(),
                Expanded(child: Container()),
                ButtonTheme(
                  minWidth: 200,
                  child: RaisedButton(
                    padding: EdgeInsets.all(8.0),
                    onPressed: () => _submitForm(),
                    child: Text(
                      _authMode == AuthMode.Login ? 'Login' : 'Register',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                ButtonTheme(
                  child: FlatButton(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      '${_authMode == AuthMode.Login ? 'No account yet? Register here!' : 'Already registered? Login here!'}',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordController.clear();
                        _authMode = _authMode == AuthMode.Login
                            ? AuthMode.Register
                            : AuthMode.Login;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
