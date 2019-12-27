import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgetPw extends StatefulWidget {
  @override
  _ForgetPwState createState() => _ForgetPwState();
}

class _ForgetPwState extends State<ForgetPw> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forget Password'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please input correct Email.';
                }
                return null;
              },
              controller: _emailController,
              decoration: InputDecoration(
                  icon: Icon(Icons.account_circle), labelText: 'Email'),
            ),
            FlatButton(
              child: Text('Reset Password'),
              onPressed: () async {
                await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text);
                final snackBar = SnackBar(
                  content: Text('Check your email for pw reset.'),
                );
                Scaffold.of(_formKey.currentContext).showSnackBar(snackBar);
              },
            )
          ],
        ),
      ),
    );
  }
}
