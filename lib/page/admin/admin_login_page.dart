import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../admin/admin_page.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isHide = true;
  bool isLoading = false;
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  // Tải thông tin tài khoản đã lưu
  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      rememberMe = prefs.getBool('remember_admin') ?? false;
      if (rememberMe) {
        emailController.text = prefs.getString('saved_admin_email') ?? '';
        passwordController.text = prefs.getString('saved_admin_password') ?? '';
      }
    });
  }

  // Lưu hoặc xóa thông tin tài khoản
  Future<void> _saveCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    if (rememberMe) {
      await prefs.setBool('remember_admin', true);
      await prefs.setString('saved_admin_email', emailController.text.trim());
      await prefs.setString('saved_admin_password', passwordController.text.trim());
    } else {
      await prefs.remove('remember_admin');
      await prefs.remove('saved_admin_email');
      await prefs.remove('saved_admin_password');
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _loginAdmin() async {
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
      // 1. Đăng nhập Auth
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;

      // 2. Kiểm tra role trên Firestore
      String uid = userCredential.user!.uid;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (!mounted) return;

      if (userDoc.exists && userDoc.data() != null) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        String role = userData['role'] ?? 'user';

        // 3. BẮT BỘC LÀ ADMIN MỚI CHO VÀO
        if (role == 'admin') {
          // Lưu thông tin nếu tick chọn Remember Me
          await _saveCredentials();

          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Đăng nhập Admin thành công!")),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const AdminPage()),
          );
        } else {
          await FirebaseAuth.instance.signOut();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Tài khoản này không có quyền Quản trị (Admin)!")),
          );
        }
      } else {
        await FirebaseAuth.instance.signOut();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Không tìm thấy dữ liệu người dùng!")),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Đăng nhập thất bại: ${e.message}")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Đã xảy ra lỗi: ${e.toString()}")),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Đăng nhập Quản Trị Viên", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: AutofillGroup(
            child: Column(
              children: [
                const SizedBox(height: 40),
                const Icon(Icons.admin_panel_settings, size: 100, color: Colors.red),
                const SizedBox(height: 20),
                const Text(
                  "ADMIN PORTAL",
                  style: TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),

                /// Email
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.email],
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Email Admin",
                    hintStyle: const TextStyle(color: Colors.white54),
                    prefixIcon: const Icon(Icons.email, color: Colors.red),
                    filled: true,
                    fillColor: Colors.white12,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 20),

                /// Password
                TextField(
                  controller: passwordController,
                  obscureText: isHide,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.password],
                  style: const TextStyle(color: Colors.white),
                  onSubmitted: (_) {
                    if (!isLoading) _loginAdmin(); // Bấm Enter trên bàn phím để đăng nhập
                  },
                  decoration: InputDecoration(
                    hintText: "Mật khẩu Admin",
                    hintStyle: const TextStyle(color: Colors.white54),
                    prefixIcon: const Icon(Icons.lock, color: Colors.red),
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => isHide = !isHide),
                      icon: Icon(isHide ? Icons.visibility_off : Icons.visibility, color: Colors.white),
                    ),
                    filled: true,
                    fillColor: Colors.white12,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 10),

                /// Checkbox Lưu mật khẩu
                Row(
                  children: [
                    Theme(
                      data: ThemeData(unselectedWidgetColor: Colors.white54),
                      child: Checkbox(
                        value: rememberMe,
                        activeColor: Colors.red,
                        onChanged: (value) {
                          setState(() {
                            rememberMe = value ?? false;
                          });
                        },
                      ),
                    ),
                    const Text(
                      "Ghi nhớ mật khẩu",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                /// Button Đăng nhập
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    onPressed: isLoading ? null : _loginAdmin,
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("ĐĂNG NHẬP ADMIN", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
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