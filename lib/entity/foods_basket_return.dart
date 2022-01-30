import 'foods_basket.dart';

class FoodsBasketReturn{
  List<FoodsBasketClass> foodList;
  int success;

  FoodsBasketReturn({required this.foodList,required this.success});

  factory FoodsBasketReturn.fromJson(Map<String,dynamic> json){
    var jsonArray = json["sepet_yemekler"] as List;
    List<FoodsBasketClass> foodList = jsonArray.map((jsonArrayObj) => FoodsBasketClass.fromJson(jsonArrayObj)).toList();
    return FoodsBasketReturn(foodList: foodList, success: json["success"] as int);
  }
}