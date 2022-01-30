import 'dart:async';
import 'package:baran_alhas_flutter_final/entity/foods_basket.dart';
import 'package:baran_alhas_flutter_final/repo/basketdao_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BasketPageCubit extends Cubit<List<FoodsBasketClass>>{
  BasketPageCubit():super(<FoodsBasketClass>[]);
  var fRepo = BasketDaoRepository();

  Future<void> getAllBasketFoods(String userName) async {
    List<FoodsBasketClass> liste = await fRepo.getAllBasketFoods(userName);
    emit(liste);
  }
  Future<void> addToBasket(String foodName, String foodPicName, String foodPrice, String foodCount, String userName) async{
    await fRepo.addToBasket(foodName, foodPicName, foodPrice, foodCount, userName);
  }
  Future<void> deleteFromBasket(String foodBasketId, String userName) async {
    await fRepo.deleteFromBasket(foodBasketId, userName);
    getAllBasketFoods(userName);
  }
}