import 'package:flutter/material.dart';

class VoucherPage extends StatelessWidget {
  const VoucherPage({super.key});

  Widget _buildMenuRow(String title, String count) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white,
      child: ListTile(
        title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(count, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFD3432B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('CGV eGift | Voucher | Coupon', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildMenuRow('1. CGV eGift', '0'),
          _buildMenuRow('2. Voucher', '0'),
          _buildMenuRow('3. Coupon', '2'),
          _buildMenuRow('4. Thẻ quà tặng', '0'),
        ],
      ),
    );
  }
}