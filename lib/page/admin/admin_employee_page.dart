import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminEmployeePage extends StatefulWidget {
  const AdminEmployeePage({super.key});

  @override
  State<AdminEmployeePage> createState() => _AdminEmployeePageState();
}

class _AdminEmployeePageState extends State<AdminEmployeePage> {
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _roleController = TextEditingController();
  final _passController = TextEditingController();

  int? _selectedIndex;

  final List<Map<String, String>> _employees = [
    {
      'id': '1234567890',
      'name': 'Nguyễn Văn A',
      'phone': '0901234567',
      'email': 'nva@gmail.com',
      'role': 'Thu ngân',
      'pass': '1234567890'
    },
    {
      'id': '0987654321',
      'name': 'Trần Thị B',
      'phone': '0909876543',
      'email': 'ttb@gmail.com',
      'role': 'Quản lý',
      'pass': 'abcdefghik'
    },
  ];

  void _clearForm() {
    setState(() {
      _selectedIndex = null;
      _idController.clear();
      _nameController.clear();
      _phoneController.clear();
      _emailController.clear();
      _roleController.clear();
      _passController.clear();
    });
  }

  void _selectEmployee(int index) {
    setState(() {
      _selectedIndex = index;
      _idController.text = _employees[index]['id']!;
      _nameController.text = _employees[index]['name']!;
      _phoneController.text = _employees[index]['phone']!;
      _emailController.text = _employees[index]['email']!;
      _roleController.text = _employees[index]['role']!;
      _passController.text = _employees[index]['pass']!;
    });
  }

  // Hàm kiểm tra hợp lệ các ràng buộc
  bool _validateInput() {
    final id = _idController.text.trim();
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final pass = _passController.text.trim();

    if (id.isEmpty || name.isEmpty || phone.isEmpty || pass.isEmpty) {
      _showMessage('Vui lòng điền đầy đủ các thông tin bắt buộc!');
      return false;
    }

    // Ràng buộc Mã nhân viên: Đúng 10 chữ số
    final idRegExp = RegExp(r'^\d{10}$');
    if (!idRegExp.hasMatch(id)) {
      _showMessage('Mã nhân viên phải gồm đúng 10 chữ số!');
      return false;
    }

    // Ràng buộc Số điện thoại: Đúng 10 chữ số và bắt đầu bằng số 0
    final phoneRegExp = RegExp(r'^0\d{9}$');
    if (!phoneRegExp.hasMatch(phone)) {
      _showMessage('Số điện thoại phải gồm 10 chữ số và bắt đầu bằng số 0!');
      return false;
    }

    // Ràng buộc Mật khẩu: Đúng 10 ký tự
    if (pass.length != 10) {
      _showMessage('Mật khẩu phải gồm đúng 10 ký tự!');
      return false;
    }

    return true;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  void _addEmployee() {
    if (!_validateInput()) return;

    // Kiểm tra trùng Mã nhân viên
    if (_employees.any((emp) => emp['id'] == _idController.text.trim())) {
      _showMessage('Mã nhân viên đã tồn tại!');
      return;
    }

    setState(() {
      _employees.add({
        'id': _idController.text.trim(),
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'email': _emailController.text.trim(),
        'role': _roleController.text.trim(),
        'pass': _passController.text.trim(),
      });
      _clearForm();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Thêm nhân viên thành công!'),
        backgroundColor: Color(0xFFD3432B),
      ),
    );
  }

  void _updateEmployee() {
    if (_selectedIndex == null) return;
    if (!_validateInput()) return;

    setState(() {
      _employees[_selectedIndex!] = {
        'id': _idController.text.trim(),
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'email': _emailController.text.trim(),
        'role': _roleController.text.trim(),
        'pass': _passController.text.trim(),
      };
      _clearForm();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cập nhật nhân viên thành công!'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _deleteEmployee() {
    if (_selectedIndex == null) return;
    setState(() {
      _employees.removeAt(_selectedIndex!);
      _clearForm();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã xóa nhân viên!'), backgroundColor: Colors.black87),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BM15: Quản Lý Nhân Viên', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                        'QUẢN LÝ NHÂN VIÊN',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    _buildFormRow(
                      'Mã nhân viên', 
                      _idController, 
                      enabled: _selectedIndex == null,
                      isNumberOnly: true,
                      maxLength: 10,
                    ),
                    _buildFormRow('Họ và Tên', _nameController),
                    _buildFormRow(
                      'Số điện thoại', 
                      _phoneController, 
                      isPhone: true,
                      maxLength: 10,
                    ),
                    _buildFormRow('Email', _emailController),
                    _buildFormRow('Chức vụ', _roleController),
                    _buildFormRow(
                      'Mật khẩu', 
                      _passController, 
                      isObscure: true,
                      maxLength: 10,
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(top: BorderSide(color: Color(0xFFD3432B))),
                        color: Color(0xFFFBE9E7),
                      ),
                      child: Row(
                        children: [
                          _buildBtn('THÊM', _addEmployee),
                          _buildBtn('SỬA', _updateEmployee),
                          _buildBtn('XOÁ', _deleteEmployee),
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
              child: Text('Danh sách nhân viên:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _employees.length,
              itemBuilder: (context, index) {
                final emp = _employees[index];
                final isSelected = index == _selectedIndex;
                return Card(
                  color: isSelected ? const Color(0xFFFBE9E7) : Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: isSelected ? const Color(0xFFD3432B) : Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    onTap: () => _selectEmployee(index),
                    title: Text('${emp['id']} - ${emp['name']}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15)),
                    subtitle: Text(
                      '💼 ${emp['role']} | 📞 ${emp['phone']}\n📧 ${emp['email']}',
                      style: const TextStyle(color: Colors.black87, fontSize: 13, height: 1.4),
                    ),
                    trailing: const Icon(Icons.person, color: Color(0xFFD3432B), size: 28),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFormRow(
    String label, 
    TextEditingController controller, {
    bool enabled = true, 
    bool isPhone = false, 
    bool isNumberOnly = false,
    bool isObscure = false,
    int? maxLength,
  }) {
    List<TextInputFormatter> formatters = [];
    if (isPhone || isNumberOnly) {
      formatters.add(FilteringTextInputFormatter.digitsOnly);
    }
    if (maxLength != null) {
      formatters.add(LengthLimitingTextInputFormatter(maxLength));
    }

    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFCCCCCC))),
        color: Color(0xFFFFF8F6),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 120,
              padding: const EdgeInsets.all(10),
              child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 14)),
            ),
            const VerticalDivider(width: 1, color: Color(0xFFCCCCCC), thickness: 1),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  controller: controller,
                  enabled: enabled,
                  obscureText: isObscure,
                  inputFormatters: formatters,
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 14),
                  keyboardType: (isPhone || isNumberOnly) ? TextInputType.number : TextInputType.text,
                  decoration: const InputDecoration(
                    border: InputBorder.none, 
                    isDense: true,
                    counterText: '', // Ẩn bộ đếm độ dài mặc định
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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