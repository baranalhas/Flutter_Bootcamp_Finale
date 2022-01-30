import 'dart:collection';
import 'package:firebase_database/firebase_database.dart';

class OrdersDaoRepository{
  var rUsers = FirebaseDatabase.instance.reference().child("orders");

  Future<void> orderRegister(String userName, String orderContent, String price) async {
    String date = "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} - ${DateTime.now().hour}:${DateTime.now().minute}";
    var data = HashMap<String,dynamic>();
    data["username"] = userName;
    data["content"] = orderContent;
    data["date"] = date;
    data["price"] = price;
    rUsers.push().set(data);
  }

}