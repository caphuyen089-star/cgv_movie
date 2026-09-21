import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // 🛠️ ĐÃ THÊM: Import để dùng Provider
import '../../provider/booking_provider.dart'; // 🛠️ ĐÃ THÊM: Gọi file chứa provider của ông
import 'ticket_detail_page.dart';

class MyTicketPage extends StatelessWidget {
  const MyTicketPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 🛠️ ĐÃ SỬA: Lấy dữ liệu vé động thông qua Provider thay vì gán mảng cứng
    final tickets = Provider.of<BookingProvider>(context).bookedTickets;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Vé đã đặt"),
        centerTitle: true,
      ),
      body: tickets.isEmpty
          ? const Center(
              child: Text(
                "Bạn chưa có vé nào được đặt.",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: tickets.length,
              itemBuilder: (context, index) {
                final ticket = tickets[index];

                return Card(
                  margin: const EdgeInsets.all(10),
                  elevation: 5,
                  child: ListTile(
                    leading: const Icon(Icons.movie, color: Colors.red),
                    title: Text(ticket["movie"]!),
                    subtitle: Text(
                        "${ticket["date"]} • ${ticket["time"]}\nGhế: ${ticket["seat"]}"),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TicketDetailPage(ticket: ticket),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}