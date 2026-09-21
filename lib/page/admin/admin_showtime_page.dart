import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/movie.dart';
import '../../model/showtime.dart';
import '../../provider/movie_provider.dart';
import '../../provider/showtime_provider.dart';

class AdminShowtimePage extends StatefulWidget {
  const AdminShowtimePage({super.key});

  @override
  State<AdminShowtimePage> createState() => _AdminShowtimePageState();
}

class _AdminShowtimePageState extends State<AdminShowtimePage> {
  final _scrollController = ScrollController();

  Movie? _selectedMovie;
  String _selectedCinema = 'CGV Vincom Center'; // 🟢 Rạp mặc định
  String _selectedRoom = 'Phòng 01';
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = const TimeOfDay(hour: 19, minute: 0);

  int? _editingShowtimeId;

  // Danh sách các rạp phim tùy chỉnh
  final List<String> _cinemas = [
    'CGV Vincom Center',
    'CGV Landmark 81',
    'CGV Sư Vạn Hạnh',
    'CGV Aeon Mall Tan Phu',
  ];

  final List<String> _rooms = ['Phòng 01', 'Phòng 02', 'Phòng 03', 'Phòng IMAX'];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _clearForm() {
    setState(() {
      _editingShowtimeId = null;
      _selectedMovie = null;
      _selectedCinema = 'CGV Vincom Center';
      _selectedRoom = 'Phòng 01';
      _selectedDate = DateTime.now();
      _selectedTime = const TimeOfDay(hour: 19, minute: 0);
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  void _editShowtime(Showtime st, List<Movie> movies) {
    setState(() {
      _editingShowtimeId = st.id;
      try {
        _selectedMovie = movies.firstWhere((m) => m.id.toString() == st.movieId.toString());
      } catch (_) {
        _selectedMovie = null;
      }
      _selectedCinema = st.cinemaName;
      _selectedRoom = st.roomName;

      try {
        final parts = st.date.split('-');
        if (parts.length == 3) {
          _selectedDate = DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
        }
      } catch (_) {}

      try {
        final timeParts = st.time.split(':');
        if (timeParts.length == 2) {
          _selectedTime = TimeOfDay(hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
        }
      } catch (_) {}
    });

    if (_scrollController.hasClients) {
      _scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  void _submitShowtime() {
    if (_selectedMovie == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn phim!'), backgroundColor: Colors.orange),
      );
      return;
    }

    final dateStr = "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}";
    final timeStr = "${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}";

    final showtimeProvider = Provider.of<ShowtimeProvider>(context, listen: false);

    if (_editingShowtimeId == null) {
      final newShowtime = Showtime(
        id: DateTime.now().millisecondsSinceEpoch,
        movieId: _selectedMovie!.id.toString(),
        movieTitle: _selectedMovie!.title,
        cinemaName: _selectedCinema,
        roomName: _selectedRoom,
        date: dateStr,
        time: timeStr,
      );

      final isSuccess = showtimeProvider.addShowtime(newShowtime);
      if (isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Thêm lịch chiếu thành công!'), backgroundColor: Colors.green),
        );
        _clearForm();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lịch chiếu đã tồn tại tại Rạp và Phòng này!'), backgroundColor: Colors.red),
        );
      }
    } else {
      final updatedShowtime = Showtime(
        id: _editingShowtimeId!,
        movieId: _selectedMovie!.id.toString(),
        movieTitle: _selectedMovie!.title,
        cinemaName: _selectedCinema,
        roomName: _selectedRoom,
        date: dateStr,
        time: timeStr,
      );

      final isSuccess = showtimeProvider.updateShowtime(updatedShowtime);
      if (isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cập nhật lịch chiếu thành công!'), backgroundColor: Colors.blue),
        );
        _clearForm();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Trùng lịch chiếu với suất khác tại Rạp và Phòng này!'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _confirmDelete(BuildContext context, Showtime st) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Xóa suất chiếu phim "${st.movieTitle}" tại ${st.cinemaName}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Provider.of<ShowtimeProvider>(context, listen: false).deleteShowtime(st.id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã xóa lịch chiếu!'), backgroundColor: Colors.red),
              );
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final movies = context.watch<MovieProvider>().movies;
    final showtimes = context.watch<ShowtimeProvider>().showtimes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản Lý Lịch Chiếu (Admin)'),
        backgroundColor: const Color(0xFFD3432B),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _editingShowtimeId == null ? 'Thêm Lịch Chiếu Mới' : 'Sửa Lịch Chiếu',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFD3432B)),
                ),
                if (_editingShowtimeId != null)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[300]),
                    onPressed: _clearForm,
                    icon: const Icon(Icons.cancel, color: Colors.black87, size: 18),
                    label: const Text('Hủy sửa', style: TextStyle(color: Colors.black87)),
                  ),
              ],
            ),
            const SizedBox(height: 15),

            // 1. Chọn Phim
            DropdownButtonFormField<Movie>(
              value: _selectedMovie,
              hint: const Text('Chọn Phim'),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Phim *',
                prefixIcon: Icon(Icons.movie),
              ),
              items: movies.map((movie) {
                return DropdownMenuItem(value: movie, child: Text(movie.title));
              }).toList(),
              onChanged: (val) => setState(() => _selectedMovie = val),
            ),
            const SizedBox(height: 12),

            // 2. 🟢 Chọn Rạp Chiếu
            DropdownButtonFormField<String>(
              value: _selectedCinema,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Rạp chiếu *',
                prefixIcon: Icon(Icons.location_city),
              ),
              items: _cinemas.map((cinema) {
                return DropdownMenuItem(value: cinema, child: Text(cinema));
              }).toList(),
              onChanged: (val) => setState(() => _selectedCinema = val!),
            ),
            const SizedBox(height: 12),

            // 3. Chọn Phòng Chiếu
            DropdownButtonFormField<String>(
              value: _selectedRoom,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Phòng chiếu *',
                prefixIcon: Icon(Icons.meeting_room),
              ),
              items: _rooms.map((room) {
                return DropdownMenuItem(value: room, child: Text(room));
              }).toList(),
              onChanged: (val) => setState(() => _selectedRoom = val!),
            ),
            const SizedBox(height: 12),

            // 4. Chọn Ngày & Giờ
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                    icon: const Icon(Icons.calendar_today, color: Color(0xFFD3432B)),
                    label: Text(
                      "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                      style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
                    ),
                    onPressed: _pickDate,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                    icon: const Icon(Icons.access_time, color: Color(0xFFD3432B)),
                    label: Text(
                      "${_selectedTime.hour}:${_selectedTime.minute.toString().padLeft(2, '0')}",
                      style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
                    ),
                    onPressed: _pickTime,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // Nút Thêm / Lưu
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _editingShowtimeId == null ? const Color(0xFFD3432B) : Colors.blue,
                ),
                onPressed: _submitShowtime,
                icon: Icon(
                  _editingShowtimeId == null ? Icons.add_circle : Icons.save,
                  color: Colors.white,
                ),
                label: Text(
                  _editingShowtimeId == null ? 'THÊM LỊCH CHIẾU' : 'LƯU CẬP NHẬT',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 25),
            const Divider(thickness: 2),
            const SizedBox(height: 10),

            Text('Danh Sách Lịch Chiếu (${showtimes.length})', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: showtimes.length,
              itemBuilder: (context, index) {
                final st = showtimes[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    title: Text(st.movieTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        '📍 ${st.cinemaName}\n🏢 ${st.roomName}  •  📅 ${st.date}  •  ⏰ ${st.time}',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: 'Sửa',
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editShowtime(st, movies),
                        ),
                        IconButton(
                          tooltip: 'Xóa',
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmDelete(context, st),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}