import 'package:flutter/material.dart';

class IceconPage extends StatelessWidget {
  const IceconPage({super.key}); // Giữ const ở constructor vì lớp này là StatelessWidget sạch

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.red),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("ICECON", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: false,
        actions: [
          IconButton(icon: const Icon(Icons.confirmation_number_outlined, color: Colors.red), onPressed: () {}),
          IconButton(icon: const Icon(Icons.menu, color: Colors.red), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 180,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black, Color(0xFFB7232A)],
                  begin: Alignment.bottomLeft, end: Alignment.topRight,
                ),
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    width: 100, height: 140,
                    color: Colors.white,
                    child: const Center(child: Text("MSI 2026", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Nội dung ICECON", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(width: 100, height: 140, color: Colors.grey[300], child: const Icon(Icons.image)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              color: Colors.grey[300],
                              child: const Text("ĐÃ MỞ BÁN", style: TextStyle(fontSize: 10)),
                            ),
                            const SizedBox(height: 4),
                            const Text("VIEWING PARTY MSI 2026", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            const SizedBox(height: 4),
                            Text("Hãy cùng nhau hội tụ và tạo nên một chảo lửa...", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFB7232A)),
                              onPressed: () {},
                              child: const Text("MUA NGAY", style: TextStyle(color: Colors.white)),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}