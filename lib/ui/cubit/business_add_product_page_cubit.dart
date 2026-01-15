import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_order/data/repo/orderfooddao_repository.dart';

class AddProductPageCubit extends Cubit<void> {
  AddProductPageCubit() : super(0);

  var frepo = OrderFoodDaoRepository();

  Future<void> save(
    String product_name,
    String product_detail,
    String category,
    double price,
  ) async {
    await frepo.save(product_name, product_detail, category, price);
  }
}
