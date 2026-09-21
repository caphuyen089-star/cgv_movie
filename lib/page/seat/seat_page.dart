import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cgv_movie/provider/booking_provider.dart'; 
import 'package:intl/intl.dart';

class SeatPage extends StatefulWidget {
  const SeatPage({super.key});

  @override
  State<SeatPage> createState() => _SeatPageState();
}

class _SeatPageState extends State<SeatPage> {
  // Sơ đồ phòng chiếu: 6 hàng x 8 cột
  final List<List<int>> _seatMatrix = [
    [0, 0, 1, 0, 0, 1, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0],
    [1, 0, 0, 1, 0, 0, 1, 0],
    [0, 0, 0, 0, 0, 0, 0, 0],
    [0, 1, 0, 0, 0, 1, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0],
  ];

  final int _ticketPrice = 120000; // Giá vé 120k / ghế
  List<String> _selectedSeats = [];
  
  // Thêm biến quản lý số lượng vé muốn đặt (mặc định ban đầu là 0)
  int _ticketCount = 0;

  @override
  void initState() {
    super.initState();
    // Kích hoạt bộ đếm ngược 15 phút ngay khi người dùng vào trang chọn ghế
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BookingProvider>(context, listen: false).startSeatTimer();
    });
  }

  // Hộp thoại thông báo khi hết thời gian 15 phút
  void _showTimeoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('Hết thời gian giữ ghế!', style: TextStyle(color: Colors.white)),
        content: const Text('Thời gian 15 phút chọn ghế của bạn đã hết. Vui lòng tiến hành đặt lại vé.', style: TextStyle(color: Colors.grey)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Đẩy người dùng về màn hình chính
              Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
            },
            child: const Text('ĐỒNG Ý', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  void _onSeatTap(int rowIndex, int colIndex) {
    // 1. Yêu cầu chọn số lượng vé trước khi chọn ghế
    if (_ticketCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn số lượng vé trước khi chọn vị trí ghế!'),
          backgroundColor: Colors.amber,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (_seatMatrix[rowIndex][colIndex] == 1) return; // Ghế đã bán thì không bấm được

    String seatName = '${String.fromCharCode(65 + rowIndex)}${colIndex + 1}'; // Vd: A1, B2

    setState(() {
      if (_selectedSeats.contains(seatName)) {
        // Hủy chọn ghế
        _selectedSeats.remove(seatName);
        _seatMatrix[rowIndex][colIndex] = 0;
      } else {
        // 2. Kiểm tra nếu đã chọn đủ số lượng ghế tương ứng với số vé
        if (_selectedSeats.length >= _ticketCount) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Bạn chỉ được chọn tối đa $_ticketCount ghế tương ứng với số vé đã đăng ký!'),
              backgroundColor: Colors.redAccent,
              duration: const Duration(seconds: 2),
            ),
          );
          return;
        }
        // Đồng ý chọn ghế mới
        _selectedSeats.add(seatName);
        _seatMatrix[rowIndex][colIndex] = 2;
      }
    });
  }

  // Hàm xử lý thay đổi số lượng vé
  void _updateTicketCount(int count) {
    setState(() {
      _ticketCount = count;
      // Nếu số lượng vé mới nhỏ hơn số ghế đã chọn, thực hiện reset/xóa bớt các ghế đã chọn để tránh lỗi logic
      if (_selectedSeats.length > _ticketCount) {
        _selectedSeats.clear();
        // Reset toàn bộ các ghế đang chọn (trạng thái = 2) về trống (trạng thái = 0)
        for (int i = 0; i < _seatMatrix.length; i++) {
          for (int j = 0; j < _seatMatrix[i].length; j++) {
            if (_seatMatrix[i][j] == 2) {
              _seatMatrix[i][j] = 0;
            }
          }
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Số lượng vé thay đổi. Vui lòng chọn lại vị trí ghế!'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Lắng nghe BookingProvider để cập nhật thời gian liên tục
    final bookingProvider = context.watch<BookingProvider>();

    // Nếu phát hiện biến isTimeout bên provider chuyển sang true, bật hộp thoại báo hết giờ
    if (bookingProvider.isTimeout) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showTimeoutDialog());
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Chọn Ghế', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Widget thanh hiển thị đồng hồ đếm ngược 15 phút
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            color: Colors.red.withOpacity(0.15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.timer, color: Colors.redAccent, size: 18),
                const SizedBox(width: 6),
                Text(
                  'Thời gian giữ ghế còn lại: ${bookingProvider.timerString}',
                  style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 15),
          
          // ================= BỘ CHỌN SỐ LƯỢNG VÉ =================
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.withOpacity(0.5)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Số lượng vé:',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline, color: Colors.white),
                      onPressed: _ticketCount > 0 ? () => _updateTicketCount(_ticketCount - 1) : null,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '$_ticketCount',
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                      onPressed: () => _updateTicketCount(_ticketCount + 1),
                    ),
                  ],
                )
              ],
            ),
          ),
          
          const SizedBox(height: 15),
          // Màn hình giả lập
          Center(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 30),
              padding: const EdgeInsets.symmetric(vertical: 4),
              decoration: const BoxDecoration(
                color: Colors.grey,
                boxShadow: [BoxShadow(color: Colors.white24, blurRadius: 10, spreadRadius: 2)],
              ),
              child: const Text('MÀN HÌNH', textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 30),

          // Sơ đồ ghế ngồi
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8, // 8 cột giống Ma trận
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: _seatMatrix.length * _seatMatrix[0].length,
              itemBuilder: (context, index) {
                int rowIndex = index ~/ _seatMatrix[0].length;
                int colIndex = index % _seatMatrix[0].length;
                int seatState = _seatMatrix[rowIndex][colIndex];

                Color seatColor = Colors.grey[800]!; // Ghế trống
                if (seatState == 1) seatColor = Colors.red[900]!; // Ghế đã khóa
                if (seatState == 2) seatColor = Colors.red; // Ghế đang chọn

                String seatName = '${String.fromCharCode(65 + rowIndex)}${colIndex + 1}';

                return GestureDetector(
                  onTap: () => _onSeatTap(rowIndex, colIndex),
                  child: Container(
                    decoration: BoxDecoration(
                      color: seatColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text(
                        seatName,
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Thanh hiển thị tổng tiền và nút Tiếp Tục
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
                    Text(
                      _selectedSeats.isEmpty ? 'Chưa chọn ghế' : 'Ghế: ${_selectedSeats.join(", ")}',
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Tổng tiền: ${NumberFormat('#,###', 'vi_VN').format(_selectedSeats.length * _ticketPrice)} đ',
                      style: const TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, 
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15)
                  ),
                  onPressed: (_selectedSeats.isEmpty || _selectedSeats.length != _ticketCount)
                      ? null
                      : () {
                          // Cập nhật danh sách ghế lên BookingProvider trước khi sang trang Pay
                          bookingProvider.updateSeats(_selectedSeats);
                          Navigator.pushNamed(context, '/payment');
                        },
                  child: const Text('TIẾP TỤC', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}