import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_order/services/auth.dart';
import 'package:food_order/ui/views/business_dashboard_page.dart';

class BusinessAuthPage extends StatefulWidget {
  const BusinessAuthPage({super.key});

  @override
  State<BusinessAuthPage> createState() => _BusinessAuthPage();
}

class _BusinessAuthPage extends State<BusinessAuthPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLogin = true;

  void showMessage(String message, bool isError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isError
            ? const Color(0xFFFF6A00)
            : const Color(0xFFFF6A00),
        content: Text(message, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  Future<void> createUser() async {
    try {
      await Auth().createuser(
        email: emailController.text,
        password: passwordController.text,
      );
      showMessage("Kayıt Başarılı", false);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BusinessDashBoardPage()),
      );
    } on FirebaseAuthException {
      showMessage("Kayıt Başarısız", true);
    }
  }

  Future<void> signIn() async {
    try {
      await Auth().signIn(
        email: emailController.text,
        password: passwordController.text,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BusinessDashBoardPage()),
      );
    } on FirebaseAuthException {
      showMessage("Giriş Başarısız", true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 40),

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFFF6A00),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF6A00).withOpacity(0.4),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: Icon(
                    isLogin
                        ? Icons.admin_panel_settings
                        : Icons.person_add_alt_1,
                    size: 44,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  isLogin ? "İşletme Girişi" : "Yeni Hesap Oluştur",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  isLogin
                      ? "Yönetim paneline giriş yap"
                      : "Yeni bir işletme hesabı oluştur",
                  style: const TextStyle(color: Colors.white70),
                ),

                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: const Color(0xFF121212),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Column(
                    children: [
                      _DarkTextField(
                        controller: emailController,
                        hintText: "Email",
                        icon: Icons.email_outlined,
                        obscureText: false,
                      ),
                      const SizedBox(height: 16),
                      _DarkTextField(
                        controller: passwordController,
                        hintText: "Şifre",
                        icon: Icons.lock_outline,
                        obscureText: true,
                      ),
                      const SizedBox(height: 26),

                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            isLogin ? signIn() : createUser();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF6A00),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            isLogin ? "GİRİŞ YAP" : "HESAP OLUŞTUR",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isLogin = !isLogin;
                          });
                        },
                        child: Text(
                          isLogin
                              ? "Hesap oluştur"
                              : "Zaten hesabın var mı? Giriş yap",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DarkTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final IconData icon;

  const _DarkTextField({
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.black,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white38),
        prefixIcon: Icon(icon, color: const Color(0xFFFF6A00)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFFF6A00), width: 2),
        ),
      ),
    );
  }
}
