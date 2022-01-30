class Orders{
  String userName;
  String content;
  String date;
  String price;

  Orders({required this.userName, required this.content, required this.date, required this.price});

  factory Orders.fromJson(String key, Map<dynamic, dynamic> json){
    return Orders(
      content: json['content'] as String,
      date: json['date'] as String,
      userName: json['username'] as String,
      price: json['price'] as String);
  }
}