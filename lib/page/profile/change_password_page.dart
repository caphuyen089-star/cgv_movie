import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _currentPassController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  bool _hideCurrent = true;
  bool _hideNew = true;
  bool _hideConfirm = true;

  @override
  void dispose() {
    _currentPassController.dispose();
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  void _handleChangePassword() {
    if (_formKey.currentState!.validate()) {
      // 🟢 Xử lý đổi mật khẩu thành công
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cập nhật mật khẩu thành công!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Đồng bộ nền đen với ProfilePage
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFD3432B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Đổi mật khẩu',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // 1. Mật khẩu hiện tại
              _buildPasswordField(
                controller: _currentPassController,
                labelText: 'Mật khẩu hiện tại',
                isHide: _hideCurrent,
                onToggleHide: () => setState(() => _hideCurrent = !_hideCurrent),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Vui lòng nhập mật khẩu hiện tại';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 2. Mật khẩu mới
              _buildPasswordField(
                controller: _newPassController,
                labelText: 'Mật khẩu mới',
                isHide: _hideNew,
                onToggleHide: () => setState(() => _hideNew = !_hideNew),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Vui lòng nhập mật khẩu mới';
                  if (val.length < 6) return 'Mật khẩu phải từ 6 ký tự trở lên';
                  if (val == _currentPassController.text) {
                    return 'Mật khẩu mới không được giống mật khẩu cũ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 3. Nhập lại mật khẩu mới
              _buildPasswordField(
                controller: _confirmPassController,
                labelText: 'Nhập lại mật khẩu mới',
                isHide: _hideConfirm,
                onToggleHide: () => setState(() => _hideConfirm = !_hideConfirm),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Vui lòng nhập lại mật khẩu mới';
                  if (val != _newPassController.text) return 'Mật khẩu nhập lại không khớp';
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Nút Thay đổi mật khẩu
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD3432B),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: _handleChangePassword,
                  child: const Text(
                    'THAY ĐỔI MẬT KHẨU',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget dùng chung cho các ô nhập mật khẩu
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String labelText,
    required bool isHide,
    required VoidCallback onToggleHide,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isHide,
      style: const TextStyle(color: Colors.white),
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.grey),
        fillColor: Colors.grey[900],
        filled: true,
        suffixIcon: IconButton(
          icon: Icon(isHide ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
          onPressed: onToggleHide,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        errorStyle: const TextStyle(color: Colors.redAccent),
      ),
    );
  }
}