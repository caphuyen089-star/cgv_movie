import 'package:flutter/material.dart';

class AdminCinemaPage extends StatefulWidget {
  const AdminCinemaPage({super.key});

  @override
  State<AdminCinemaPage> createState() => _AdminCinemaPageState();
}

class _AdminCinemaPageState extends State<AdminCinemaPage> {
  final _addressDetailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _durationController = TextEditingController();

  DateTime? _selectedStartDate;
  String _status = 'Hoạt động';
  int? _selectedIndex;

  // 1. Danh sách Mã rạp và Tên rạp có sẵn
  final List<Map<String, String>> _availableCinemas = [
    {'id': 'R01', 'name': 'CGV Vincom Center'},
    {'id': 'R02', 'name': 'CGV Landmark 81'},
    {'id': 'R03', 'name': 'CGV Tràng Tiền Plaza'},
    {'id': 'R04', 'name': 'CGV Vĩnh Trung Plaza'},
    {'id': 'R05', 'name': 'CGV Vincom Cần Thơ'},
  ];

  String? _selectedCinemaId; // Lưu mã rạp đã chọn

  // 2. Danh sách 5 tỉnh/thành phố lớn cho sẵn
  final List<String> _provinces = [
    'TP. Hồ Chí Minh',
    'Hà Nội',
    'Đà Nẵng',
    'Cần Thơ',
    'Hải Phòng',
  ];

  String? _selectedProvince; // Lưu tỉnh/thành phố được chọn

  // 3. Quy định thời lượng tối đa cho phép
  static const int MAX_LIMIT_DURATION = 240; // Tối đa 240 phút (4 tiếng)

  // Danh sách rạp chiếu ban đầu
  final List<Map<String, dynamic>> _cinemas = [
    {
      'id': 'R01',
      'name': 'CGV Vincom Center',
      'province': 'TP. Hồ Chí Minh',
      'address': '72 Lê Thánh Tôn, Q.1, TP. Hồ Chí Minh',
      'phone': '0901234567',
      'maxDuration': 180,
      'startDate': DateTime.now(),
      'status': 'Hoạt động'
    },
    {
      'id': 'R02',
      'name': 'CGV Landmark 81',
      'province': 'TP. Hồ Chí Minh',
      'address': '720A Điện Biên Phủ, Bình Thạnh, TP. Hồ Chí Minh',
      'phone': '0987654321',
      'maxDuration': 150,
      'startDate': DateTime.now().add(const Duration(days: 1)),
      'status': 'Hoạt động'
    },
  ];

  void _clearForm() {
    setState(() {
      _selectedIndex = null;
      _selectedCinemaId = null;
      _selectedProvince = null;
      _addressDetailController.clear();
      _phoneController.clear();
      _durationController.clear();
      _selectedStartDate = null;
      _status = 'Hoạt động';
    });
  }

  void _selectCinema(int index) {
    final item = _cinemas[index];
    setState(() {
      _selectedIndex = index;
      _selectedCinemaId = item['id'];
      _selectedProvince = item['province'];
      
      // Tách địa chỉ chi tiết ra khỏi tỉnh thành (nếu có)
      String rawAddr = item['address'] ?? '';
      if (_selectedProvince != null && rawAddr.endsWith(', ${_selectedProvince!}')) {
        _addressDetailController.text = rawAddr.replaceAll(', ${_selectedProvince!}', '');
      } else {
        _addressDetailController.text = rawAddr;
      }

      _phoneController.text = item['phone'] ?? '';
      _durationController.text = item['maxDuration']?.toString() ?? '';
      _selectedStartDate = item['startDate'];
      _status = item['status'] ?? 'Hoạt động';
    });
  }

  // Chọn ngày khởi chiếu (Chỉ chọn từ ngày hiện tại trở đi)
  Future<void> _pickStartDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedStartDate != null && !_selectedStartDate!.isBefore(today)
          ? _selectedStartDate!
          : today,
      firstDate: today,
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() {
        _selectedStartDate = picked;
      });
    }
  }

  // Hàm kiểm tra hợp lệ thông tin
  bool _validateInputs() {
    // 1. Kiểm tra Chọn Mã/Tên rạp
    if (_selectedCinemaId == null) {
      _showSnackBar('Vui lòng chọn Mã & Tên rạp chiếu!', Colors.orange);
      return false;
    }

    // 2. Kiểm tra Chọn Tỉnh/Thành phố & Nhập địa chỉ chi tiết
    if (_selectedProvince == null || _addressDetailController.text.trim().isEmpty) {
      _showSnackBar('Vui lòng chọn Tỉnh/Thành phố và nhập Địa chỉ chi tiết!', Colors.orange);
      return false;
    }

    // 3. Ràng buộc Số điện thoại phải ĐỦ 10 SỐ và bắt đầu bằng số 0
    final phone = _phoneController.text.trim();
    final phoneRegExp = RegExp(r'^0[0-9]{9}$');
    if (!phoneRegExp.hasMatch(phone)) {
      _showSnackBar('Số điện thoại phải bao gồm đúng 10 chữ số (bắt đầu bằng 0)!', Colors.red);
      return false;
    }

    // 4. Ràng buộc Thời lượng tối đa
    final durationText = _durationController.text.trim();
    final duration = int.tryParse(durationText);
    if (duration == null || duration <= 0) {
      _showSnackBar('Thời lượng tối đa phải là số nguyên dương lớn hơn 0!', Colors.red);
      return false;
    }
    if (duration > MAX_LIMIT_DURATION) {
      _showSnackBar('Thời lượng tối đa không được vượt quá $MAX_LIMIT_DURATION phút!', Colors.red);
      return false;
    }

    // 5. Kiểm tra ngày khởi chiếu
    if (_selectedStartDate == null) {
      _showSnackBar('Vui lòng chọn Ngày khởi chiếu!', Colors.orange);
      return false;
    }

    return true;
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  void _addCinema() {
    if (!_validateInputs()) return;

    // Kiểm tra trùng mã rạp khi thêm
    if (_cinemas.any((c) => c['id'] == _selectedCinemaId)) {
      _showSnackBar('Mã rạp này đã tồn tại trong danh sách!', Colors.red);
      return;
    }

    final cinemaInfo = _availableCinemas.firstWhere((c) => c['id'] == _selectedCinemaId);
    final fullAddress = '${_addressDetailController.text.trim()}, ${_selectedProvince!}';

    setState(() {
      _cinemas.add({
        'id': cinemaInfo['id'],
        'name': cinemaInfo['name'],
        'province': _selectedProvince,
        'address': fullAddress,
        'phone': _phoneController.text.trim(),
        'maxDuration': int.parse(_durationController.text.trim()),
        'startDate': _selectedStartDate,
        'status': _status,
      });
      _clearForm();
    });
    _showSnackBar('Thêm rạp chiếu thành công!', const Color(0xFFD3432B));
  }

  void _updateCinema() {
    if (_selectedIndex == null) return;
    if (!_validateInputs()) return;

    final cinemaInfo = _availableCinemas.firstWhere((c) => c['id'] == _selectedCinemaId);
    final fullAddress = '${_addressDetailController.text.trim()}, ${_selectedProvince!}';

    setState(() {
      _cinemas[_selectedIndex!] = {
        'id': cinemaInfo['id'],
        'name': cinemaInfo['name'],
        'province': _selectedProvince,
        'address': fullAddress,
        'phone': _phoneController.text.trim(),
        'maxDuration': int.parse(_durationController.text.trim()),
        'startDate': _selectedStartDate,
        'status': _status,
      };
      _clearForm();
    });
    _showSnackBar('Cập nhật thành công!', Colors.orange);
  }

  void _deleteCinema() {
    if (_selectedIndex == null) return;
    setState(() {
      _cinemas.removeAt(_selectedIndex!);
      _clearForm();
    });
    _showSnackBar('Đã xóa rạp chiếu!', Colors.black87);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BM13: Quản Lý Rạp Chiếu', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFD3432B),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFD3432B), width: 1.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      color: const Color(0xFFD3432B),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: const Text(
                        'QUẢN LÝ RẠP CHIẾU',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),

                    // 1. CHỌN MÃ RẠP VÀ TÊN RẠP CÓ SẴN
                    _buildCustomRow(
                      'Rạp chiếu',
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: _selectedCinemaId,
                          hint: const Text('Chọn Mã - Tên rạp sẵn có', style: TextStyle(color: Colors.grey, fontSize: 13)),
                          items: _availableCinemas.map((cinema) {
                            return DropdownMenuItem<String>(
                              value: cinema['id'],
                              child: Text('${cinema['id']} - ${cinema['name']}', style: const TextStyle(fontWeight: FontWeight.w600)),
                            );
                          }).toList(),
                          onChanged: _selectedIndex != null 
                              ? null // Khóa không cho sửa Mã rạp khi đang sửa
                              : (val) => setState(() => _selectedCinemaId = val),
                        ),
                      ),
                    ),

                    // 2. CHỌN TỈNH / THÀNH PHỐ (5 Tỉnh thành cho sẵn)
                    _buildCustomRow(
                      'Tỉnh/Thành phố',
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: _selectedProvince,
                          hint: const Text('Chọn Tỉnh / Thành phố', style: TextStyle(color: Colors.grey, fontSize: 13)),
                          items: _provinces.map((prov) {
                            return DropdownMenuItem<String>(
                              value: prov,
                              child: Text(prov, style: const TextStyle(fontWeight: FontWeight.w600)),
                            );
                          }).toList(),
                          onChanged: (val) => setState(() => _selectedProvince = val),
                        ),
                      ),
                    ),

                    // 3. NHẬP ĐỊA CHỈ CHI TIẾT
                    _buildFormRow('Địa chỉ chi tiết', _addressDetailController, hint: 'Số nhà, Tên đường, Quận/Huyện'),

                    // 4. NHẬP SỐ ĐIỆN THOẠI (Yêu cầu 10 số)
                    _buildFormRow('Số điện thoại', _phoneController, isNumber: true, hint: 'Nhập đủ 10 số (VD: 0901234567)'),

                    // 5. NHẬP THỜI LƯỢNG TỐI ĐA (Khống chế max MAX_LIMIT_DURATION)
                    _buildFormRow('Thời lượng tối đa', _durationController, isNumber: true, hint: 'Tối đa $MAX_LIMIT_DURATION phút'),

                    // 6. Ô CHỌN NGÀY KHỞI CHIẾU
                    _buildCustomRow(
                      'Ngày khởi chiếu',
                      InkWell(
                        onTap: _pickStartDate,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            _selectedStartDate == null
                                ? 'Chọn ngày (Từ hôm nay trở đi)'
                                : '${_selectedStartDate!.day.toString().padLeft(2, '0')}/${_selectedStartDate!.month.toString().padLeft(2, '0')}/${_selectedStartDate!.year}',
                            style: TextStyle(
                              color: _selectedStartDate == null ? Colors.grey : Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // 7. CHỌN TRẠNG THÁI
                    _buildCustomRow(
                      'Trạng thái',
                      Row(
                        children: [
                          Radio<String>(
                            value: 'Hoạt động',
                            activeColor: const Color(0xFFD3432B),
                            groupValue: _status,
                            onChanged: (val) => setState(() => _status = val!),
                          ),
                          const Text('Hoạt động', style: TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(width: 10),
                          Radio<String>(
                            value: 'Ngừng hoạt động',
                            activeColor: const Color(0xFFD3432B),
                            groupValue: _status,
                            onChanged: (val) => setState(() => _status = val!),
                          ),
                          const Text('Ngừng HD', style: TextStyle(fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),

                    // HÀNG NÚT THAO TÁC
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(top: BorderSide(color: Color(0xFFD3432B))),
                        color: Color(0xFFFBE9E7),
                      ),
                      child: Row(
                        children: [
                          _buildBtn('THÊM', _addCinema),
                          _buildBtn('SỬA', _updateCinema),
                          _buildBtn('XOÁ', _deleteCinema),
                          _buildBtn('LÀM MỚI', _clearForm),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Danh sách rạp chiếu:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
            ),
            const SizedBox(height: 10),

            // DANH SÁCH RẠP CHIẾU
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _cinemas.length,
              itemBuilder: (context, index) {
                final item = _cinemas[index];
                final isSelected = index == _selectedIndex;
                final DateTime? startDate = item['startDate'];
                final String formattedDate = startDate != null
                    ? '${startDate.day.toString().padLeft(2, '0')}/${startDate.month.toString().padLeft(2, '0')}/${startDate.year}'
                    : 'Chưa đặt';

                return Card(
                  color: isSelected ? const Color(0xFFFBE9E7) : Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: isSelected ? const Color(0xFFD3432B) : Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    onTap: () => _selectCinema(index),
                    title: Text('${item['id']} - ${item['name']}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15)),
                    subtitle: Text(
                      '📍 ${item['address']}\n📞 SDT: ${item['phone']} | Trạng thái: ${item['status']}\n⏱ Thời lượng tối đa: ${item['maxDuration']} phút\n📅 Khởi chiếu: $formattedDate',
                      style: const TextStyle(color: Colors.black87, fontSize: 13, height: 1.4),
                    ),
                    trailing: const Icon(Icons.edit_note, color: Color(0xFFD3432B), size: 28),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  // Widget dòng Form chuẩn dùng cho ô nhập TextField
  Widget _buildFormRow(String label, TextEditingController controller, {bool enabled = true, bool isNumber = false, String? hint}) {
    return _buildCustomRow(
      label,
      TextField(
        controller: controller,
        enabled: enabled,
        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 14),
        keyboardType: isNumber ? TextInputType.phone : TextInputType.text,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.normal),
          border: InputBorder.none, 
          isDense: true,
        ),
      ),
    );
  }

  // Widget cấu trúc chung cho mỗi hàng trong Form
  Widget _buildCustomRow(String label, Widget contentWidget) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFCCCCCC))),
        color: Color(0xFFFFF8F6),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 130,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 13)),
            ),
            const VerticalDivider(width: 1, color: Color(0xFFCCCCCC), thickness: 1),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: contentWidget,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget tạo nhanh các nút thao tác
  Widget _buildBtn(String title, VoidCallback onPressed) {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          border: Border(right: BorderSide(color: Color(0xFFD3432B))),
        ),
        child: TextButton(
          onPressed: onPressed,
          child: Text(title, style: const TextStyle(color: Color(0xFFD3432B), fontWeight: FontWeight.bold, fontSize: 13)),
        ),
      ),
    );
  }
}