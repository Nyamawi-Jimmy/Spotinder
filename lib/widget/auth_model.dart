import 'dart:convert';

import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';

class AuthModel extends ChangeNotifier {
  bool _isLogIn = false;
  Map <String,dynamic> user={};
  List <dynamic> _exam=[];

  bool get isLogin{
    return _isLogIn;
  }

  List <dynamic> get getExam{
    return _exam;
  }

  Map <String,dynamic> get getUser{
    return user;
  }

  void setFavExam(List <dynamic> list){
    _exam=list;
    notifyListeners();
  }

  void loginSuccess(){
    _isLogIn=true;
/*  user=examData;
  _exam = json.decode(user['Category']);*/
    notifyListeners();
  }
}