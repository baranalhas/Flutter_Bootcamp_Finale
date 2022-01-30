import 'package:baran_alhas_flutter_final/entity/colors.dart';
import 'package:baran_alhas_flutter_final/entity/users.dart';
import 'package:baran_alhas_flutter_final/views/register_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_page.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var tfUserName = "";
  var tfPassword = "";
  var refUsers = FirebaseDatabase.instance.reference().child("users");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.supervised_user_circle, size: 82,color: mainColor,),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                width: 356,
                decoration: BoxDecoration(
                  color: tfbackground,
                  borderRadius: BorderRadius.circular(29),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Kullanıcı Adı",
                  ),
                  onChanged: (content){
                    tfUserName = content;
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                width: 356,
                decoration: BoxDecoration(
                  color: tfbackground,
                  borderRadius: BorderRadius.circular(29),
                ),
                child: TextField(
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    hintText: "Şifre",
                  ),
                  onChanged: (content){
                    tfPassword = content;
                  },
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
                    },
                    child: Text('Kayıt Ol', style: TextStyle(color: mainColor),),
                    style: ElevatedButton.styleFrom(primary: appBarColor),
                  ),
                ),
                ElevatedButton(onPressed: () async {
                  if(tfPassword.trim().isEmpty || tfUserName.trim().isEmpty && tfUserName.isEmpty || tfPassword.isEmpty){
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: mainColor,
                          content: Text('Kullanıcı adı veya Şifre boş bırakılamaz'),
                        )
                    );
                  }else{
                    bool flag = false;
                    refUsers.onValue.listen((event) {
                      var data = event.snapshot.value;
                      if(data != null){
                        data.forEach((key, value) async {
                          var fUsers = Users.fromJson(key, value);
                          if(fUsers.user_name == tfUserName && fUsers.user_password == tfPassword){
                            var sp = await SharedPreferences.getInstance();
                            sp.setString("username", tfUserName);
                            sp.setString("email", fUsers.user_email);
                            sp.setString("totalprice", "0");
                            flag = true;
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(tfUserName)));
                          }else{

                          }
                        });
                      }
                    });
                  }
                }, child: Text('Giriş Yap'),),
              ],
            )
          ],
        ),
      ),
    );
  }
}
