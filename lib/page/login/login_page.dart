import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../home/home_page.dart';
import '../register/register_page.dart';
import 'forgot_password_page.dart';
import 'admin_login_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isHide = true;
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập đầy đủ Email và Mật khẩu")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      TextInput.finishAutofillContext();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đăng nhập thành công!")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      String message = "Đăng nhập thất bại";
      if (e.code == 'user-not-found') message = "Tài khoản không tồn tại";
      if (e.code == 'wrong-password') message = "Mật khẩu không chính xác";
      if (e.code == 'invalid-credential') message = "Thông tin đăng nhập không chính xác";

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Đã xảy ra lỗi: ${e.toString()}")));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// 1. Ảnh nền Full màn hình
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset("assets/images/hoat_hinh.jpg", fit: BoxFit.cover),
          ),
          Container(color: Colors.black.withOpacity(0.65)),
          
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  const SizedBox(height: 30),

                  /// 2. LOGO MINION ĐÃ TÁCH NỀN (Nổi bật & Đẹp mắt)
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.redAccent.withOpacity(0.35),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      "assets/images/meo_beo.jpg", // 👈 Hãy đảm bảo bạn đã lưu ảnh tách nền (.png) với tên này trong assets/images/
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 15),
                  const Text(
                    "Welcome Back",
                    style: TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Đăng nhập để đặt vé xem phim",
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                  const SizedBox(height: 35),

                  /// 3. Khung nhập liệu
                  AutofillGroup(
                    child: Column(
                      children: [
                        /// Email
                        TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [AutofillHints.email, AutofillHints.username],
                          textInputAction: TextInputAction.next,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Email",
                            hintStyle: const TextStyle(color: Colors.white54),
                            prefixIcon: const Icon(Icons.email, color: Colors.red),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),

                        /// Password
                        TextField(
                          controller: passwordController,
                          obscureText: isHide,
                          autofillHints: const [AutofillHints.password],
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) {
                            if (!isLoading) _login();
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Password",
                            hintStyle: const TextStyle(color: Colors.white54),
                            prefixIcon: const Icon(Icons.lock, color: Colors.red),
                            suffixIcon: IconButton(
                              onPressed: () => setState(() => isHide = !isHide),
                              icon: Icon(
                                isHide ? Icons.visibility_off : Icons.visibility,
                                color: Colors.white70,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ForgotPasswordPage()),
                      ),
                      child: const Text("Quên mật khẩu?", style: TextStyle(color: Colors.redAccent)),
                    ),
                  ),
                  const SizedBox(height: 15),

                  /// Nút Đăng nhập
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 5,
                      ),
                      onPressed: isLoading ? null : _login,
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "ĐĂNG NHẬP",
                              style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Chưa có tài khoản?", style: TextStyle(color: Colors.white70)),
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const RegisterPage()),
                        ),
                        child: const Text("Đăng ký", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),

                  const SizedBox(height: 5),

                  /// Nút Đăng nhập Admin
                  TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AdminLoginPage()),
                      );
                    },
                    icon: const Icon(Icons.security, color: Colors.amber, size: 18),
                    label: const Text(
                      "Đăng nhập dành cho Quản lý",
                      style: TextStyle(color: Colors.amber, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}