import 'dart:convert';
import 'package:baran_alhas_flutter_final/entity/foods.dart';

import 'package:baran_alhas_flutter_final/entity/foods_return.dart';
import 'package:http/http.dart' as http;

class FoodsDaoRepository{
  List<Foods> parseFoodsReturn(String ans){
    return FoodsReturn.fromJson(json.decode(ans)).foodList;
  }
  Future<List<Foods>> getAllFoods() async {
    var url = Uri.parse("http://kasimadalan.pe.hu/yemekler/tumYemekleriGetir.php");
    var ans = await http.get(url);
    return parseFoodsReturn(ans.body);
  }
  Future<void> deleteFromBasket(String foodBasketId, String userName) async {
    var url = Uri.parse("http://kasimadalan.pe.hu/yemekler/sepettenYemekSil.php");
    var data = {"sepet_yemek_id": foodBasketId, "kullanici_adi": userName};
    await http.post(url, body: data);
  }
  Future<List<Foods>> searchFood() async{
    var url = Uri.parse("http://kasimadalan.pe.hu/yemekler/tumYemekleriGetir.php");
    var ans = await http.get(url);
    return parseFoodsReturn(ans.body);
  }
}