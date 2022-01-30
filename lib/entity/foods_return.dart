import 'foods.dart';

class FoodsReturn{
  List<Foods> foodList;
  int success;

  FoodsReturn({required this.foodList,required this.success});

  factory FoodsReturn.fromJson(Map<String,dynamic> json){
    var jsonArray = json["yemekler"] as List;
    List<Foods> foodList = jsonArray.map((jsonArrayObj) => Foods.fromJson(jsonArrayObj)).toList();
    return FoodsReturn(foodList: foodList, success: json["success"] as int);
  }
}