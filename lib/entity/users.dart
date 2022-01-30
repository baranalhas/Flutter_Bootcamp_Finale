class Users{
  String user_id;
  String user_name;
  String user_password;
  String user_email;

  Users(this.user_id, this.user_name, this.user_password, this.user_email);

  factory Users.fromJson(String key, Map<dynamic, dynamic> json){
    return Users(key, json["username"] as String, json['password'] as String, json['email'] as String);
  }
}