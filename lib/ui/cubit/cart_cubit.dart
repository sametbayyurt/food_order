import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_order/data/entity/order.dart';
import 'package:food_order/data/entity/products.dart';

class CartCubit extends Cubit<List<Order>> {
  CartCubit() : super([]);

  /// ÜRÜN EKLE
  void addProduct(Products product) {
    final List<Order> updatedList = List.from(state);

    final index = updatedList.indexWhere(
          (order) => order.productId == product.product_id,
    );

    if (index == -1) {
      updatedList.add(
        Order(
          productId: product.product_id,
          name: product.product_name,
          price: product.price,
          quantity: 1,
        ),
      );
    } else {
      updatedList[index].quantity += 1;
    }

    emit(updatedList);
  }

  /// ÜRÜN ÇIKAR
  void removeProduct(Products product) {
    final List<Order> updatedList = List.from(state);

    final index = updatedList.indexWhere(
          (order) => order.productId == product.product_id,
    );

    if (index != -1) {
      if (updatedList[index].quantity > 1) {
        updatedList[index].quantity -= 1;
      } else {
        updatedList.removeAt(index);
      }
    }

    emit(updatedList);
  }

  /// ÜRÜN ADEDİ
  int getQuantity(String productId) {
    final index =
    state.indexWhere((order) => order.productId == productId);

    if (index == -1) return 0;
    return state[index].quantity;
  }

  /// 🟢 TOPLAM FİYAT
  double get totalPrice {
    double total = 0;

    for (final order in state) {
      total += order.price * order.quantity;
    }

    return total;
  }

  /// SEPETİ TEMİZLE
  void clearCart() {
    emit([]);
  }
}
