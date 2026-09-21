import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MomoQrDialog extends StatelessWidget {
  final double amount; // Số tiền cần thanh toán
  final String orderId; // Mã đơn hàng

  const MomoQrDialog({
    super.key,
    required this.amount,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    // Chuỗi dữ liệu QR MoMo (Thực tế sẽ lấy URL thanh toán từ API MoMo)
    final String qrData = "2|99|0987654321|CGV CINEMA|cgv@cinema.vn|0|0|${amount.toInt()}|$orderId";

    return Dialog(
      backgroundColor: const Color(0xFF1E1E24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header MoMo
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFFA50064), // Màu hồng MoMo
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'momo',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Thanh toán qua Ví MoMo',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Mã QR Code
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: QrImageView(
                data: qrData,
                version: QrVersions.auto,
                size: 200.0,
              ),
              /* HOẶC DÙNG ẢNH TĨNH:
              child: Image.asset(
                'assets/images/momo_qr.png',
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
              */
            ),
            const SizedBox(height: 16),

            // Số tiền cần thanh toán
            Text(
              'Số tiền: ${amount.toStringAsFixed(0)} VNĐ',
              style: const TextStyle(
                color: Colors.amber,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Mã đơn hàng: #$orderId',
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 12),
            const Text(
              'Sử dụng App MoMo để quét mã QR này',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 20),

            // Nút đóng / Hoàn tất
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD3432B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  // Có thể chuyển hướng sang trang thành công/vé của tôi ở đây
                },
                child: const Text(
                  'ĐÃ THANH TOÁN / ĐÓNG',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}