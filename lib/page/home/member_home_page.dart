import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MemberHomePage extends StatelessWidget {
  const MemberHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Lấy thông tin user hiện tại từ Firebase Auth
    final user = FirebaseAuth.instance.currentUser;

    // Lấy tên hiển thị, nếu không có tên thì lấy Email cắt phần @
    final String displayName = user?.displayName ?? 
        (user?.email != null ? user!.email!.split('@')[0].toUpperCase() : "Chưa cập nhật");
    final String email = user?.email ?? "Chưa cập nhật";
    final String phone = user?.phoneNumber ?? "Chưa cập nhật";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFD3432B),
        title: const Text(
          "Thông tin tài khoản",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Hiển thị Avatar thật nếu có, nếu không hiển thị Icon
              CircleAvatar(
                radius: 50,
                backgroundColor: const Color(0xFFD3432B),
                backgroundImage: user?.photoURL != null 
                    ? NetworkImage(user!.photoURL!) 
                    : null,
                child: user?.photoURL == null 
                    ? const Icon(Icons.person, size: 60, color: Colors.white)
                    : null,
              ),

              const SizedBox(height: 20),

              _buildInfoTile(
                icon: Icons.person,
                title: "Họ và tên",
                value: displayName,
              ),

              _buildInfoTile(
                icon: Icons.email,
                title: "Email",
                value: email,
              ),

              _buildInfoTile(
                icon: Icons.phone,
                title: "Số điện thoại",
                value: phone,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        leading: Icon(
          icon,
          color: const Color(0xFFD3432B),
        ),
        title: Text(title),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}