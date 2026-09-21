import 'package:flutter/material.dart';

class SelectTheaterPage extends StatelessWidget {
  const SelectTheaterPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Lấy danh sách rạp mẫu mô phỏng từ cấu trúc file booking_page.dart của bạn
    final List<Map<String, String>> theaters = [
      {'name': 'CGV AEON Bình Tân', 'address': 'Tầng 3, TTTM AEON Mall Bình Tân, Bình Tân, TP.HCM'},
      {'name': 'CGV Vincom Đồng Khởi', 'address': 'Tầng 3, TTTM Vincom Center Đồng Khởi, Quận 1, TP.HCM'},
      {'name': 'CGV Hùng Vương Plaza', 'address': 'Tầng 7, Hùng Vương Plaza, Quận 5, TP.HCM'},
      {'name': 'CGV Crescent Mall', 'address': 'Tầng 5, TTTM Crescent Mall, Quận 7, TP.HCM'},
      {'name': 'CGV Sư Vạn Hạnh', 'address': 'Tầng 6, TTTM Vạn Hạnh Mall, Quận 10, TP.HCM'},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Chọn rạp của bạn',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: ListView.separated(
        itemCount: theaters.length,
        separatorBuilder: (context, index) => const Divider(height: 1, color: Colors.black12),
        itemBuilder: (context, index) {
          final theater = theaters[index];

          return InkWell(
            onTap: () {
              // Xử lý khi chọn rạp: có thể chuyển hướng thẳng sang màn hình lịch chiếu/đặt vé
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Bạn đã chọn: ${theater['name']}')),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Row(
                children: [
                  // Icon rạp chiếu phim (Hình ngôi sao giống ứng dụng CGV)
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: Color(0xFFF5F5F5),
                    child: Icon(Icons.star, color: Color(0xFFD3432B), size: 22),
                  ),
                  const SizedBox(width: 14),
                  
                  // Tên rạp và địa chỉ
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          theater['name']!,
                          style: const TextStyle(
                            fontSize: 15, 
                            fontWeight: FontWeight.bold, 
                            color: Colors.black
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          theater['address']!,
                          style: TextStyle(
                            fontSize: 12, 
                            color: Colors.grey[600],
                            overflow: TextOverflow.ellipsis
                          ),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  
                  // Mũi tên góc phải
                  const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}