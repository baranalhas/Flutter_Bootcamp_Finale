import 'dart:convert';
import 'package:baran_alhas_flutter_final/entity/foods_basket.dart';
import 'package:baran_alhas_flutter_final/entity/foods_basket_return.dart';
import 'package:baran_alhas_flutter_final/entity/price.dart';
import 'package:http/http.dart' as http;

class BasketDaoRepository{
  List<FoodsBasketClass> parseFoodsBasketReturn(String ans){
    return FoodsBasketReturn.fromJson(json.decode(ans)).foodList;
  }

  Future<List<FoodsBasketClass>> getAllBasketFoods(String userName) async {
    try{
      var url = Uri.parse("http://kasimadalan.pe.hu/yemekler/sepettekiYemekleriGetir.php");
      var data = {"kullanici_adi": userName};
      var ans = await http.post(url, body: data);
      return parseFoodsBasketReturn(ans.body);
    } catch (err){
      List<FoodsBasketClass> list = [];
      return list;
    }
  }
  Future<List<TotalPrice>> getTotalPrice(String userName) async {
    var url = Uri.parse("http://kasimadalan.pe.hu/yemekler/sepettekiYemekleriGetir.php");
    var data = {"kullanici_adi": userName};
    var ans = await http.post(url, body: data);
    int totalPrice = 0;
    if (ans.body.contains('yemek_adi')) {
      parseFoodsBasketReturn(ans.body).forEach((element) async {
        totalPrice += (int.parse(element.bfood_price));
      });
    }
    List<TotalPrice> list = [TotalPrice(total_price: totalPrice)];
    return list;
  }
  Future<void> addToBasket(String foodName, String foodPicName, String foodPrice, String foodCount, String userName) async {
    var url = Uri.parse("http://kasimadalan.pe.hu/yemekler/sepettekiYemekleriGetir.php");
    var data = {"kullanici_adi": userName};
    var ans = await http.post(url, body: data);
    bool flag = false;
    String elementBasketID = "0";
    String elementCount = "0";

    if(ans.body.contains('yemek_adi')){
      parseFoodsBasketReturn(ans.body).forEach((element) async {
        if(element.bfood_name == foodName){
          flag = true;
          elementBasketID = element.basket_id;
          elementCount = element.bfood_count;
        }
      });
      if(flag){
        var urlDel = Uri.parse("http://kasimadalan.pe.hu/yemekler/sepettenYemekSil.php");
        var dataDel = {"sepet_yemek_id": elementBasketID, "kullanici_adi": userName};
        await http.post(urlDel, body: dataDel);
        url = Uri.parse("http://kasimadalan.pe.hu/yemekler/sepeteYemekEkle.php");
        data = {
          "yemek_adi": foodName,
          "yemek_resim_adi": foodPicName,
          "yemek_fiyat" : (int.parse(foodPrice)*(int.parse(foodCount)+int.parse(elementCount))).toString(),
          "yemek_siparis_adet" : (int.parse(foodCount)+int.parse(elementCount)).toString(),
          "kullanici_adi" : userName,
        };
        ans = await http.post(url, body: data);
      }else{
        url = Uri.parse("http://kasimadalan.pe.hu/yemekler/sepeteYemekEkle.php");
        data = {
          "yemek_adi": foodName,
          "yemek_resim_adi": foodPicName,
          "yemek_fiyat" : foodPrice,
          "yemek_siparis_adet" : foodCount,
          "kullanici_adi" : userName,
        };
        ans = await http.post(url, body: data);
      }
    }else{
      url = Uri.parse("http://kasimadalan.pe.hu/yemekler/sepeteYemekEkle.php");
      data = {
        "yemek_adi": foodName,
        "yemek_resim_adi": foodPicName,
        "yemek_fiyat" : foodPrice,
        "yemek_siparis_adet" : foodCount,
        "kullanici_adi" : userName,
      };
      ans = await http.post(url, body: data);
    }
  }
  Future<void> deleteFromBasket(String foodBasketId, String userName) async {
    var url = Uri.parse("http://kasimadalan.pe.hu/yemekler/sepettenYemekSil.php");
    var data = {"sepet_yemek_id": foodBasketId, "kullanici_adi": userName};
    await http.post(url, body: data);
  }
}