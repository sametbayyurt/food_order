class Order {
  String productId;
  String name;
  double price;
  int quantity;

  Order({
    required this.productId,
    required this.name,
    required this.price,
    this.quantity = 1,
  });
}
