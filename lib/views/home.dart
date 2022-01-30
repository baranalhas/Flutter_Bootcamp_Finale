import 'dart:convert';

import 'package:baran_alhas_flutter_final/cubit/homepage_cubit.dart';
import 'package:baran_alhas_flutter_final/entity/colors.dart';
import 'package:baran_alhas_flutter_final/entity/foods.dart';
import 'package:baran_alhas_flutter_final/entity/foods_basket.dart';
import 'package:baran_alhas_flutter_final/entity/foods_basket_return.dart';
import 'package:baran_alhas_flutter_final/views/food_detail_page.dart';
import 'package:baran_alhas_flutter_final/views/home_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  String userName;
  Home({required this.userName});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    context.read<HomePageCubit>().getAllFoods();
    context.read<HomePageCubit>().searchFood("");
    super.initState();
  }
  final List<String> imageList = [
    "https://di-uploads-pod17.dealerinspire.com/raycatenalandrovermarlboro/uploads/2019/07/Mexican-Food-banner.png",
    "https://image.shutterstock.com/image-photo/assortment-various-barbecue-vegan-food-600w-1738904081.jpg",
    "https://image.shutterstock.com/shutterstock/photos/1624168432/display_1500/stock-photo-assortment-of-cooked-food-vegetables-and-chicken-collage-food-in-plates-top-view-place-for-your-1624168432.jpg"
  ];
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomePageCubit,List<Foods>>(
      builder: (context,foodList){
        if(foodList.isNotEmpty){
          foodList.insert(0, foodList[1]);
          return ListView.builder(
            itemCount: foodList.length,
            itemBuilder: (context,index){
              var food = foodList[index];
              return GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => FoodDetailPage(food: food,))).then((_){
                    context.read<HomePageCubit>().getAllFoods();
                    getTotalPrice(widget.userName);
                    HomePage(widget.userName);
                  });
                },
                child: index == 0 ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 100,
                      aspectRatio: 2.0,
                      enlargeCenterPage: true,
                      scrollDirection: Axis.horizontal,
                      autoPlay: true,

                    ),
                    items: imageList.map((e) => ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          Image.network(e,
                            fit: BoxFit.cover,),
                        ],
                      ),
                    )).toList(),
                  ),
                ) :
                Card(
                  child: SizedBox(height: 120,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10,),
                              Text("${food.food_name}", style: TextStyle(fontSize: 20,)),
                              SizedBox(height: 10,),
                              Text("₺${food.food_price}", style: TextStyle(color: mainColor, fontSize: 17,),),
                            ],
                          ),
                        ),
                        Spacer(),
                        Image.network('http://kasimadalan.pe.hu/yemekler/resimler/${food.food_pic_url}'),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }else{
          return Center();
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