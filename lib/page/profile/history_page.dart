import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  Widget _buildHistoryRow(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      color: Colors.white,
      child: ListTile(
        title: Text(title, style: const TextStyle(fontSize: 14, color: Colors.black87)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        onTap: () {},
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
        title: const Text('Lịch sử Giao dịch', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
        actions: [IconButton(icon: const Icon(Icons.menu, color: Color(0xFFD3432B)), onPressed: () {})],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          _buildHistoryRow('1. Theo dõi hạng thành viên'),
          _buildHistoryRow('2. Lịch sử hoàn vé'),
          _buildHistoryRow('3. Lịch sử vé của tôi'),
          _buildHistoryRow('4. Lịch sử bắp nước | Quầy trực tuyến'),
          _buildHistoryRow('5. Lịch sử CGV eGift'),
          _buildHistoryRow('6. Lịch sử sự kiện | ICECON'),
          _buildHistoryRow('7. Lịch sử đặt hàng trước'),
        ],
      ),
    );
  }
}