import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderFoodDaoRepository {
  var collectionProducts = FirebaseFirestore.instance.collection("Products");

  Future<void> save(
    String product_name,
    String product_detail,
    String category,
    double price,
  ) async {
    var newProduct = HashMap<String, dynamic>();
    newProduct["product_id"] = "";
    newProduct["product_name"] = product_name;
    newProduct["product_detail"] = product_detail;
    newProduct["category"] = category;
    newProduct["price"] = price;
    collectionProducts.add(newProduct);
  }

  Future<void> update(
    String product_id,
    String product_name,
    String product_detail,
    String category,
    double price,
  ) async {
    var updatedProduct = HashMap<String, dynamic>();
    updatedProduct["product_name"] = product_name;
    updatedProduct["product_detail"] = product_detail;
    updatedProduct["category"] = category;
    updatedProduct["price"] = price;
    collectionProducts.doc(product_id).update(updatedProduct);
  }

  Future<void> delete(String product_id) async {
    collectionProducts.doc(product_id).delete();
  }
}
