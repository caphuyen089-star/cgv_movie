import 'package:flutter/material.dart';
import '../model/user.dart';

class UserProvider extends ChangeNotifier {

  User? _user;

  User? get user => _user;

  bool get isLogin => _user != null;

  void login(User value){

    _user=value;

    notifyListeners();

  }

  void logout(){

    _user=null;

    notifyListeners();

  }

  void updateProfile({

    required String fullName,

    required String email,

    required String phone,

    required String avatar,

  }){

    if(_user==null) return;

    _user=User(

      id:_user!.id,

      fullName:fullName,

      email:email,

      phone:phone,

      avatar:avatar,

    );

    notifyListeners();

  }

}