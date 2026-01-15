import 'package:flutter/material.dart';
import 'package:food_order/services/auth.dart';
import 'package:food_order/ui/views/business_add_product_page.dart';
import 'package:food_order/ui/views/business_orders_page.dart';
import 'package:food_order/ui/views/business_products_page.dart';
import 'package:food_order/ui/views/landing_page.dart';

class BusinessDashBoardPage extends StatefulWidget {
  const BusinessDashBoardPage({super.key});

  @override
  State<BusinessDashBoardPage> createState() => _BusinessDashBoardPage();
}

class _BusinessDashBoardPage extends State<BusinessDashBoardPage> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    BusinessOrdersPage(),
    BusinessProductsPage(),
    BusinessAddProductPage(),
  ];

  @override
  Widget build(BuildContext context) {
    Auth authService = Auth();

    return Scaffold(
      body: IndexedStack(index: selectedIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFFF6A00),
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: const Color(0xFFE0E0E0),
        selectedIconTheme: const IconThemeData(size: 28),
        unselectedIconTheme: const IconThemeData(size: 24),
        onTap: (index) async {
          if (index == 3) {
            await authService.signOut();

            if (!mounted) return;

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LandingPage()),
              (route) => false,
            );
          } else {
            setState(() {
              selectedIndex = index;
            });
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: "Siparişler",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: "Ürünler",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            label: "Ürün Ekle",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: "Çıkış"),
        ],
      ),
    );
  }
}
