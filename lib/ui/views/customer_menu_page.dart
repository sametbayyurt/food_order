import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_order/data/entity/products.dart';
import 'package:food_order/data/entity/order.dart';
import 'package:food_order/ui/cubit/business_products_page_cubit.dart';
import 'package:food_order/ui/cubit/cart_cubit.dart';
import 'package:food_order/ui/views/order_summary_page.dart';

class CustomerMenuPage extends StatefulWidget {
  const CustomerMenuPage({super.key});

  @override
  State<CustomerMenuPage> createState() => _CustomerMenuPageState();
}

class _CustomerMenuPageState extends State<CustomerMenuPage> {
  int selectedIndex = 0;

  final List<String> categories = [
    "Tümü",
    "Çorba",
    "Ara Sıcak",
    "Ana Yemek",
    "Salata",
    "Tatlı",
    "İçecek",
  ];

  final Map<String, String> categoryImages = {
    "Tümü": "images/foods.jpg",
    "Çorba": "images/soup.jpg",
    "Ara Sıcak": "images/hotmeal.jpg",
    "Ana Yemek": "images/maincourse.jpg",
    "Salata": "images/salad.jpg",
    "Tatlı": "images/dessert.jpg",
    "İçecek": "images/drink.jpg",
  };

  @override
  void initState() {
    super.initState();
    context.read<BusinessProductsPageCubit>().search("Tümü");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      bottomNavigationBar: BlocBuilder<CartCubit, List<Order>>(
        builder: (context, orders) {
          if (orders.isEmpty) {
            return const SizedBox.shrink();
          }

          final total = context.read<CartCubit>().totalPrice;

          return SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFF1E1E1E),
                border: Border(top: BorderSide(color: Colors.white12)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Toplam: ${total.toStringAsFixed(2)} ₺",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6A00),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const OrderSummaryPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "Siparişi Tamamla",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),

      body: Column(
        children: [
          _ImageHeader(imagePath: categoryImages[categories[selectedIndex]]!),

          SizedBox(
            height: 45,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final isSelected = selectedIndex == index;

                return GestureDetector(
                  onTap: () {
                    setState(() => selectedIndex = index);
                    context.read<BusinessProductsPageCubit>().search(
                      categories[index],
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFFF6A00)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFFF6A00)),
                    ),
                    child: Text(
                      categories[index],
                      style: TextStyle(
                        color: isSelected ? Colors.black : Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          Expanded(
            child: BlocBuilder<BusinessProductsPageCubit, List<Products>>(
              builder: (context, products) {
                if (products.isEmpty) {
                  return const Center(
                    child: Text(
                      "Ürün bulunamadı",
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF121212),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.product_name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  product.product_detail,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "${product.price.toStringAsFixed(2)} ₺",
                                  style: const TextStyle(
                                    color: Color(0xFFFF6A00),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.remove_circle,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  context.read<CartCubit>().removeProduct(
                                    product,
                                  );
                                },
                              ),
                              BlocBuilder<CartCubit, List<Order>>(
                                builder: (context, orders) {
                                  final qty = context
                                      .read<CartCubit>()
                                      .getQuantity(product.product_id);
                                  return Text(
                                    qty.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.add_circle,
                                  color: Color(0xFFFF6A00),
                                ),
                                onPressed: () {
                                  context.read<CartCubit>().addProduct(product);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageHeader extends StatelessWidget {
  final String imagePath;

  const _ImageHeader({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(imagePath, fit: BoxFit.cover),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black87],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
