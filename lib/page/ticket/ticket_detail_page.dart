import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TicketDetailPage extends StatelessWidget {
  // Thay đổi Map<String, String> thành Map<String, dynamic> để chứa danh sách Bắp Nước
  final Map<String, dynamic> ticket;

  const TicketDetailPage({
    super.key,
    required this.ticket,
  });

  @override
  Widget build(BuildContext context) {
    // Lấy thông tin bắp nước (Hỗ trợ nhiều dạng key khác nhau như snacks, food, combos)
    final List<dynamic> snacks = ticket['snacks'] ?? ticket['food'] ?? ticket['combos'] ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Nền tối Cinema
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text("Chi tiết vé điện tử", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // CARD VÉ CHUYÊN NGHIỆP
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.15),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  // 1. HEADER MÃ VÉ
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    decoration: const BoxDecoration(
                      color: Color(0xFF2C2C2C),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "MÃ VÉ: #${ticket['ticketCode'] ?? ticket['id'] ?? '219575'}",
                          style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.green),
                          ),
                          child: const Text(
                            "Đã thanh toán",
                            style: TextStyle(color: Colors.greenAccent, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 2. THÔNG TIN PHIM & RẠP
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tên Phim
                        Text(
                          ticket["movie"] ?? ticket["movieTitle"] ?? "Tên phim",
                          style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 15),

                        _buildInfoRow(Icons.location_on, "Rạp chiếu:", ticket["cinema"] ?? ticket["cinemaName"] ?? ""),
                        const SizedBox(height: 10),
                        _buildInfoRow(Icons.calendar_today, "Ngày:", ticket["date"] ?? "Hôm nay"),
                        const SizedBox(height: 10),
                        _buildInfoRow(Icons.access_time_filled, "Suất chiếu:", ticket["time"] ?? ticket["showtime"] ?? ""),
                        const SizedBox(height: 10),
                        _buildInfoRow(Icons.event_seat, "Ghế chọn:", ticket["seat"] ?? ticket["seats"] ?? "", isHighlight: true),

                        const SizedBox(height: 15),
                        const Divider(color: Colors.white24, height: 1),
                        const SizedBox(height: 15),

                        // 🍿 3. MỤC BẮP NƯỚC ĐÃ ĐẶT
                        Row(
                          children: const [
                            Icon(Icons.fastfood, color: Colors.amber, size: 20),
                            SizedBox(width: 8),
                            Text("Bắp & Nước uống:", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 15)),
                          ],
                        ),
                        const SizedBox(height: 10),

                        if (snacks.isNotEmpty)
                          ...snacks.map((item) {
                            // Xử lý dữ liệu linh hoạt (chuỗi hoặc Map)
                            final String name = item is Map ? (item['name'] ?? item['title'] ?? '') : item.toString();
                            final String qty = item is Map ? "x${item['quantity'] ?? 1}" : "";

                            return Padding(
                              padding: const EdgeInsets.only(left: 28, bottom: 6),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text("• $name", style: const TextStyle(color: Colors.white70, fontSize: 14)),
                                  ),
                                  if (qty.isNotEmpty)
                                    Text(qty, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            );
                          })
                        else
                          const Padding(
                            padding: EdgeInsets.only(left: 28),
                            child: Text("Không kèm bắp nước", style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic, fontSize: 13)),
                          ),
                      ],
                    ),
                  ),

                  // 4. ĐƯỜNG NÉT ĐỨT KHUYẾT VÉ (Ticket Cut-out)
                  Row(
                    children: [
                      Container(
                        height: 20,
                        width: 10,
                        decoration: const BoxDecoration(
                          color: Color(0xFF121212),
                          borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                        ),
                      ),
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return Flex(
                              direction: Axis.horizontal,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(
                                (constraints.constrainWidth() / 10).floor(),
                                (_) => const SizedBox(width: 5, height: 1, child: DecoratedBox(decoration: BoxDecoration(color: Colors.grey))),
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        height: 20,
                        width: 10,
                        decoration: const BoxDecoration(
                          color: Color(0xFF121212),
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                        ),
                      ),
                    ],
                  ),

                  // 5. MÃ QR CODE & TỔNG TIỀN
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 5,
                                spreadRadius: 2,
                              )
                            ],
                          ),
                          child: QrImageView(
                            data: "Phim: ${ticket["movie"] ?? ticket["movieTitle"]} | Ghế: ${ticket["seat"] ?? ticket["seats"]}",
                            version: QrVersions.auto,
                            size: 160.0,
                            gapless: false,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Vui lòng xuất trình mã QR này khi vào rạp.",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Tổng thanh toán:", style: TextStyle(color: Colors.white70, fontSize: 16)),
                            Text(
                              "${ticket["price"] ?? ticket["totalAmount"] ?? "0"} đ",
                              style: const TextStyle(color: Colors.redAccent, fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // NÚT HỦY VÉ
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  // Xử lý hủy vé
                },
                icon: const Icon(Icons.cancel_outlined),
                label: const Text("HỦY VÉ NÀY", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget hỗ trợ vẽ từng dòng thông tin
  Widget _buildInfoRow(IconData icon, String label, String value, {bool isHighlight = false}) {
    return Row(
      children: [
        Icon(icon, color: isHighlight ? Colors.redAccent : Colors.grey, size: 18),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: Colors.grey)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: isHighlight ? Colors.redAccent : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}