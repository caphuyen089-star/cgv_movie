import 'package:flutter/material.dart';

class PaymentPinPage extends StatelessWidget {
  const PaymentPinPage({super.key});

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
        title: const Text('Cài đặt mật mã thanh toán', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
        actions: [IconButton(icon: const Icon(Icons.menu, color: Color(0xFFD3432B)), onPressed: () {})],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('MẬT MÃ THANH TOÁN', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown, fontSize: 14)),
            const SizedBox(height: 8),
            Text(
              '- Mật mã thanh toán dùng để xác minh các giao dịch thanh toán bằng Coupon, Voucher, Đổi điểm thưởng, Thẻ ưu tiên, Thẻ quà tặng.\n'
              '- Mật mã thanh toán phải có đúng 6 chữ số và không được là 6 số trùng nhau (VD: 111111).',
              style: TextStyle(color: Colors.grey[700], fontSize: 13, height: 1.4),
            ),
            const SizedBox(height: 20),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Mật mã mới',
                fillColor: Colors.white,
                filled: true,
                suffixIcon: const Icon(Icons.visibility_off_outlined, color: Colors.grey),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Nhập lại mật mã mới',
                fillColor: Colors.white,
                filled: true,
                suffixIcon: const Icon(Icons.visibility_off_outlined, color: Colors.grey),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD3432B),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                onPressed: () {},
                child: const Text('ĐỒNG Ý', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}