import 'dart:convert';
import 'package:baran_alhas_flutter_final/entity/foods_basket.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:baran_alhas_flutter_final/cubit/homepage_cubit.dart';
import 'package:baran_alhas_flutter_final/entity/colors.dart';
import 'package:baran_alhas_flutter_final/entity/foods_basket_return.dart';
import 'package:baran_alhas_flutter_final/views/basket.dart';
import 'package:baran_alhas_flutter_final/views/home.dart';
import 'package:baran_alhas_flutter_final/views/profile.dart';
import 'package:baran_alhas_flutter_final/views/search.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  String userName;
  HomePage(this.userName);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  int sepet = 0;

  @override
  void initState() {
    setBasket();
    super.initState();
  }
  Future<void> setBasket() async{
    await getTotalPrice(widget.userName);
    var sp = await SharedPreferences.getInstance();
    setState(() {
      sepet = int.parse(sp.getString("totalprice") ?? "0");
    });
  }
  List<dynamic> pageList = [Home(userName: '',), Search(searchKey: '',), FoodBasket(userName: '',), Profile()];

  @override
  Widget build(BuildContext context) {
    var ekranBilgisi = MediaQuery.of(context);
    final double ekranYuksekligi = ekranBilgisi.size.height;
    final double ekranGenisligi = ekranBilgisi.size.width;
    pageList[2] = FoodBasket(userName: widget.userName);
    pageList[0] = Home(userName: widget.userName);
    return Scaffold(
      appBar: AppBar(
        title: currentIndex == 1 ? Row(
            children: [
              SizedBox(
                width: ekranGenisligi/1.22448979592,
                height: ekranYuksekligi/15.1873015873,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Ara",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: mainColor),
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: mainColor),
                      borderRadius: BorderRadius.all(Radius.circular(14)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: mainColor),
                      borderRadius: BorderRadius.all(Radius.circular(14)),
                    ),
                    contentPadding: EdgeInsets.all(8),
                    fillColor: Colors.white,
                    filled: true,
                    hintStyle: TextStyle(
                        color: mainColor,
                        fontSize: 16,
                        fontStyle: FontStyle.italic
                    ),
                  ),
                  onChanged: (searchResult){
                    context.read<HomePageCubit>().searchFood(searchResult);
                  },
                ),
              ),
              Spacer(),
              Icon(Icons.search, color: Colors.white,),
            ]
        )
            :
        sepet <= 0 ? Center(child: Text("Dongle", style: TextStyle(color: appBarColor, fontSize: 36, fontFamily: 'Dongle'),)) :
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
          Container(height: 32, width: 56, child: Text(""), color: mainColor,),
          Text("Dongle", style: TextStyle(color: appBarColor, fontSize: 36, fontFamily: 'Dongle')),
          GestureDetector(
            onTap: (){
              setState(() {
                currentIndex = 2;
              });
            },
            child: Container(height: 32, width: 64, child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.shopping_cart_outlined,color: mainColor,),
                Text("₺${sepet.toString()}", style: TextStyle(fontSize: 14,color: mainColor),)
              ],
            ),decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(8)))),
          ),
        ],),
        backgroundColor: mainColor,
      ),
      body: pageList[currentIndex],
      bottomNavigationBar:
      Container(
        color: Colors.white,
        child: BottomAppBar(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(icon: Icon(Icons.home), color: currentIndex == 0 ? mainColor : Colors.grey, onPressed: () {
                  context.read<HomePageCubit>().searchFood('');
                  context.read<HomePageCubit>().getAllFoods();
                  setState(() {
                    Search(searchKey: '',);
                    currentIndex = 0;
                    setBasket();
                  });
                },),
                IconButton(icon: Icon(Icons.search), color: currentIndex == 1 ? mainColor : Colors.grey, onPressed: () {
                  context.read<HomePageCubit>().searchFood('');
                  context.read<HomePageCubit>().getAllFoods();
                  setState(() {
                    Search(searchKey: '',);
                    currentIndex = 1;
                  });
                },),
                IconButton(icon: Icon(Icons.shopping_cart_outlined), color: currentIndex == 2 ? mainColor : Colors.grey, onPressed: () {
                  context.read<HomePageCubit>().searchFood('');
                  context.read<HomePageCubit>().getAllFoods();
                  setState(() {
                    Search(searchKey: '',);
                    FoodBasket(userName: widget.userName,);
                    currentIndex = 2;
                    setBasket();
                  });
                },),
                IconButton(icon: Icon(Icons.person), color: currentIndex == 3 ? mainColor : Colors.grey, onPressed: () {
                  context.read<HomePageCubit>().searchFood('');
                  context.read<HomePageCubit>().getAllFoods();
                  setState(() {
                    Search(searchKey: '',);
                    currentIndex = 3;
                    setBasket();
                  });
                },),
              ],
            ),
          ),
          shape: CircularNotchedRectangle(),
        ),
      ),
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