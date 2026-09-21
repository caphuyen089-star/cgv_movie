import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/movie.dart';
import '../../provider/movie_provider.dart';

class AdminMoviePage extends StatefulWidget {
  const AdminMoviePage({super.key});

  @override
  State<AdminMoviePage> createState() => _AdminMoviePageState();
}

class _AdminMoviePageState extends State<AdminMoviePage> {
  final _scrollController = ScrollController();

  final _titleController = TextEditingController();
  final _imageController = TextEditingController(); // Dùng 1 Poster duy nhất
  final _trailerController = TextEditingController();
  final _genreController = TextEditingController();
  final _durationController = TextEditingController();
  final _ratingController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime? _selectedReleaseDate; // Lưu trữ ngày khởi chiếu được chọn
  int? _editingMovieId; // Lưu ID phim đang sửa (null nếu đang thêm mới)

  // Quy định thời lượng tối đa cho một bộ phim (ví dụ: 240 phút = 4 tiếng)
  static const int MAX_DURATION = 240;

  @override
  void dispose() {
    _scrollController.dispose();
    _titleController.dispose();
    _imageController.dispose();
    _trailerController.dispose();
    _genreController.dispose();
    _durationController.dispose();
    _ratingController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Reset form nhập liệu
  void _clearForm() {
    setState(() {
      _editingMovieId = null;
      _selectedReleaseDate = null;
    });
    _titleController.clear();
    _imageController.clear();
    _trailerController.clear();
    _genreController.clear();
    _durationController.clear();
    _ratingController.clear();
    _descriptionController.clear();
  }

  // Chọn ngày khởi chiếu (chỉ cho phép chọn từ ngày hiện tại trở về sau)
  Future<void> _pickReleaseDate() async {
    final now = DateTime.now();
    // Loại bỏ giờ phút giây để so sánh theo ngày
    final today = DateTime(now.year, now.month, now.day);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedReleaseDate != null && !_selectedReleaseDate!.isBefore(today)
          ? _selectedReleaseDate!
          : today,
      firstDate: today, // Khóa không cho chọn những ngày trước thời điểm hiện tại
      lastDate: DateTime(now.year + 5),
    );

    if (picked != null) {
      setState(() {
        _selectedReleaseDate = picked;
      });
    }
  }

  // Đưa dữ liệu phim cần sửa lên Form
  void _editMovie(Movie movie) {
    setState(() {
      _editingMovieId = movie.id;
      _titleController.text = movie.title;
      _imageController.text = movie.image;
      _trailerController.text = movie.trailer;
      _genreController.text = movie.genre;
      _durationController.text = movie.duration.toString();
      _ratingController.text = movie.rating.toString();
      _descriptionController.text = movie.description;

      // Chuyển chuỗi YYYY-MM-DD hoặc dd/MM/yyyy thành DateTime nếu có thể
      try {
        if (movie.releaseDate.contains('/')) {
          final parts = movie.releaseDate.split('/');
          if (parts.length == 3) {
            _selectedReleaseDate = DateTime(
              int.parse(parts[2]),
              int.parse(parts[1]),
              int.parse(parts[0]),
            );
          }
        } else if (movie.releaseDate.contains('-')) {
          _selectedReleaseDate = DateTime.tryParse(movie.releaseDate);
        } else {
          _selectedReleaseDate = null;
        }
      } catch (_) {
        _selectedReleaseDate = null;
      }
    });

    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  // Xử lý Thêm / Cập nhật phim với các ràng buộc
  void _submitMovie() {
    final title = _titleController.text.trim();
    final image = _imageController.text.trim();
    final genre = _genreController.text.trim();
    final durationText = _durationController.text.trim();
    final ratingText = _ratingController.text.trim();
    final description = _descriptionController.text.trim();
    final trailer = _trailerController.text.trim();

    if (title.isEmpty || image.isEmpty || genre.isEmpty || durationText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập Tên, Poster, Thể loại và Thời lượng!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final duration = int.tryParse(durationText);
    if (duration == null || duration <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Thời lượng phim phải là số nguyên dương hợp lệ!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // 🔴 RÀNG BUỘC THỜI LƯỢNG TỐI ĐA
    if (duration > MAX_DURATION) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Thời lượng phim không được vượt quá $MAX_DURATION phút!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // 🔴 RÀNG BUỘC NGÀY KHỞI CHIẾU
    if (_selectedReleaseDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn Ngày khởi chiếu từ hôm nay trở về sau!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final formattedDate =
        '${_selectedReleaseDate!.day.toString().padLeft(2, '0')}/${_selectedReleaseDate!.month.toString().padLeft(2, '0')}/${_selectedReleaseDate!.year}';

    final rating = double.tryParse(ratingText) ?? 5.0;
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);

    if (_editingMovieId == null) {
      // 🟢 THÊM PHIM MỚI
      final newMovie = Movie(
        id: DateTime.now().millisecondsSinceEpoch,
        title: title,
        image: image,
        banner: image,
        trailer: trailer,
        description: description.isEmpty ? 'Chưa có mô tả.' : description,
        genre: genre,
        duration: duration,
        rating: rating,
        releaseDate: formattedDate,
      );
      movieProvider.addMovie(newMovie);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thêm phim mới thành công!'), backgroundColor: Colors.green),
      );
    } else {
      // 🟢 CẬP NHẬT PHIM
      final updatedMovie = Movie(
        id: _editingMovieId!,
        title: title,
        image: image,
        banner: image,
        trailer: trailer,
        description: description,
        genre: genre,
        duration: duration,
        rating: rating,
        releaseDate: formattedDate,
      );
      movieProvider.updateMovie(updatedMovie);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật phim thành công!'), backgroundColor: Colors.blue),
      );
    }

    _clearForm();
  }

  // 🔴 XÁC NHẬN VÀ RÀNG BUỘC KHI XÓA PHIM
  void _confirmDelete(BuildContext context, Movie movie) {
    // 1. RÀNG BUỘC: Kiểm tra nếu phim đang có suất chiếu hoặc vé đặt thì không cho xóa
    // Bạn có thể kết nối với ShowtimeProvider/BookingProvider để thay thế 'false' bên dưới
    bool hasBookingOrShowtime = false; 

    if (hasBookingOrShowtime) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Không thể xóa "${movie.title}" vì đang có suất chiếu/vé đã đặt!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // 2. HỘP THOẠI XÁC NHẬN XÓA
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận xóa phim'),
        content: Text(
          'Bạn có chắc chắn muốn xóa phim "${movie.title}" không?\n\nPhim này sẽ tự động biến mất khỏi giao diện Đặt vé.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              // Gọi hàm deleteMovie từ Provider -> Tự động phát thông báo làm mới giao diện Đặt vé
              Provider.of<MovieProvider>(context, listen: false).deleteMovie(movie.id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Đã xóa phim "${movie.title}" khỏi hệ thống!'),
                  backgroundColor: Colors.red,
                ),
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản Lý Phim (Admin)'),
        backgroundColor: const Color(0xFFD3432B),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Form
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _editingMovieId == null ? 'Thêm Phim Mới' : 'Sửa Thông Tin Phim',
                  style: const TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold, 
                    color: Color(0xFFD3432B),
                  ),
                ),
                if (_editingMovieId != null)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[300]),
                    onPressed: _clearForm,
                    icon: const Icon(Icons.cancel, color: Colors.black87, size: 18),
                    label: const Text('Hủy sửa', style: TextStyle(color: Colors.black87)),
                  ),
              ],
            ),
            const SizedBox(height: 10),

            // Form Nhập Liệu
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Tên phim *', 
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.movie),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _imageController,
              decoration: const InputDecoration(
                labelText: 'Poster Phim (Link URL / Tên file ảnh) *', 
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.image),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _genreController,
                    decoration: const InputDecoration(
                      labelText: 'Thể loại *', 
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _durationController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Thời lượng (phút) *',
                      helperText: 'Tối đa $MAX_DURATION phút',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _ratingController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Đánh giá (1 - 10)', 
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Chọn Ngày khởi chiếu
                Expanded(
                  child: InkWell(
                    onTap: _pickReleaseDate,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Ngày khởi chiếu *',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      child: Text(
                        _selectedReleaseDate == null
                            ? 'Chọn ngày (Từ hôm nay)'
                            : '${_selectedReleaseDate!.day.toString().padLeft(2, '0')}/${_selectedReleaseDate!.month.toString().padLeft(2, '0')}/${_selectedReleaseDate!.year}',
                        style: TextStyle(
                          color: _selectedReleaseDate == null ? Colors.grey[600] : Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _trailerController,
              decoration: const InputDecoration(
                labelText: 'Link Trailer (Youtube URL)', 
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.ondemand_video),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Mô tả phim', 
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            // Nút Thêm / Lưu cập nhật
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _editingMovieId == null ? const Color(0xFFD3432B) : Colors.blue,
                      ),
                      onPressed: _submitMovie,
                      icon: Icon(
                        _editingMovieId == null ? Icons.add_circle : Icons.save,
                        color: Colors.white,
                      ),
                      label: Text(
                        _editingMovieId == null ? 'THÊM PHIM MỚI' : 'LƯU CẬP NHẬT',
                        style: const TextStyle(
                          color: Colors.white, 
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                if (_editingMovieId == null) ...[
                  const SizedBox(width: 10),
                  IconButton(
                    tooltip: 'Xóa trắng form',
                    icon: const Icon(Icons.refresh, color: Colors.grey),
                    onPressed: _clearForm,
                  ),
                ]
              ],
            ),

            const SizedBox(height: 25),
            const Divider(thickness: 2),
            const SizedBox(height: 10),

            // DANH SÁCH PHIM
            Text(
              'Danh Sách Phim (${movies.length})',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: movie.image.startsWith('http')
                          ? Image.network(
                              movie.image,
                              width: 50,
                              height: 70,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(Icons.movie, size: 40),
                            )
                          : Image.asset(
                              'assets/images/${movie.image}',
                              width: 50,
                              height: 70,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(Icons.movie, size: 40),
                            ),
                    ),
                    title: Text(movie.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text('${movie.genre} • ${movie.duration} phút'),
                        Text('📅 Khởi chiếu: ${movie.releaseDate}', style: const TextStyle(fontSize: 12, color: Colors.black87)),
                        Text('Đánh giá: ⭐ ${movie.rating}', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Nút Sửa
                        IconButton(
                          tooltip: 'Sửa phim',
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editMovie(movie),
                        ),
                        // Nút Xóa
                        IconButton(
                          tooltip: 'Xóa phim',
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmDelete(context, movie),
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