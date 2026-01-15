import 'package:flutter/material.dart';
import 'package:food_order/services/auth.dart';
import 'package:food_order/ui/views/business_auth_page.dart';
import 'package:food_order/ui/views/customer_menu_page.dart';
import 'package:food_order/ui/views/business_dashboard_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    Auth authService = Auth();
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset("images/bg.jpg", fit: BoxFit.cover),
          ),

          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.6),
                  Colors.black.withOpacity(0.85),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "En",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: width * 0.07,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "Lezzetli",
                  style: TextStyle(
                    color: Color(0xFFFF6A00),
                    fontSize: width * 0.09,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Yemek Seçenekleri",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: width * 0.08,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Özenle hazırlanmış yemekler ve zengin içecek menümüzle her damak tadına hitap ediyoruz.",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: width * 0.035,
                  ),
                ),

                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFF6A00),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CustomerMenuPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "SİPARİŞ",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF731702),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      final user = authService.currentUser;
                      if (user != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BusinessDashBoardPage(),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BusinessAuthPage(),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      "İŞLETME",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
