import 'package:baran_alhas_flutter_final/entity/colors.dart';
import 'package:baran_alhas_flutter_final/entity/users.dart';
import 'package:baran_alhas_flutter_final/repo/usersdao_repository.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var tfUserName = "";
  var tfPassword = "";
  var tfMail = "";
  Future<bool> checkExist() async{
    bool flag = true;
    var refUsers = FirebaseDatabase.instance.reference().child("users");
    refUsers.onValue.listen((event) async {
      var data = event.snapshot.value;
      print(data);
      if(data != null){
        data.forEach((key, value) async {
          var fUsers = Users.fromJson(key, value);
          if(fUsers.user_name == tfUserName){
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: mainColor,
                  content: Text('Kullanıcı mevcut!'),
                )
            );
            flag = false;
          }
        }
        );
      }
    });
    return flag;
  }
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
                    hintText: "e-mail",
                  ),
                  onChanged: (content){
                    tfMail = content;
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
                      Navigator.pop(context);
                    },
                    child: Text('Geri', style: TextStyle(color: mainColor),),
                    style: ElevatedButton.styleFrom(primary: appBarColor),
                  ),
                ),
                ElevatedButton(onPressed: () async {
                  if(tfPassword.trim().isEmpty || tfUserName.trim().isEmpty || tfMail.isEmpty
                      && tfUserName.trim().isEmpty || tfPassword.trim().isEmpty || tfMail.trim().isEmpty){
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: mainColor,
                          content: Text('Lütfen boş alan bırakmayın!'),
                        )
                    );
                  }else{
                    bool flag = await checkExist();
                    if(flag){
                      UsersDaoRepository().userRegister(tfUserName, tfPassword, tfMail);
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: mainColor,
                            content: Text('Kayıt Başarılı!'),
                          )
                      );
                      Navigator.pop(context);
                    }
                  }
                }, child: Text('Kayıt Ol'),),
              ],
            )
          ],
        ),
      ),
    );
  }
}
