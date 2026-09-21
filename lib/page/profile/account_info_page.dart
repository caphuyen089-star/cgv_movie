import 'package:flutter/material.dart';

class AccountInfoPage extends StatelessWidget {
  const AccountInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thông tin tài khoản"),
        backgroundColor: const Color(0xFFD3432B),
      ),
      body: const Center(
        child: Text(
          "Thông tin tài khoản",
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}