import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_order/data/entity/products.dart';
import 'package:food_order/ui/cubit/business_products_page_cubit.dart';

class BusinessProductUpdatePage extends StatefulWidget {
  final Products product;

  BusinessProductUpdatePage({required this.product});

  @override
  State<BusinessProductUpdatePage> createState() => _BusinessUpdatePageState();
}

class _BusinessUpdatePageState extends State<BusinessProductUpdatePage> {
  final TextEditingController tfName = TextEditingController();
  final TextEditingController tfDescription = TextEditingController();
  final TextEditingController tfPrice = TextEditingController();

  String? selectedCategory;

  final List<String> categories = [
    "Çorba",
    "Ara Sıcak",
    "Ana Yemek",
    "Salata",
    "Tatlı",
    "İçecek",
  ];

  @override
  void initState() {
    super.initState();
    tfName.text = widget.product.product_name;
    tfDescription.text = widget.product.product_detail;
    tfPrice.text = widget.product.price % 1 == 0
        ? widget.product.price.toInt().toString()
        : widget.product.price.toString();
    selectedCategory = widget.product.category;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Color(0xFFFF6A00),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Ürün Güncelle",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: const Color(0xFF121212),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _darkTextField(controller: tfName, hintText: "Ürün Adı"),
                    const SizedBox(height: 16),

                    _darkTextField(
                      controller: tfDescription,
                      hintText: "Ürün Detayı",
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),

                    _darkDropdown(),
                    const SizedBox(height: 16),

                    _darkTextField(
                      controller: tfPrice,
                      hintText: "Ürün Fiyatı",
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 22),

                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          if (tfName.text.isEmpty ||
                              tfDescription.text.isEmpty ||
                              tfPrice.text.isEmpty ||
                              selectedCategory == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Color(0xFFFF6A00),
                                content: Text(
                                  "Lütfen tüm alanları doldurun",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                            return;
                          }

                          context.read<BusinessProductsPageCubit>().update(
                            widget.product.product_id,
                            tfName.text,
                            tfDescription.text,
                            selectedCategory!,
                            double.parse(tfPrice.text),
                          );

                          tfName.clear();
                          tfDescription.clear();
                          tfPrice.clear();

                          setState(() {
                            selectedCategory = null;
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Color(0xFFFF6A00),
                              content: Text(
                                "Ürün başarıyla güncellendi",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6A00),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "GÜNCELLE",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _darkTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      textCapitalization: TextCapitalization.sentences,
      style: const TextStyle(color: Colors.white),
      decoration: _darkInputDecoration(hintText),
    );
  }

  Widget _darkDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedCategory,
      dropdownColor: Colors.black,
      hint: const Text("Kategori Seç", style: TextStyle(color: Colors.white38)),
      items: categories
          .map(
            (category) => DropdownMenuItem(
              value: category,
              child: Text(
                category,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
          .toList(),
      onChanged: (value) {
        setState(() {
          selectedCategory = value;
        });
      },
      decoration: _darkInputDecoration("Ürün Kategorisi"),
    );
  }

  InputDecoration _darkInputDecoration(String hintText) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.black,
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.white38),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.white10),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFFF6A00), width: 2),
      ),
    );
  }
}
