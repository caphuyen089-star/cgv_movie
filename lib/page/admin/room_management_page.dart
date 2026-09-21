import 'package:flutter/material.dart';
import '../../data/cinema_data.dart'; // Import danh sách rạp để đổ vào Dropdown

class RoomManagementPage extends StatefulWidget {
  const RoomManagementPage({super.key});

  @override
  State<RoomManagementPage> createState() => _RoomManagementPageState();
}

class _RoomManagementPageState extends State<RoomManagementPage> {
  // Các Controller để lấy dữ liệu từ ô nhập
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _seatController = TextEditingController();

  String? _selectedCinema; // Lưu rạp được chọn từ Dropdown
  String? _selectedRoomName; // Lưu tên phòng được chọn từ Dropdown (Danh sách có sẵn)
  String _selectedRoomType = '2D'; // Giá trị mặc định cho Loại phòng

  // Mức giới hạn số lượng ghế tối đa quy định
  static const int MAX_SEATS = 200;

  // Danh sách Tên phòng chiếu có sẵn cho từng rạp
  final List<String> _availableRoomNames = [
    'Phòng chiếu 1',
    'Phòng chiếu 2',
    'Phòng chiếu 3',
    'Phòng chiếu 4',
    'Phòng VIP 1',
    'Phòng VIP 2',
    'Phòng IMAX Premium',
    'Phòng Starium 3D',
  ];

  // Danh sách phòng chiếu mẫu (Giả lập database)
  final List<Map<String, dynamic>> _rooms = [
    {
      'id': 'P01',
      'name': 'Phòng chiếu 1',
      'cinema': 'CGV AEON Bình Tân',
      'type': '2D',
      'seats': 48,
    },
    {
      'id': 'P02',
      'name': 'Phòng chiếu 2',
      'cinema': 'CGV Vivo City',
      'type': 'IMAX',
      'seats': 60,
    },
  ];

  int? _selectedRowIndex; // Lưu dòng đang được chọn để Sửa/Xóa

  // Hàm xoá trắng form (LÀM MỚI)
  void _clearForm() {
    setState(() {
      _idController.clear();
      _seatController.clear();
      _selectedRoomName = null;
      _selectedCinema = null;
      _selectedRoomType = '2D';
      _selectedRowIndex = null;
    });
  }

  // Hàm kiểm tra hợp lệ dữ liệu
  bool _validateInput() {
    if (_idController.text.trim().isEmpty ||
        _selectedRoomName == null ||
        _selectedCinema == null ||
        _seatController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập đầy đủ thông tin!"), backgroundColor: Colors.orange),
      );
      return false;
    }

    int? seats = int.tryParse(_seatController.text.trim());
    if (seats == null || seats <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Số ghế phải là số nguyên lớn hơn 0!"), backgroundColor: Colors.red),
      );
      return false;
    }

    // 🔴 RÀNG BUỘC SỐ LƯỢNG GHẾ KHÔNG VƯỢT QUÁ MỨC QUY ĐỊNH
    if (seats > MAX_SEATS) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Số lượng ghế không được vượt quá mức quy định ($MAX_SEATS ghế)!"),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A), // Tone tối của app
      appBar: AppBar(
        title: const Text("Admin - Quản Lý Phòng Chiếu"),
        backgroundColor: Colors.red[800], // Đổi sang màu đỏ CGV
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ================= FORM QUẢN LÝ PHÒNG CHIẾU =================
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red[800]!, width: 2),
              ),
              child: Column(
                children: [
                  // Tiêu đề bảng
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    color: Colors.red[700],
                    child: const Text(
                      "QUẢN LÝ PHÒNG CHIẾU",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16),
                    ),
                  ),

                  // Ô nhập Mã phòng
                  _buildFormRow(
                    "Mã phòng",
                    TextField(
                      controller: _idController,
                      enabled: _selectedRowIndex == null, // Khóa Mã phòng khi sửa
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          isDense: true,
                          border: OutlineInputBorder()),
                    ),
                  ),

                  // Dropdown chọn Tên phòng có sẵn
                  _buildFormRow(
                    "Tên phòng",
                    DropdownButtonFormField<String>(
                      value: _selectedRoomName,
                      dropdownColor: Colors.white,
                      style: const TextStyle(color: Colors.black),
                      hint: const Text('Chọn tên phòng có sẵn', style: TextStyle(color: Colors.grey)),
                      decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          isDense: true,
                          border: OutlineInputBorder()),
                      items: _availableRoomNames.map((roomName) {
                        return DropdownMenuItem<String>(
                          value: roomName,
                          child: Text(roomName),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedRoomName = value;
                        });
                      },
                    ),
                  ),

                  // Dropdown chọn Thuộc rạp
                  _buildFormRow(
                    "Thuộc rạp",
                    DropdownButtonFormField<String>(
                      value: _selectedCinema,
                      dropdownColor: Colors.white,
                      style: const TextStyle(color: Colors.black),
                      hint: const Text('Chọn rạp chiếu', style: TextStyle(color: Colors.grey)),
                      decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          isDense: true,
                          border: OutlineInputBorder()),
                      items: cinemaList.map((cinema) {
                        return DropdownMenuItem<String>(
                          value: cinema.name,
                          child: Text(cinema.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCinema = value;
                        });
                      },
                    ),
                  ),

                  // Radio chọn Loại phòng (2D, 3D, IMAX)
                  _buildFormRow(
                    "Loại phòng",
                    Row(
                      children: ['2D', '3D', 'IMAX'].map((type) {
                        return Row(
                          children: [
                            Radio<String>(
                              value: type,
                              groupValue: _selectedRoomType,
                              activeColor: Colors.red[700],
                              onChanged: (value) {
                                setState(() {
                                  _selectedRoomType = value!;
                                });
                              },
                            ),
                            Text(type,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(width: 15),
                          ],
                        );
                      }).toList(),
                    ),
                  ),

                  // Ô nhập Số lượng ghế (Ràng buộc tối đa MAX_SEATS)
                  _buildFormRow(
                    "Số lượng ghế",
                    TextField(
                      controller: _seatController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          isDense: true,
                          helperText: 'Tối đa $MAX_SEATS ghế/phòng',
                          helperStyle: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                          border: const OutlineInputBorder()),
                    ),
                  ),

                  // HÀNG NÚT CHỨC NĂNG: THÊM, SỬA, XOÁ, LÀM MỚI
                  Container(
                    color: Colors.red[700],
                    child: Row(
                      children: [
                        _buildActionButton("THÊM", () {
                          if (!_validateInput()) return;
                          
                          // Kiểm tra trùng Mã phòng
                          if (_rooms.any((room) => room['id'] == _idController.text.trim())) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Mã phòng này đã tồn tại!"), backgroundColor: Colors.red),
                            );
                            return;
                          }

                          setState(() {
                            _rooms.add({
                              'id': _idController.text.trim(),
                              'name': _selectedRoomName,
                              'cinema': _selectedCinema,
                              'type': _selectedRoomType,
                              'seats': int.parse(_seatController.text.trim()),
                            });
                            _clearForm();
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Thêm phòng chiếu thành công!"), backgroundColor: Colors.green),
                          );
                        }),
                        _buildActionButton(
                            "SỬA",
                            _selectedRowIndex == null
                                ? null
                                : () {
                                    if (!_validateInput()) return;

                                    setState(() {
                                      _rooms[_selectedRowIndex!] = {
                                        'id': _idController.text.trim(),
                                        'name': _selectedRoomName,
                                        'cinema': _selectedCinema,
                                        'type': _selectedRoomType,
                                        'seats': int.parse(_seatController.text.trim()),
                                      };
                                      _clearForm();
                                    });

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Cập nhật phòng chiếu thành công!"), backgroundColor: Colors.orange),
                                    );
                                  }),
                        _buildActionButton(
                            "XOÁ",
                            _selectedRowIndex == null
                                ? null
                                : () {
                                    if (_idController.text == 'P01') {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text("Không được xóa phòng đang có lịch chiếu!")),
                                      );
                                      return;
                                    }
                                    setState(() {
                                      _rooms.removeAt(_selectedRowIndex!);
                                      _clearForm();
                                    });

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Đã xóa phòng chiếu!"), backgroundColor: Colors.red),
                                    );
                                  }),
                        _buildActionButton("LÀM MỚI", _clearForm),
                      ],
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ================= DANH SÁCH PHÒNG CHIẾU ĐÃ TẠO =================
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("DANH SÁCH PHÒNG CHIẾU:",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _rooms.length,
              itemBuilder: (context, index) {
                final room = _rooms[index];
                bool isCurrentSelected = _selectedRowIndex == index;

                return Card(
                  color: isCurrentSelected ? Colors.red[900] : Colors.grey[900],
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    title: Text(
                        "${room['id']} - ${room['name']} (${room['type']})",
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: Text(
                        "Rạp: ${room['cinema']} • Ghế: ${room['seats']}/$MAX_SEATS",
                        style: TextStyle(color: Colors.grey[400])),
                    trailing: Icon(Icons.edit,
                        color: isCurrentSelected ? Colors.white : Colors.red),
                    onTap: () {
                      setState(() {
                        _selectedRowIndex = index;
                        _idController.text = room['id'];
                        _selectedRoomName = room['name'];
                        _selectedCinema = room['cinema'];
                        _selectedRoomType = room['type'];
                        _seatController.text = room['seats'].toString();
                      });
                    },
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  // Widget hỗ trợ vẽ từng dòng trong bảng form
  Widget _buildFormRow(String title, Widget inputWidget) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red[50], // Nền hồng nhạt/đỏ nhạt cho các dòng nhập
        border: Border(bottom: BorderSide(color: Colors.red[800]!)),
      ),
      child: Row(
        children: [
          Container(
            width: 120,
            padding: const EdgeInsets.all(10),
            color: Colors.red[200], // Màu tiêu đề cột bên trái
            child: Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black)),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: inputWidget,
            ),
          )
        ],
      ),
    );
  }

  // Widget hỗ trợ tạo nhanh các nút chức năng ở đáy bảng
  Widget _buildActionButton(String title, VoidCallback? onPressed) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red[800]!),
        ),
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15),
            backgroundColor:
                onPressed == null ? Colors.grey[400] : Colors.red[700],
          ),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: onPressed == null ? Colors.grey[700] : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}