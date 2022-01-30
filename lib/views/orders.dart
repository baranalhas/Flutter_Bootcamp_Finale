import 'package:baran_alhas_flutter_final/cubit/orderpage_cubit.dart';
import 'package:baran_alhas_flutter_final/entity/colors.dart';
import 'package:baran_alhas_flutter_final/entity/orders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrdersPage extends StatefulWidget {
  String userName;
  OrdersPage(this.userName);

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var ekranBilgisi = MediaQuery.of(context);
    final double ekranYuksekligi = ekranBilgisi.size.height;
    final double ekranGenisligi = ekranBilgisi.size.width;

    context.read<OrderPageCubit>().loadOrders();
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Siparişler", style: TextStyle(color: appBarColor, fontSize: 36, fontFamily: 'Dongle'),)),
        backgroundColor: mainColor,
      ),
      body: BlocBuilder<OrderPageCubit,List<Orders>>(
        builder: (context,foodList){
          if(foodList.isNotEmpty){
            return ListView.builder(
              itemCount: foodList.length,
              itemBuilder: (context,index){
                var food = foodList.reversed.toList()[index];
                if(food.userName != widget.userName) return Center();
                return (food.content.length < 48) ?
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Card(
                    child: SizedBox(
                      width: ekranGenisligi,
                      height: 120,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10,),
                                Text("${food.date}", style: TextStyle(fontSize: 20,)),
                                SizedBox(height: 10,),
                                Text("Sipariş: ${food.content}", style: TextStyle(color: mainColor, fontSize: 17,),),
                                SizedBox(height: 10,),
                                Text("Fiyat: ₺${food.price}", style: TextStyle(color: mainColor, fontSize: 17,),),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ) :
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Card(
                    child: SizedBox(
                      height: 120,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10,),
                                Text("${food.date}", style: TextStyle(fontSize: 20,)),
                                SizedBox(height: 10,),
                                Text("Sipariş: ${food.content}", style: TextStyle(color: mainColor, fontSize: 17,),),
                                SizedBox(height: 10,),
                                Text("Fiyat: ₺${food.price}", style: TextStyle(color: mainColor, fontSize: 17,),),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }else{
            return Center(
              child: Text("Sipariş geçmişi yok.", style: TextStyle(color: mainColor, fontSize: 18,)),
            );
          }
        },
      ),
    );
  }
}
