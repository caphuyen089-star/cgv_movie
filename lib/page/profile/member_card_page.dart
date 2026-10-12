import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MemberCardPage extends StatefulWidget {
  const MemberCardPage({super.key});

  @override
  State<MemberCardPage> createState() => _MemberCardPageState();
}

class _MemberCardPageState extends State<MemberCardPage> {
  final TextEditingController _cardCodeController = TextEditingController();
  static const Color primaryRed = Color(0xFFE52521);
  bool _showQrCode = false;

  @override
  void dispose() {
    _cardCodeController.dispose();
    super.dispose();
  }

  void _addCard() {
    if (_cardCodeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Vui lòng nhập mã số thẻ CGV!'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Thêm thẻ thành viên mới thành công!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    _cardCodeController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final String userName = user?.displayName ?? 
        (user?.email != null ? user!.email!.split('@')[0].toUpperCase() : 'CGV MEMBER');

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: primaryRed, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Thẻ thành viên',
          style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= 1. THẺ THÀNH VIÊN VISUAL VIP CARD =================
            GestureDetector(
              onTap: () {
                setState(() {
                  _showQrCode = !_showQrCode;
                });
              },
              child: Container(
                width: double.infinity,
                height: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE52521), Color(0xFFB71C1C), Color(0xFF880E4F)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: primaryRed.withOpacity(0.35),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Họa tiết trang trí chìm
                    Positioned(
                      right: -30,
                      bottom: -30,
                      child: Icon(
                        Icons.movie_filter_rounded,
                        size: 180,
                        color: Colors.white.withOpacity(0.12),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Hàng 1: Logo & Hạng thẻ
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.network(
                                    'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/CGV_Logo.svg/1280px-CGV_Logo.svg.png',
                                    height: 22,
                                    color: Colors.white,
                                    errorBuilder: (_, __, ___) => const Text(
                                      'CGV',
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.amber[700],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      'MEMBER',
                                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              const Icon(Icons.nfc, color: Colors.white70, size: 28),
                            ],
                          ),

                          // Hàng 2: Mã QR (hoặc Mã Thẻ dạng text)
                          if (_showQrCode)
                            Center(
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(Icons.qr_code_2, size: 65, color: Colors.black87),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Chạm để ẩn mã QR',
                                    style: TextStyle(color: Colors.white70, fontSize: 10),
                                  ),
                                ],
                              ),
                            )
                          else
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'MÃ THẺ THÀNH VIÊN',
                                  style: TextStyle(color: Colors.white60, fontSize: 10, letterSpacing: 1),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  '9998  8812  4515  9159',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ],
                            ),

                          // Hàng 3: Tên chủ thẻ & Điểm thưởng
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'CHỦ THẺ',
                                    style: TextStyle(color: Colors.white60, fontSize: 9, letterSpacing: 1),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    userName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.stars, color: Colors.amber, size: 16),
                                    SizedBox(width: 4),
                                    Text(
                                      '0 P',
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),

            // ================= 2. KHUNG ĐĂNG KÝ / LIÊN KẾT THẺ MỚI =================
            const Text(
              'LIÊN KẾT THẺ MỚI',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown, fontSize: 13, letterSpacing: 0.5),
            ),
            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _cardCodeController,
                    decoration: InputDecoration(
                      hintText: 'Nhập mã số thẻ CGV / GiftCard',
                      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                      prefixIcon: const Icon(Icons.credit_card_rounded, color: primaryRed),
                      fillColor: Colors.grey[50],
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[200]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: primaryRed, width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryRed,
                        elevation: 1,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _addCard,
                      child: const Text(
                        'ĐĂNG KÝ LIÊN KẾT',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 0.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ================= 3. DANH SÁCH THẺ ĐANG HOẠT ĐỘNG =================
            const Text(
              'DANH SÁCH THẺ CỦA BẠN (1)',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown, fontSize: 13, letterSpacing: 0.5),
            ),
            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.red[50],
                        child: const Icon(Icons.phone_android_rounded, color: primaryRed),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Mobile Card',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.green[50],
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'Hoạt động',
                                    style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '9998 •••• •••• 9159',
                              style: TextStyle(color: Colors.grey[600], fontSize: 13, fontFamily: 'monospace'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24, thickness: 0.8),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _showQrCode = !_showQrCode;
                      });
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Xem mã vạch QR quét tại rạp',
                          style: TextStyle(color: primaryRed, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        Icon(Icons.qr_code, size: 18, color: primaryRed),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}