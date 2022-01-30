import 'package:baran_alhas_flutter_final/entity/orders.dart';
import 'package:baran_alhas_flutter_final/repo/ordersdao_repository.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderPageCubit extends Cubit<List<Orders>>{
  OrderPageCubit():super(<Orders>[]);
  var refOrders = FirebaseDatabase.instance.reference().child("orders");
  var bRepo = OrdersDaoRepository();

  Future<void> loadOrders() async{
    refOrders.onValue.listen((event) {
      var data = event.snapshot.value;

      if(data != null){
        var list = <Orders>[];
        data.forEach((key, value){
          var fOrders = Orders.fromJson(key,value);
          list.add(fOrders);
        });
        emit(list);
      }
    });
  }
  Future<void> orderRegister(userName, orderContent, price) async {
    await bRepo.orderRegister(userName, orderContent, price);
  }

}