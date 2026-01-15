class Products {
  String product_id;
  String product_name;
  String product_detail;
  String category;
  double price;

  Products({
    required this.product_id,
    required this.product_name,
    required this.product_detail,
    required this.category,
    required this.price,
  });

  factory Products.fromJson(Map<dynamic, dynamic> json, String key) {
    return Products(
      product_id: key,
      product_name: json["product_name"] as String,
      product_detail: json["product_detail"] as String,
      category: json["category"] as String,
      price: (json["price"] as num).toDouble(),
    );
  }
}
