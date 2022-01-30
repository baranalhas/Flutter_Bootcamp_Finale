import 'package:baran_alhas_flutter_final/cubit/basketpage_cubit.dart';
import 'package:baran_alhas_flutter_final/entity/colors.dart';
import 'package:baran_alhas_flutter_final/entity/foods.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FoodDetailPage extends StatefulWidget {
  Foods food;
  FoodDetailPage({required this.food});

  @override
  _FoodDetailPageState createState() => _FoodDetailPageState();
}

class _FoodDetailPageState extends State<FoodDetailPage> {
  @override
  void initState() {
    getUserInfo();
    super.initState();
  }
  var count = 1;
  String userName = "";
  String totalPrice = "";

  Future<void> getUserInfo() async{
    var sp = await SharedPreferences.getInstance();
    userName = sp.getString("username") ?? "";
    totalPrice = sp.getString("totalprice") ?? "0";
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Yemek Detayı", style: TextStyle(color: appBarColor, fontSize: 36, fontFamily: 'Dongle'),),
        backgroundColor: mainColor,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 370,
            width: double.infinity,
            child: Card(
              child: Column(
                children: [
                  Image.network("http://kasimadalan.pe.hu/yemekler/resimler/${widget.food.food_pic_url}"),
                  Text("${widget.food.food_name}", style: TextStyle(fontSize: 36, fontFamily: 'Dongle'),),
                  Text("₺${widget.food.food_price}",style: TextStyle(fontSize: 34,color: mainColor, fontFamily: 'Dongle'),),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: double.infinity,
            height: 120,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: (){
                setState(() {
                  count == 1 ? null : count -= 1;
                });
              }, child: Text("-", style: TextStyle(fontSize: 24)), style: ElevatedButton.styleFrom(primary: mainColor)),
              ElevatedButton(onPressed: null, child: Text("${count}", style: TextStyle(fontSize: 20)), style: ElevatedButton.styleFrom(primary: mainColor,shadowColor: Colors.white)),
              ElevatedButton(onPressed: (){
                setState(() {
                  count +=1;
                });
              }, child: Text("+", style: TextStyle(fontSize: 20)), style: ElevatedButton.styleFrom(primary: mainColor)),
            ],
          )
        ],
      ),
      bottomNavigationBar:
      Container(
        color: Colors.white,
        child: BottomAppBar(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 280,height: 42,child: ElevatedButton(onPressed: count == 0 ? null : () async {
                  context.read<BasketPageCubit>().addToBasket(
                      widget.food.food_name,
                      widget.food.food_pic_url,
                      (count*int.parse(widget.food.food_price)).toString(),
                      count.toString(),
                      userName);
                  var sp = await SharedPreferences.getInstance();
                  sp.setString("totalprice", (int.parse(totalPrice)+ (count*int.parse(widget.food.food_price))).toString());
                  Navigator.pop(context);
                }, child: Text("Sepete Ekle", style: TextStyle(fontSize: 24, fontFamily: 'Dongle')), style: ElevatedButton.styleFrom(primary: mainColor,))),
                SizedBox(height: 42, child: ElevatedButton(onPressed: null, child: Text("₺${(count*int.parse(widget.food.food_price))}", style: TextStyle(fontSize: 16)), style: ElevatedButton.styleFrom(primary: mainColor))),
              ],
            ),
          ),
          shape: CircularNotchedRectangle(),
        ),
      ),
    );
  }
}
