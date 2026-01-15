import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_order/data/entity/order.dart' as app_order;

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createOrder({
    required int tableNumber,
    required List<app_order.Order> orders,
    required double totalPrice,
  }) async {
    await _firestore.collection("Orders").add({
      "table": tableNumber,
      "totalPrice": totalPrice,
      "status": "Hazırlanıyor",
      "createdAt": FieldValue.serverTimestamp(),
      "products": orders.map((o) {
        return {
          "productId": o.productId,
          "name": o.name,
          "price": o.price,
          "quantity": o.quantity,
        };
      }).toList(),
    });
  }
}
