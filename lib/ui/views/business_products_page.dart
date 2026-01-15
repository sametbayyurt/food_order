import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_order/data/entity/products.dart';
import 'package:food_order/ui/cubit/business_products_page_cubit.dart';
import 'package:food_order/ui/views/business_product_update_page.dart';

class BusinessProductsPage extends StatefulWidget {
  const BusinessProductsPage({super.key});

  @override
  State<BusinessProductsPage> createState() => _BusinessProductsPageState();
}

class _BusinessProductsPageState extends State<BusinessProductsPage> {
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
                      textAlign: TextAlign.center,
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

          const SizedBox(height: 8),

          Expanded(
            child: BlocBuilder<BusinessProductsPageCubit, List<Products>>(
              builder: (context, productList) {
                if (productList.isEmpty) {
                  return const Center(
                    child: Text(
                      "Ürün bulunamadı",
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: productList.length,
                  itemBuilder: (context, index) {
                    final product = productList[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                BusinessProductUpdatePage(product: product),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF121212),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white10),
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
                                    product.category,
                                    style: const TextStyle(
                                      color: Colors.white38,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "${product.price.toStringAsFixed(2)} ₺",
                                  style: const TextStyle(
                                    color: Color(0xFFFF6A00),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                IconButton(
                                  onPressed: () {
                                    _showDeleteDialog(
                                      context,
                                      product.product_id,
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Color(0xFFFF6A00),
                                    size: 30,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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
      height: 175,
      width: double.infinity,
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

void _showDeleteDialog(BuildContext context, String product_id) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Silme Onayı"),
      content: const Text("Bu ürünü silmek istediğinize emin misiniz?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("İptal",style: TextStyle(color: Colors.black87),),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFF6A00)),
          onPressed: () {
            context.read<BusinessProductsPageCubit>().delete(product_id);
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Color(0xFFFF6A00),
                content: Text(
                  "Ürün Silindi",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          },
          child: const Text("Sil", style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}
