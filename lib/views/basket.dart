import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:baran_alhas_flutter_final/cubit/basketpage_cubit.dart';
import 'package:baran_alhas_flutter_final/cubit/orderpage_cubit.dart';
import 'package:baran_alhas_flutter_final/entity/colors.dart';
import 'package:baran_alhas_flutter_final/entity/foods_basket.dart';
import 'package:baran_alhas_flutter_final/entity/foods_basket_return.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_page.dart';


class FoodBasket extends StatefulWidget {
  String userName;
  FoodBasket({required this.userName});

  @override
  _FoodBasketState createState() => _FoodBasketState();
}

class _FoodBasketState extends State<FoodBasket> {
  @override
  void initState() {
    getTotalPrice(widget.userName);
    super.initState();
    setBasket();
  }
  String totalPrice = "";

  Future<void> setBasket() async{
    await getTotalPrice(widget.userName);
    var sp = await SharedPreferences.getInstance();
    totalPrice = sp.getString("totalprice") ?? "0";
  }
  @override
  Widget build(BuildContext context) {
    context.read<BasketPageCubit>().getAllBasketFoods(widget.userName);
    return BlocBuilder<BasketPageCubit,List<FoodsBasketClass>>(
      builder: (context,foodList){
        if(foodList.isNotEmpty){
          foodList.add(FoodsBasketClass(
              basket_id: "son", bfood_name: "bfood_name", bfood_pic_url: "bfood_pic_url", bfood_price: "bfood_price", bfood_count: "bfood_count",
              bfood_username: "bfood_username"));
          return ListView.builder(
            itemCount: foodList.length,
            itemBuilder: (context,index){
              var food = foodList[index];
              if(food.basket_id == "son") {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(onPressed: (){
                  String orderContent = "";
                  foodList.forEach((element) {
                    if(element.basket_id != "son"){
                      orderContent.isEmpty ? orderContent += element.bfood_name:orderContent = orderContent + ", " + element.bfood_name;
                      context.read<BasketPageCubit>().deleteFromBasket(element.basket_id, widget.userName);
                    }else{
                      Center();
                    }
                  });
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Sipariş Durumu'),
                      content: const Text('Sipariş başarıyla verildi 🎉'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Tamam'),
                          child: const Text('Tamam'),
                        ),
                      ],
                    ),
                  );
                  context.read<OrderPageCubit>().orderRegister(widget.userName, orderContent,totalPrice);
                  },
                    child: Text("Sipariş ver ₺$totalPrice", style: TextStyle(fontSize: 18)), style: ElevatedButton.styleFrom(primary: mainColor)
                  ),
                );
              }
              return Card(
                child: SizedBox(height: 120,
                  child: Row(
                    children: [
                      Image.network('http://kasimadalan.pe.hu/yemekler/resimler/${food.bfood_pic_url}'),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10,),
                            Text("${food.bfood_name}", style: TextStyle(fontSize: 20,)),
                            SizedBox(height: 10,),
                            Text("₺${food.bfood_price}", style: TextStyle(color: mainColor, fontSize: 17,),),
                            SizedBox(height: 10,),
                            Text("Adet: ${food.bfood_count}", style: TextStyle(color: mainColor, fontSize: 17,),),
                          ],
                        ),
                      ),
                      Spacer(),
                      IconButton(icon: Icon(Icons.delete_sweep_outlined, color: mainColor,), onPressed: () {
                        context.read<BasketPageCubit>().deleteFromBasket(food.basket_id, widget.userName);
                        totalPrice = (int.parse(totalPrice)-int.parse(food.bfood_price)).toString();
                      },),
                    ],
                  ),
                ),
              );
            },
          );
        }else{
          return Center(
            child: Text("Sepette ürün yok.", style: TextStyle(color: mainColor, fontSize: 18,)),
          );
        }
      },
    );
  }
}

List<FoodsBasketClass> parseFoodsBasketReturn(String ans){
  return FoodsBasketReturn.fromJson(json.decode(ans)).foodList;
}
Future<void> getTotalPrice(userName) async {
  var url = Uri.parse("http://kasimadalan.pe.hu/yemekler/sepettekiYemekleriGetir.php");
  var data = {"kullanici_adi": userName};
  var ans = await http.post(url, body: data);
  int totalPrice = 0;
  if (ans.body.contains('yemek_adi')) {
    parseFoodsBasketReturn(ans.body).forEach((element) async {
      totalPrice += (int.parse(element.bfood_price));
    });
  }
  var sp = await SharedPreferences.getInstance();
  sp.setString("totalprice", totalPrice.toString());
}