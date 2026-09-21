import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../provider/ticket_provider.dart';

class TicketHistoryPage extends StatelessWidget {
  const TicketHistoryPage({super.key});

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
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text(
            'Vé Của Tôi',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => _navigateToHome(context),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: tickets.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.confirmation_number_outlined, size: 80, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Bạn chưa có vé nào được đặt',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
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

                  return Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: ClipPath(
                      clipper: TicketClipper(),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E24),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white10),
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
                                      Text(
                                        'MÃ VÉ: #${ticket.id.toString().substring(ticket.id.toString().length - 6)}',
                                        style: const TextStyle(
                                          color: Colors.amber,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.green.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: const Text(
                                          'Đã thanh toán',
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(color: Colors.white10, height: 20),

                                  // 2. THÔNG TIN RẠP & SUẤT CHIẾU
                                  Row(
                                    children: const [
                                      Icon(Icons.location_on, color: Colors.grey, size: 16),
                                      SizedBox(width: 6),
                                      Text('CGV Vincom Đồng Khởi', style: TextStyle(color: Colors.grey, fontSize: 13)),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.access_time, color: Colors.grey, size: 16),
                                      const SizedBox(width: 6),
                                      Text('Suất chiếu: ${ticket.showTime}', style: const TextStyle(color: Colors.white, fontSize: 13)),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.event_seat, color: Colors.grey, size: 16),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Ghế chọn: $seatsDisplay',
                                        style: const TextStyle(color: Colors.redAccent, fontSize: 13, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),

                                  // 🍿 3. KHU VỰC HIỂN THỊ BẮP NƯỚC (NẾU CÓ)
                                  if (ticket.foods != null && ticket.foods!.isNotEmpty) ...[
                                    const SizedBox(height: 12),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF141418),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Row(
                                            children: [
                                              Icon(Icons.fastfood, color: Colors.amber, size: 14),
                                              SizedBox(width: 6),
                                              Text(
                                                'Bắp nước đã kèm:',
                                                style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          ...ticket.foods!.map((item) => Padding(
                                                padding: const EdgeInsets.only(top: 2),
                                                child: Text(
                                                  '• $item',
                                                  style: const TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.w500),
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),

                            // Đường vạch đứt
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

                            // 4. TỔNG TIỀN & NÚT HỦY
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
                                        style: const TextStyle(color: Colors.amber, fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: double.infinity,
                                    child: OutlinedButton.icon(
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(color: Colors.redAccent),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                      ),
                                      icon: const Icon(Icons.cancel_outlined, color: Colors.redAccent, size: 18),
                                      label: const Text('HỦY VÉ NÀY', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                                      onPressed: () {
                                        _showCancelDialog(context, ticket.id);
                                      },
                                    ),
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

  void _showCancelDialog(BuildContext context, int ticketId) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E24),
          title: const Text('Xác nhận hủy vé', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          content: const Text(
            'Bạn có chắc chắn muốn hủy vé này không? Vé sau khi hủy sẽ không thể khôi phục.',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Bỏ qua', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                context.read<TicketProvider>().removeTicket(ticketId);
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đã hủy vé thành công!'),
                    backgroundColor: Colors.redAccent,
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