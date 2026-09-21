import 'package:flutter/material.dart';
import '../model/food.dart';

class FoodProvider extends ChangeNotifier {

  final List<Food> _cart = [];

  List<Food> get cart => _cart;

  void addFood(Food food){

    _cart.add(food);

    notifyListeners();

  }

  void removeFood(Food food){

    _cart.remove(food);

    notifyListeners();

  }

  double get totalFoodPrice{

    double total=0;

    for(var item in _cart){

      total+=item.price;

    }

    return total;

  }

  void clearFood(){

    _cart.clear();

    notifyListeners();

  }

}