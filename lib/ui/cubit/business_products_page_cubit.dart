import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_order/data/entity/products.dart';
import 'package:food_order/data/repo/orderfooddao_repository.dart';

class BusinessProductsPageCubit extends Cubit<List<Products>> {
  BusinessProductsPageCubit() : super(<Products>[]);

  var frepo = OrderFoodDaoRepository();

  var collectionProducts = FirebaseFirestore.instance.collection("Products");

  Future<void> loadProducts() async {
    collectionProducts.snapshots().listen((event) {
      var productList = <Products>[];

      var documents = event.docs;
      for (var document in documents) {
        var key = document.id;
        var data = document.data();
        var product = Products.fromJson(data, key);
        productList.add(product);
      }

      emit(productList);
    });
  }

  Future<void> search(String searchWord) async {
    collectionProducts.snapshots().listen((event) {
      var productList = <Products>[];

      for (var document in event.docs) {
        var product = Products.fromJson(document.data(), document.id);

        if (searchWord == "Tümü") {
          productList.add(product);
        } else if (product.category.toLowerCase() == searchWord.toLowerCase()) {
          productList.add(product);
        }
      }

      emit(productList);
    });
  }

  Future<void> delete(String product_id) async {
    await frepo.delete(product_id);
  }

  Future<void> update(
    String product_id,
    String product_name,
    String product_detail,
    String category,
    double price,
  ) async {
    await frepo.update(
      product_id,
      product_name,
      product_detail,
      category,
      price,
    );
  }
}
