import 'package:flutter/material.dart';

class CgvStorePage extends StatefulWidget {
  const CgvStorePage({super.key});

  @override
  State<CgvStorePage> createState() => _CgvStorePageState();
}

class _CgvStorePageState extends State<CgvStorePage> {
  String _area = "Hà Nội";
  String _cinema = "CGV Aeon Hà Đông";
  
  // 🛠️ Thêm biến quản lý ngày đang chọn (Mặc định ban đầu là ngày 21)
  int _selectedDate = 21; 

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
        title: const Text("CGV Store", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(icon: const Icon(Icons.shopping_bag, color: Colors.red, size: 30), onPressed: () {}),
              Positioned(
                right: 8, top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: const Text("0", style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
          IconButton(icon: const Icon(Icons.menu, color: Colors.red), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // ================= THANH THÔNG BÁO TRÊN CÙNG =================
          Container(
            padding: const EdgeInsets.all(12),
            color: const Color(0xFFEFEAEA),
            child: Row(
              children: [
                const Icon(Icons.location_on, color: Colors.orange),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🛠️ ĐÃ SỬA: Hiển thị rạp đang chọn thực tế thay vì chữ mặc định
                    Text("Rạp nhận: $_cinema", style: const TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.w600)),
                    // 🛠️ ĐÃ SỬA: Hiển thị ngày đang chọn thực tế
                    Text("Ngày nhận: Thứ 3, $_selectedDate Tháng 7, 2026", style: const TextStyle(fontSize: 12, color: Colors.black54)),
                  ],
                ),
                const Spacer(),
                const Icon(Icons.arrow_drop_up, color: Colors.black),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Chọn Rạp", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown)),
                DropdownButton<String>(
                  value: _area,
                  isExpanded: true,
                  items: ["Hà Nội", "Hồ Chí Minh"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (v) => setState(() => _area = v!),
                ),
                DropdownButton<String>(
  value: _area,
  isExpanded: true,
  items: ["Hà Nội", "Hồ Chí Minh"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
  onChanged: (v) {
    setState(() {
      _area = v!;
      // 🛠️ Tự động reset rạp mặc định tương ứng khi đổi thành phố để tránh lỗi crash
      _cinema = _area == "Hà Nội" ? "CGV Aeon Hà Đông" : "CGV Vivo City";
    });
  },
),
                  DropdownButton<String>(
                    value: _cinema,
                    isExpanded: true,
                    // 🛠️ ĐÃ SỬA: Thêm .map().toList() vào sau cặp ngoặc vuông để hết gạch đỏ
                    items: (_area == "Hà Nội"
                            ? ["CGV Aeon Hà Đông", "CGV Vincom Nguyễn Chí Thanh"]
                            : ["CGV Vivo City", "CGV Vạn Hạnh Mall"])
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) => setState(() => _cinema = v!),
                  ),
                const SizedBox(height: 16),
                const Text("Chọn ngày", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown)),
                const SizedBox(height: 10),

                // ================= CHỌN NGÀY (BẤM ĐƯỢC) =================
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Ngày 21
                    GestureDetector(
                      onTap: () => setState(() => _selectedDate = 21),
                      child: CircleAvatar(
                        backgroundColor: _selectedDate == 21 ? const Color(0xFFB7232A) : Colors.transparent,
                        radius: 20,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Hôm nay", style: TextStyle(fontSize: 8, color: _selectedDate == 21 ? Colors.white70 : Colors.grey)),
                            Text("21", style: TextStyle(fontSize: 14, color: _selectedDate == 21 ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    
                    // Ngày 22
                    GestureDetector(
                      onTap: () => setState(() => _selectedDate = 22),
                      child: CircleAvatar(
                        backgroundColor: _selectedDate == 22 ? const Color(0xFFB7232A) : Colors.transparent,
                        radius: 20,
                        child: Center(
                          child: Text("22", style: TextStyle(color: _selectedDate == 22 ? Colors.white : Colors.grey, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    
                    // Ngày 23
                    GestureDetector(
                      onTap: () => setState(() => _selectedDate = 23),
                      child: CircleAvatar(
                        backgroundColor: _selectedDate == 23 ? const Color(0xFFB7232A) : Colors.transparent,
                        radius: 20,
                        child: Center(
                          child: Text("23", style: TextStyle(color: _selectedDate == 23 ? Colors.white : Colors.grey, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    "Thứ 3, $_selectedDate Tháng 7, 2026", 
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ),
                const SizedBox(height: 30),
                
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB7232A),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    ),
                    onPressed: () {
                      // Hiện thông báo test khi bấm nút CHỌN
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Đã chọn: $_cinema - Ngày $_selectedDate")),
                      );
                    },
                    child: const Text("CHỌN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}