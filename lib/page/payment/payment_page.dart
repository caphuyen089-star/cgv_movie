import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../model/ticket.dart';
import '../../provider/booking_provider.dart'; 
import '../../provider/ticket_provider.dart';
import '../../data/food_data.dart'; 
import '../ticket/ticket_history_page.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _selectedMethod = 'momo';
  final NumberFormat _currencyFormat = NumberFormat('#,###', 'vi_VN');

  // 🎟️ Controller cho ô nhập voucher
  final TextEditingController _voucherController = TextEditingController();

  @override
  void dispose() {
    _voucherController.dispose();
    super.dispose();
  }

  String _getImagePath(String path) {
    if (path.startsWith('assets/')) return path;
    return 'assets/images/$path';
  }

  // 🛠️ HÀM HIỂN THỊ POPUP MÃ QR THANH TOÁN
  void _showQrCodeDialog(String method, double totalAmount) {
    bool isMomo = method == 'momo';
    String title = isMomo ? 'Thanh toán qua Ví MoMo' : 'Thanh toán chuyển khoản ATM';
    String note = isMomo
        ? 'Dùng App MoMo hoặc Trình quét QR để quét mã'
        : 'Dùng App Ngân hàng bất kỳ để quét mã VietQR';

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: const Color(0xFF1E1E24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: isMomo ? const Color(0xFFA50064) : Colors.blueAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        isMomo ? Icons.account_balance_wallet : Icons.credit_card,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.network(
                    'https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=CGV_PAYMENT_${totalAmount.toInt()}',
                    width: 180,
                    height: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 180,
                      height: 180,
                      color: Colors.grey[300],
                      child: const Icon(Icons.qr_code, size: 80, color: Colors.black54),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                const Text(
                  'SỐ TIỀN THANH TOÁN',
                  style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_currencyFormat.format(totalAmount)} đ',
                  style: const TextStyle(
                    color: Colors.amber,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  note,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text(
                      'ĐÃ XÁC NHẬN / ĐÓNG',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookingProvider = context.watch<BookingProvider>();
    final movie = bookingProvider.selectedMovie;
    final selectedSeats = bookingProvider.selectedSeats;

    final selectedFoods = foodList
        .where((f) => bookingProvider.getFoodQuantity(f.id) > 0)
        .toList();

    final bool hasVoucher = bookingProvider.appliedVoucherCode != null;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Thanh Toán', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: movie == null
          ? const Center(child: Text('Không tìm thấy thông tin đặt vé', style: TextStyle(color: Colors.white)))
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. Thông tin phim & ghế chọn
                        Container(
                          padding: const EdgeInsets.all(16),
                          width: double.infinity,
                          decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${movie.title} (2D Phụ Đề)',
                                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              const Text('Rạp: CGV Vincom Đồng Khởi - Phòng chiếu 03', style: TextStyle(color: Colors.grey, fontSize: 14)),
                              const Text('Suất chiếu: 19:00 - Hôm nay', style: TextStyle(color: Colors.grey, fontSize: 14)),
                              const SizedBox(height: 8),
                              Text(
                                'Ghế đã chọn: ${selectedSeats.isEmpty ? "Chưa chọn ghế" : selectedSeats.join(", ")}',
                                style: const TextStyle(color: Colors.redAccent, fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),

                        // 2. Mua thêm bắp nước
                        const Text('MUA THÊM BẮP NƯỚC', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(), 
                          itemCount: foodList.length,
                          itemBuilder: (context, index) {
                            final food = foodList[index];
                            final quantity = bookingProvider.getFoodQuantity(food.id);

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.grey[800],
                                      image: DecorationImage(
                                        image: AssetImage(_getImagePath(food.image)),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),              
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(food.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                                        const SizedBox(height: 6),
                                        Text('${_currencyFormat.format(food.price)} đ', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove_circle_outline, color: Colors.grey),
                                        onPressed: quantity > 0 
                                            ? () => bookingProvider.decrementFood(food.id) 
                                            : null,
                                      ),
                                      Text(
                                        '$quantity',
                                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add_circle_outline, color: Colors.red),
                                        onPressed: () => bookingProvider.incrementFood(food.id),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 25),

                        // 🎟️ 3. MÃ GIẢM GIÁ / VOUCHER
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'MÃ GIẢM GIÁ / VOUCHER (NẾU CÓ)',
                                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _voucherController,
                                      enabled: !hasVoucher,
                                      style: const TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        hintText: hasVoucher 
                                            ? 'Đã áp dụng: ${bookingProvider.appliedVoucherCode}' 
                                            : 'Nhập mã giảm giá (ví dụ: CGV10)',
                                        hintStyle: TextStyle(
                                          color: hasVoucher ? Colors.greenAccent : Colors.grey,
                                          fontWeight: hasVoucher ? FontWeight.bold : FontWeight.normal,
                                        ),
                                        filled: true,
                                        fillColor: Colors.black45,
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide.none,
                                        ),
                                        prefixIcon: Icon(
                                          Icons.local_offer,
                                          color: hasVoucher ? Colors.greenAccent : Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: hasVoucher ? Colors.redAccent : Colors.amber,
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    onPressed: () {
                                      if (hasVoucher) {
                                        bookingProvider.removeVoucher();
                                        _voucherController.clear();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Đã hủy mã giảm giá')),
                                        );
                                      } else {
                                        String code = _voucherController.text.trim();
                                        if (code.isEmpty) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Vui lòng nhập mã giảm giá!')),
                                          );
                                          return;
                                        }

                                        bool isSuccess = bookingProvider.applyVoucher(code);
                                        if (isSuccess) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Áp dụng mã giảm giá thành công!'),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Mã giảm giá không hợp lệ! Thử dùng: CGV10 hoặc DISCOUNT20K'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    child: Text(
                                      hasVoucher ? 'HỦY' : 'ÁP DỤNG',
                                      style: TextStyle(
                                        color: hasVoucher ? Colors.white : Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),

                        // 4. Phương thức thanh toán
                        const Text('PHƯƠNG THỨC THANH TOÁN', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        
                        _buildMethodTile('momo', 'Ví Điện Tử MoMo', Icons.wallet, bookingProvider.totalPayment.toDouble()),
                        _buildMethodTile('atm', 'Thẻ Nội Địa (ATM Banking)', Icons.credit_card, bookingProvider.totalPayment.toDouble()),
                        
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),

                // 5. Thanh hiển thị tổng tiền & nút Đặt vé
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.grey[900],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (hasVoucher) ...[
                            Text(
                              'Gốc: ${_currencyFormat.format(bookingProvider.subTotal)} đ',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            Text(
                              'Giảm: -${_currencyFormat.format(bookingProvider.discountAmount)} đ',
                              style: const TextStyle(
                                color: Colors.greenAccent,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ] else
                            const Text('TỔNG THANH TOÁN', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          Text(
                            '${_currencyFormat.format(bookingProvider.totalPayment)} đ',
                            style: const TextStyle(color: Colors.amber, fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red, 
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16)
                        ),
                        onPressed: () {
                          final ticketProvider = context.read<TicketProvider>();
                          final totalPayment = bookingProvider.totalPayment;
                          final String seatsDisplay = selectedSeats.isEmpty ? 'Chưa chọn' : selectedSeats.join(', ');

                          // 🍿 Lấy danh sách tên món bắp nước đã chọn
                          final foodNames = selectedFoods.map((f) {
                            final qty = bookingProvider.getFoodQuantity(f.id);
                            return '${f.name} x$qty';
                          }).toList();

                          final newTicket = Ticket(
                            id: DateTime.now().millisecondsSinceEpoch,
                            userId: 1,
                            movieId: movie.id,
                            movieTitle: movie.title,
                            movieImage: movie.image,
                            cinemaId: 1,
                            roomId: 3,
                            seats: List<String>.from(selectedSeats),
                            showTime: '19:00 - Hôm nay',
                            totalPrice: totalPayment.toDouble(),
                            foods: foodNames,
                          );

                          ticketProvider.addTicket(newTicket);

                          // HIỂN THỊ DIALOG VÉ XEM PHIM
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (dialogContext) {
                              return Dialog(
                                backgroundColor: Colors.transparent,
                                insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                                child: Center(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: Colors.redAccent,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.redAccent.withOpacity(0.5),
                                                blurRadius: 20,
                                                spreadRadius: 4,
                                              ),
                                            ],
                                          ),
                                          child: const Icon(Icons.check, color: Colors.white, size: 36),
                                        ),
                                        const SizedBox(height: 12),
                                        const Text(
                                          'ĐẶT VÉ THÀNH CÔNG!',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                        const SizedBox(height: 16),

                                        ClipPath(
                                          clipper: TicketClipper(),
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF1E1E24),
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(20.0),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius: BorderRadius.circular(8),
                                                            child: movie.image.startsWith('http')
                                                                ? Image.network(
                                                                    movie.image,
                                                                    width: 65,
                                                                    height: 90,
                                                                    fit: BoxFit.cover,
                                                                    errorBuilder: (_, __, ___) => _buildPlaceholder(),
                                                                  )
                                                                : Image.asset(
                                                                    _getImagePath(movie.image),
                                                                    width: 65,
                                                                    height: 90,
                                                                    fit: BoxFit.cover,
                                                                    errorBuilder: (_, __, ___) => _buildPlaceholder(),
                                                                  ),
                                                          ),
                                                          const SizedBox(width: 14),
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  movie.title,
                                                                  style: const TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 17,
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                                  maxLines: 2,
                                                                  overflow: TextOverflow.ellipsis,
                                                                ),
                                                                const SizedBox(height: 6),
                                                                Container(
                                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                                  decoration: BoxDecoration(
                                                                    color: Colors.red.withOpacity(0.2),
                                                                    borderRadius: BorderRadius.circular(4),
                                                                    border: Border.all(color: Colors.redAccent.withOpacity(0.5)),
                                                                  ),
                                                                  child: const Text(
                                                                    '2D Phụ đề • C13',
                                                                    style: TextStyle(color: Colors.redAccent, fontSize: 11, fontWeight: FontWeight.bold),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 20),
                                                      const Row(
                                                        children: [
                                                          Icon(Icons.location_on, color: Colors.grey, size: 16),
                                                          SizedBox(width: 6),
                                                          Expanded(
                                                            child: Text(
                                                              'CGV Vincom Đồng Khởi',
                                                              style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 16),
                                                      Container(
                                                        padding: const EdgeInsets.all(12),
                                                        decoration: BoxDecoration(
                                                          color: const Color(0xFF141418),
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                          children: [
                                                            _buildTicketDetail('SUẤT CHIẾU', '19:00', 'Hôm nay'),
                                                            Container(width: 1, height: 30, color: Colors.white10),
                                                            _buildTicketDetail('GHẾ', seatsDisplay, '', isHighlight: true),
                                                            Container(width: 1, height: 30, color: Colors.white10),
                                                            _buildTicketDetail('PHÒNG', 'P.03', ''),
                                                          ],
                                                        ),
                                                      ),

                                                      if (selectedFoods.isNotEmpty) ...[
                                                        const SizedBox(height: 16),
                                                        const Text(
                                                          'BẮP NƯỚC ĐÃ CHỌN:',
                                                          style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold),
                                                        ),
                                                        const SizedBox(height: 6),
                                                        Container(
                                                          padding: const EdgeInsets.all(10),
                                                          decoration: BoxDecoration(
                                                            color: const Color(0xFF141418),
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                          child: Column(
                                                            children: selectedFoods.map((food) {
                                                              final qty = bookingProvider.getFoodQuantity(food.id);
                                                              return Padding(
                                                                padding: const EdgeInsets.symmetric(vertical: 2.0),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      '${food.name} x$qty',
                                                                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                                                                    ),
                                                                    Text(
                                                                      '${_currencyFormat.format(food.price * qty)} đ',
                                                                      style: const TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.bold),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            }).toList(),
                                                          ),
                                                        ),
                                                      ],
                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                  children: List.generate(
                                                    30,
                                                    (index) => Expanded(
                                                      child: Container(
                                                        color: index % 2 == 0 ? Colors.transparent : Colors.grey[700],
                                                        height: 1.5,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(20.0),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: List.generate(36, (index) {
                                                                return Container(
                                                                  width: index % 4 == 0 ? 3 : (index % 2 == 0 ? 1 : 2),
                                                                  height: 40,
                                                                  margin: const EdgeInsets.symmetric(horizontal: 1),
                                                                  color: Colors.black,
                                                                );
                                                              }),
                                                            ),
                                                            const SizedBox(height: 4),
                                                            Text(
                                                              '#${newTicket.id.toString().substring(newTicket.id.toString().length - 8)}',
                                                              style: const TextStyle(
                                                                color: Colors.black,
                                                                fontWeight: FontWeight.bold,
                                                                letterSpacing: 2,
                                                                fontSize: 13,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(height: 16),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          const Text('Tổng thanh toán:', style: TextStyle(color: Colors.grey, fontSize: 13)),
                                                          Text(
                                                            '${_currencyFormat.format(totalPayment)} đ',
                                                            style: const TextStyle(color: Colors.amber, fontSize: 16, fontWeight: FontWeight.bold),
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
                                        const SizedBox(height: 20),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: OutlinedButton(
                                                style: OutlinedButton.styleFrom(
                                                  side: const BorderSide(color: Colors.redAccent),
                                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(dialogContext).pop();
                                                  bookingProvider.clearBooking();
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) => const TicketHistoryPage(),
                                                    ),
                                                  );
                                                },
                                                child: const Text(
                                                  'XEM VÉ ĐÃ ĐẶT',
                                                  style: TextStyle(
                                                    color: Colors.redAccent,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(dialogContext).pop();
                                                  bookingProvider.clearBooking();
                                                  if (mounted) {
                                                    Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
                                                  }
                                                },
                                                child: const Text(
                                                  'TRANG CHỦ',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: const Text('ĐẶT VÉ NGAY', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      )
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 65,
      height: 90,
      color: Colors.grey[800],
      child: const Icon(Icons.movie, color: Colors.white54),
    );
  }

  Widget _buildMethodTile(String value, String title, IconData icon, double totalAmount) {
    return InkWell(
      onTap: () {
        setState(() => _selectedMethod = value);
        _showQrCodeDialog(value, totalAmount);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: _selectedMethod == value ? Colors.red.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: RadioListTile<String>(
          value: value,
          groupValue: _selectedMethod,
          title: Text(title, style: const TextStyle(color: Colors.white)),
          secondary: Icon(icon, color: Colors.red),
          activeColor: Colors.red,
          onChanged: (val) {
            if (val != null) {
              setState(() => _selectedMethod = val);
              _showQrCodeDialog(val, totalAmount);
            }
          },
        ),
      ),
    );
  }
}

Widget _buildTicketDetail(String label, String value, String subValue, {bool isHighlight = false}) {
  return Column(
    children: [
      Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.w600)),
      const SizedBox(height: 4),
      Text(
        value,
        style: TextStyle(
          color: isHighlight ? Colors.amber : Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      if (subValue.isNotEmpty)
        Text(subValue, style: const TextStyle(color: Colors.grey, fontSize: 10)),
    ],
  );
}

class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);

    double cutoutRadius = 12;
    double cutoutY = size.height * 0.62;

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