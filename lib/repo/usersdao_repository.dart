import 'dart:collection';
import 'package:firebase_database/firebase_database.dart';

class UsersDaoRepository{
  var rUsers = FirebaseDatabase.instance.reference().child("users");

  Future<void> userRegister(String userName, String userPassword, String userMail) async {
    var data = HashMap<String,dynamic>();
    data["userId"] = "";
    data["username"] = userName;
    data["password"] = userPassword;
    data["email"] = userMail;
    rUsers.push().set(data);
  }
}