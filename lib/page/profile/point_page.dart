import 'package:flutter/material.dart';

class PointPage extends StatelessWidget {
  const PointPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFD3432B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Điểm CGV',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Color(0xFFD3432B)),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          // Khung hiển thị tổng số điểm lớn
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(vertical: 24),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: const Column(
              children: [
                Icon(Icons.monetization_on_outlined, color: Color(0xFFD3432B), size: 40),
                SizedBox(height: 8),
                Text(
                  '0',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                Text(
                  'ĐIỂM',
                  style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          
          // Tiêu đề danh sách hết hạn
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ĐIỂM SẮP HẾT HẠN',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.brown),
                ),
                Text(
                  'NGÀY HẾT HẠN\n(NGÀY - THÁNG - NĂM)',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
          
          const Divider(indent: 16, endIndent: 16, thickness: 1),
          
          const Spacer(),
          
          // Hình vẽ biểu tượng thông báo trống ở cuối trang
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.yellow[100],
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.sentiment_satisfied_alt,
                  size: 50,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  'Bạn không có điểm nào sắp hết hạn trong 3 tháng tới.',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}