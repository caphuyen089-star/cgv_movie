import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/movie.dart';
import '../../provider/booking_provider.dart';
import '../../data/cinema_data.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  int _selectedDateIndex = 0; // Lưu ngày đang chọn
  
  // Biến để lưu suất chiếu và rạp được chọn khi click
  String? _selectedTime; 
  String? _selectedTheaterName;

  final List<Map<String, String>> _dates = [
    {'day': 'Hôm nay', 'date': '29/06'},
    {'day': 'Thứ 3', 'date': '30/06'},
    {'day': 'Thứ 4', 'date': '01/07'},
    {'day': 'Thứ 5', 'date': '02/07'},
    {'day': 'Thứ 6', 'date': '03/07'},
    {'day': 'Thứ 7', 'date': '04/07'},
    {'day': 'Chủ nhật', 'date': '05/07'},
  ];

  late final List<Map<String, dynamic>> _theaters = cinemaList.map((cinema) {
    List<String> slots = ['10:00', '13:15', '16:00', '19:00', '22:15'];
    
    if (cinema.name.contains('Bình Tân')) {
      slots = ['09:30', '12:45', '15:15', '18:00', '21:30'];
    } else if (cinema.name.contains('Crescent')) {
      slots = ['11:15', '14:30', '17:45', '20:30', '23:00'];
    }

    return {
      'id': cinema.id,
      'name': cinema.name,
      'address': cinema.address, 
      'image': cinema.image,
      'slots': slots,
    };
  }).toList();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    
    Movie movie;
    String? targetTheater;

    if (args is Movie) {
      movie = args;
    } else if (args is Map<String, dynamic>) {
      movie = args['movie'] as Movie;
      targetTheater = args['selectedTheater'] as String?;
    } else {
      return const Scaffold(body: Center(child: Text("Dữ liệu không hợp lệ")));
    }

    List<Map<String, dynamic>> sortedTheaters = List.from(_theaters);
    if (targetTheater != null) {
      int targetIndex = sortedTheaters.indexWhere((t) => t['name'] == targetTheater);
      if (targetIndex != -1) {
        final selectedCinema = sortedTheaters.removeAt(targetIndex);
        sortedTheaters.insert(0, selectedCinema);
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(movie.title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Phần hiển thị danh sách Ngày cuộn ngang
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _dates.length,
              itemBuilder: (context, index) {
                bool isSelected = _selectedDateIndex == index;
                return GestureDetector(
                  onTap: () => setState(() => _selectedDateIndex = index),
                  child: Container(
                    width: 70,
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.red : Colors.grey[900],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_dates[index]['day']!, style: TextStyle(color: isSelected ? Colors.white : Colors.grey, fontSize: 12)),
                        const SizedBox(height: 4),
                        Text(_dates[index]['date']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(color: Colors.grey),
          
          // Danh sách rạp, Ảnh, Địa chỉ và Giờ chiếu
          Expanded(
            child: ListView.builder(
              itemCount: sortedTheaters.length,
              itemBuilder: (context, index) {
                final theater = sortedTheaters[index];
                bool isHighlighted = theater['name'] == targetTheater;

                return Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(8),
                    border: isHighlighted ? Border.all(color: Colors.red, width: 1.5) : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.asset(
                              theater['image'],
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 70,
                                  height: 70,
                                  color: Colors.grey[800],
                                  child: const Icon(Icons.image_not_supported, color: Colors.grey),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        theater['name'],
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)
                                      ),
                                    ),
                                    if (isHighlighted)
                                      const Icon(Icons.check_circle, color: Colors.red, size: 18),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  theater['address'],
                                  style: TextStyle(color: Colors.grey[400], fontSize: 12, fontStyle: FontStyle.italic),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Nút giờ chiếu suất chiếu
                      Wrap(
                        spacing: 12,
                        runSpacing: 10,
                        children: (theater['slots'] as List<String>).map((time) {
                          // Kiểm tra xem nút này có trùng với rạp và giờ đang chọn không
                          bool isTimeSelected = _selectedTime == time && _selectedTheaterName == theater['name'];

                          return GestureDetector(
                            onTap: () {
                              // Click vào thì chỉ lưu thông tin lại để highlight chứ chưa chuyển trang liền
                              setState(() {
                                _selectedTime = time;
                                _selectedTheaterName = theater['name'];
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                // Chọn thì đổi nền đỏ, không thì để nền xám thường
                                color: isTimeSelected ? Colors.red : Colors.grey[850], 
                                border: Border.all(
                                  color: isTimeSelected 
                                      ? Colors.white 
                                      : (isHighlighted ? Colors.red[300]! : Colors.grey[700]!),
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                time, 
                                style: TextStyle(
                                  color: Colors.white, 
                                  fontWeight: FontWeight.bold,
                                  fontSize: isTimeSelected ? 15 : 14,
                                )
                              ),
                            ),
                          );
                        }).toList(),
                      )
                    ],
                  ),
                );
              },
            ),
          ),

          // Thanh hiển thị trạng thái và nút TIẾP TỤC ở dưới cùng
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[900],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _selectedTime == null 
                            ? 'Vui lòng chọn suất chiếu' 
                            : 'Đã chọn: $_selectedTime',
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      if (_selectedTheaterName != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Rạp: $_selectedTheaterName',
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ]
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    disabledBackgroundColor: Colors.grey[800],
                    padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                  ),
                  // Chưa chọn suất chiếu thì nút không bấm được
                  onPressed: _selectedTime == null
                      ? null
                      : () {
                          final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
                          
                          // Dừng đếm giờ và dọn dẹp dữ liệu đặt cũ trước khi chuyển trang
                          bookingProvider.stopSeatTimer();
                          bookingProvider.clearBooking();
                          bookingProvider.setMovie(movie);
                          
                          Navigator.pushNamed(context, '/seat');
                        },
                  child: Text(
                    'TIẾP TỤC',
                    style: TextStyle(
                      color: _selectedTime == null ? Colors.grey : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}