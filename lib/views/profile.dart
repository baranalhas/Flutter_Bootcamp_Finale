import 'package:baran_alhas_flutter_final/entity/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_page.dart';
import 'orders.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String userName = "";
  String userMail = "";

  Future<void> getUserInfo() async{
    var sp = await SharedPreferences.getInstance();
    userName = sp.getString("username") ?? "";
    userMail = sp.getString("email") ?? "";
    setState(() {});
  }
  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Card(
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.person_sharp,size: 96, color: mainColor,),
                    Text(userName, style: TextStyle(color: Colors.black, fontSize: 20),)
                  ],
                ),
                Row(children: [Text('')],),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    children: [
                      Icon(Icons.mail_outline_outlined, color: mainColor, size: 32,),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(userMail, style: TextStyle(color: Colors.black),),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => OrdersPage(userName)));
            },
            child: Card(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      children: [
                        Icon(Icons.history_rounded, color: mainColor, size: 32,),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text('Sipariş Geçmişi', style: TextStyle(color: Colors.black),),
                        ),
                        Spacer(),
                        Icon(Icons.arrow_right,size: 32, color: mainColor,),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          ElevatedButton(onPressed: () async {
            var sp = await SharedPreferences.getInstance();
            sp.remove("username");
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
          }, child: Text('Çıkış Yap'))
        ],
      )
    );
  }
}