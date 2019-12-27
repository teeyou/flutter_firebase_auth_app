import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_app/data/join_or_login.dart';
import 'package:flutter_firebase_auth_app/helper/login_background.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'forget_pw.dart';
import 'main_page.dart';

class AuthPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size; //핸드폰의 사이즈를 가져옴

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          CustomPaint(
            size: size,
            painter: LoginBackground(
                isJoin: Provider.of<JoinOrLogin>(context).isJoin),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              _logoImage,
              //FadeInImage.assetNetwork(placeholder: 'assets/loading.gif', image: 'https://media.tenor.com/images/ccd360cf0f0b2cbca098ef79e328d177/tenor.gif'),
              //Image.asset('assets/loading.gif'),
              Stack(
                children: <Widget>[
                  _inputForm(size),
                  authButton(size),
                ],
              ),
              Container(height: size.height * 0.10),
              Consumer<JoinOrLogin>(
                builder: (context, joinOrLogin, child) => GestureDetector(
                  onTap: () {
                    joinOrLogin.toggle();
                  },
                  child: Text(
                    joinOrLogin.isJoin
                        ? "Already Have an Account? Sign in"
                        : "Don't have an Account? Create One",
                    style: TextStyle(
                        color: joinOrLogin.isJoin ? Colors.red : Colors.blue),
                  ),
                ),
              ),
              Container(
                height: size.height * 0.05,
              )
            ],
          )
        ],
      ),
    );
  }

  _inputForm(Size size) {
    return Padding(
      padding: EdgeInsets.all(size.width * 0.05),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        elevation: 10.0,
        child: Padding(
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0, top: 16.0, bottom: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please input correct password.';
                    }
                    return null;
                  },
                  obscureText: true,
                  controller: _passwordController,
                  decoration: InputDecoration(
                      icon: Icon(Icons.vpn_key), labelText: 'Password'),
                ),
                Container(
                  height: 10,
                ),
                Consumer<JoinOrLogin>(
                  builder: (context, value, child) => Opacity(
                    opacity: value.isJoin? 0 : 1,
                      child: GestureDetector(
                        onTap: () {
                          value.isJoin? null :
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => ForgetPw(),
                          ));
                        },
                          child: Text('Forgot Password'))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  authButton(Size size) => Positioned(
        left: size.width * 0.6,
        right: size.width * 0.1,
        bottom: 0,
        child: SizedBox(
          height: 40,
          child: Consumer<JoinOrLogin>(
            builder: (context, value, child) => RaisedButton(
              //textColor: Colors.white,
              color: value.isJoin? Colors.red : Colors.blue,

              onPressed: () {
                if (_formKey.currentState.validate()) {
                  value.isJoin? _register(context) : _login(context);
                }
              },
              child: Text(
                value.isJoin? 'Join' : 'Login',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ),
      );

  _register(context) async {
    final AuthResult result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _emailController.text, password: _passwordController.text);
    final FirebaseUser user = result.user;

    if(user == null) {
      final snackBar = SnackBar(
        content: Text('Please try again later.'),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }

//    Navigator.push(context, MaterialPageRoute(
//      builder: (context) => MainPage(email: user.email)
//    ));
  }

  _login(context) async {
    final AuthResult result = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailController.text, password: _passwordController.text);
    final FirebaseUser user = result.user;

    if(user == null) {
      final snackBar = SnackBar(
        content: Text('Please try again later.'),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }

//    Navigator.push(context, MaterialPageRoute(
//        builder: (context) => MainPage(email: user.email)
//    ));
  }

  get _logoImage => Expanded(
        child: Padding(
          padding: EdgeInsets.only(top: 40, left: 24, right: 24),
          child: FittedBox(
            fit: BoxFit.contain,
            child: CircleAvatar(
              backgroundImage: NetworkImage(
//                  'https://i0.wp.com/hundredkorea.com/wp-content/uploads/2019/12/baekyerin-000-1.jpg?fit=540%2C804&ssl=1'),
              'https://media.tenor.com/images/ccd360cf0f0b2cbca098ef79e328d177/tenor.gif'),
            ),
          ),
        ),
      );
}
