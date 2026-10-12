import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../provider/ticket_provider.dart';

class TicketHistoryPage extends StatelessWidget {
  const TicketHistoryPage({super.key});

  static const Color primaryRed = Color(0xFFE52521);

  // 🟢 Hàm xử lý điều hướng chung về trang Home
  void _navigateToHome(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final ticketProvider = context.watch<TicketProvider>();
    final tickets = ticketProvider.tickets;
    final currencyFormat = NumberFormat('#,###', 'vi_VN');

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _navigateToHome(context);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF121212), // Nền tối Cinema chuẩn
        appBar: AppBar(
          backgroundColor: const Color(0xFF1E1E24),
          elevation: 0.5,
          title: const Text(
            'Vé Của Tôi',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
            onPressed: () => _navigateToHome(context),
          ),
          centerTitle: true,
        ),
        body: tickets.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.confirmation_number_outlined,
                        size: 70,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Bạn chưa có vé nào được đặt',
                      style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Các vé bạn đã thanh toán sẽ hiển thị tại đây.',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryRed,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      icon: const Icon(Icons.movie_outlined, color: Colors.white, size: 18),
                      label: const Text('ĐẶT VÉ NGAY', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      onPressed: () => _navigateToHome(context),
                    )
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: tickets.length,
                itemBuilder: (context, index) {
                  final ticket = tickets[index];

                  // Kiểm tra an toàn danh sách ghế
                  final String seatsDisplay = (ticket.seats.isNotEmpty)
                      ? ticket.seats.join(', ')
                      : 'Chưa chọn';

                  final String ticketCode =
                      '#${ticket.id.toString().substring(ticket.id.toString().length - (ticket.id.toString().length > 6 ? 6 : ticket.id.toString().length))}';

                  return Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: ClipPath(
                      clipper: TicketClipper(),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E24),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 1. MÃ VÉ & TRẠNG THÁI
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.confirmation_number, color: Colors.amber, size: 20),
                                          const SizedBox(width: 8),
                                          Text(
                                            'MÃ VÉ: $ticketCode',
                                            style: const TextStyle(
                                              color: Colors.amber,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              fontFamily: 'monospace',
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.green.withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(color: Colors.green.withOpacity(0.5)),
                                        ),
                                        child: const Row(
                                          children: [
                                            Icon(Icons.check_circle_outline, color: Colors.green, size: 12),
                                            SizedBox(width: 4),
                                            Text(
                                              'Đã thanh toán',
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(color: Colors.white10, height: 24),

                                  // 2. THÔNG TIN RẠP & SUẤT CHIẾU
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.location_on_outlined, color: primaryRed, size: 18),
                                      const SizedBox(width: 8),
                                      const Expanded(
                                        child: Text(
                                          'CGV Vincom Đồng Khởi',
                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),

                                  // Khung Suất chiếu & Ghế dạng Grid
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF141418),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text('SUẤT CHIẾU', style: TextStyle(color: Colors.grey, fontSize: 10, letterSpacing: 0.5)),
                                              const SizedBox(height: 4),
                                              Text(
                                                ticket.showTime,
                                                style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(width: 1, height: 30, color: Colors.white10),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 12.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Text('GHẾ NỒI', style: TextStyle(color: Colors.grey, fontSize: 10, letterSpacing: 0.5)),
                                                const SizedBox(height: 4),
                                                Text(
                                                  seatsDisplay,
                                                  style: const TextStyle(color: primaryRed, fontSize: 14, fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // 🍿 3. KHU VỰC HIỂN THỊ BẮP NƯỚC (NẾU CÓ)
                                  if (ticket.foods != null && ticket.foods!.isNotEmpty) ...[
                                    const SizedBox(height: 12),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.amber.withOpacity(0.08),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.amber.withOpacity(0.2)),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Row(
                                            children: [
                                              Icon(Icons.fastfood_outlined, color: Colors.amber, size: 14),
                                              SizedBox(width: 6),
                                              Text(
                                                'Bắp nước đã kèm:',
                                                style: TextStyle(color: Colors.amber, fontSize: 11, fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          ...ticket.foods!.map((item) => Padding(
                                                padding: const EdgeInsets.only(top: 2),
                                                child: Text(
                                                  '• $item',
                                                  style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500),
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),

                            // Đường vạch đứt kiểu vé xem phim
                            Row(
                              children: List.generate(
                                30,
                                (i) => Expanded(
                                  child: Container(
                                    color: i % 2 == 0 ? Colors.transparent : Colors.grey[700],
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ),

                            // 4. TỔNG TIỀN & THAO TÁC (QUÉT QR / HỦY VÉ)
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Tổng thanh toán:', style: TextStyle(color: Colors.grey, fontSize: 13)),
                                      Text(
                                        '${currencyFormat.format(ticket.totalPrice)} đ',
                                        style: const TextStyle(color: Colors.amber, fontSize: 17, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 14),

                                  Row(
                                    children: [
                                      // Nút Xem Mã QR Soát Vé
                                      Expanded(
                                        flex: 2,
                                        child: ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: primaryRed,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                            padding: const EdgeInsets.symmetric(vertical: 10),
                                          ),
                                          icon: const Icon(Icons.qr_code_2_rounded, color: Colors.white, size: 18),
                                          label: const Text('MÃ VÀO RẠP', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                                          onPressed: () {
                                            _showQrTicketDialog(context, ticketCode, seatsDisplay, ticket.showTime);
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 8),

                                      // Nút Hủy Vé
                                      Expanded(
                                        flex: 1,
                                        child: OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            side: const BorderSide(color: Colors.redAccent),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                            padding: const EdgeInsets.symmetric(vertical: 10),
                                          ),
                                          onPressed: () {
                                            _showCancelDialog(context, ticket.id);
                                          },
                                          child: const Text('Hủy vé', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 12)),
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
                  );
                },
              ),
      ),
    );
  }

  // Modal hiển thị QR Code để vào phòng chiếu
  void _showQrTicketDialog(BuildContext context, String code, String seats, String time) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('MÃ SOÁT VÉ CGV', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 4),
              Text(code, style: const TextStyle(color: Colors.white70, fontSize: 13, fontFamily: 'monospace')),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.qr_code_2_rounded, size: 160, color: Colors.black87),
              ),
              const SizedBox(height: 12),
              Text('Suất: $time | Ghế: $seats', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              const Text('Vui lòng đưa mã này cho nhân viên soát vé', style: TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('ĐÓNG', style: TextStyle(color: primaryRed, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        );
      },
    );
  }

  void _showCancelDialog(BuildContext context, int ticketId) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Xác nhận hủy vé', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          content: const Text(
            'Bạn có chắc chắn muốn hủy vé này không? Vé sau khi hủy sẽ không thể khôi phục.',
            style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Bỏ qua', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: primaryRed),
              onPressed: () {
                context.read<TicketProvider>().removeTicket(ticketId);
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Đã hủy vé thành công!'),
                    backgroundColor: Colors.redAccent,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                );
              },
              child: const Text('Đồng ý Hủy', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }
}

class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);

    double cutoutRadius = 10;
    double cutoutY = size.height * 0.65;

    Path leftCutout = Path()
      ..addOval(Rect.fromCircle(center: Offset(0, cutoutY), radius: cutoutRadius));

    Path rightCutout = Path()
      ..addOval(Rect.fromCircle(center: Offset(size.width, cutoutY), radius: cutoutRadius));

    return Path.combine(
      PathOperation.difference,
      Path.combine(PathOperation.difference, path, leftCutout),
      rightCutout,
    );
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}