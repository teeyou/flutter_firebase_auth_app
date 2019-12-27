import 'package:flutter/material.dart';

class JoinOrLogin extends ChangeNotifier {
  bool _isJoin = false;

  get isJoin => _isJoin;

  toggle() {
    _isJoin = !_isJoin;
    notifyListeners();
  }
}