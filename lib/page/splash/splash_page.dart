import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../home/home_page.dart';
import '../login/login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Khởi tạo hiệu ứng xuất hiện (Fade + Scale)
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _animationController.forward();

    // Chuyển trang sau 3 giây
    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      final currentUser = FirebaseAuth.instance.currentUser;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (_, __, ___) =>
              currentUser != null ? const HomePage() : const LoginPage(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Nền Gradient chuyển màu cực sang
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF2B090A), // Đỏ đô cực tối phía trên
                  Color(0xFF0F0F0F), // Đen huyền bí ở giữa
                  Color(0xFF000000), // Đen tuyền bên dưới
                ],
              ),
            ),
          ),

          // 2. Nội dung chính giữa màn hình có Animation
          SafeArea(
            child: Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Khung chứa Logo có viền phát sáng nhẹ
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.25),
                              blurRadius: 40,
                              spreadRadius: 10,
                            ),
                          ],
                          border: Border.all(
                            color: Colors.red.withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.asset(
                            "assets/images/hoat_hinh.jpg", // Thay logo/ảnh của bạn ở đây
                            width: 130,
                            height: 130,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 35),

                      // Tên ứng dụng phong cách Cinema
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Colors.white, Colors.redAccent],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ).createShader(bounds),
                        child: const Text(
                          "CINEMA BOOKING",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 4.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      const Text(
                        "Đặt vé xem phim nhanh chóng",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white54,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 50),

                      // Thanh Loading mảnh tinh tế
                      SizedBox(
                        width: 120,
                        child: LinearProgressIndicator(
                          color: Colors.red,
                          backgroundColor: Colors.white10,
                          borderRadius: BorderRadius.circular(10),
                          minHeight: 3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 3. Footer thể hiện độ chuyên nghiệp ở dưới cùng
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "POWERED BY CGV CINEMA",
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white.withOpacity(0.3),
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}