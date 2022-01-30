import 'package:baran_alhas_flutter_final/entity/foods.dart';
import 'package:baran_alhas_flutter_final/repo/foodsdao_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePageCubit extends Cubit<List<Foods>>{
  HomePageCubit():super(<Foods>[]);
  var fRepo = FoodsDaoRepository();

  Future<void> getAllFoods() async {
    var liste = await fRepo.getAllFoods();
    emit(liste);
  }
  Future<void> searchFood(String searchKey) async {
    var liste = await fRepo.searchFood();
    var fList = liste.where((element) => element.food_name.toLowerCase().contains(searchKey)).toList();
    emit(fList);
  }
}