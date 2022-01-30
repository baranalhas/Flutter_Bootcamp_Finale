import 'package:baran_alhas_flutter_final/cubit/homepage_cubit.dart';
import 'package:baran_alhas_flutter_final/entity/colors.dart';
import 'package:baran_alhas_flutter_final/entity/foods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'food_detail_page.dart';

class Search extends StatefulWidget {
  String searchKey;
  Search({required this.searchKey});
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  void initState() {
    context.read<HomePageCubit>().searchFood(widget.searchKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomePageCubit,List<Foods>>(
      builder: (context,foodList){
        if(foodList.isNotEmpty){
          return ListView.builder(
            itemCount: foodList.length,
            itemBuilder: (context,index){
              var food = foodList[index];
              if(!food.food_name.toLowerCase().contains(widget.searchKey.toLowerCase())) return Center();
              return GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => FoodDetailPage(food: food,))).then((_){
                    context.read<HomePageCubit>().getAllFoods();
                  });
                },
                child:
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
