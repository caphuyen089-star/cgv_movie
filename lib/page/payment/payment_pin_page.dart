import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PaymentPinPage extends StatefulWidget {
  const PaymentPinPage({super.key});

  @override
  State<PaymentPinPage> createState() => _PaymentPinPageState();
}

class _PaymentPinPageState extends State<PaymentPinPage> {
  // Controller cho 6 ô PIN mới
  final List<TextEditingController> _newPinControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _newPinFocusNodes = List.generate(6, (_) => FocusNode());

  // Controller cho 6 ô PIN xác nhận
  final List<TextEditingController> _confirmPinControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _confirmPinFocusNodes =
      List.generate(6, (_) => FocusNode());

  bool _obscurePin = true;
  static const Color primaryRed = Color(0xFFE52521);

  @override
  void dispose() {
    for (var c in _newPinControllers) {
      c.dispose();
    }
    for (var f in _newPinFocusNodes) {
      f.dispose();
    }
    for (var c in _confirmPinControllers) {
      c.dispose();
    }
    for (var f in _confirmPinFocusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  // Hàm xử lý khi hoàn tất cài đặt PIN
  void _submitPin() {
    String newPin = _newPinControllers.map((c) => c.text).join();
    String confirmPin = _confirmPinControllers.map((c) => c.text).join();

    if (newPin.length < 6 || confirmPin.length < 6) {
      _showSnackBar('Vui lòng nhập đủ 6 chữ số mật mã!', Colors.orange);
      return;
    }

    if (newPin == '000000' || newPin == '111111' || newPin == '222222' || 
        newPin == '333333' || newPin == '444444' || newPin == '555555' || 
        newPin == '666666' || newPin == '777777' || newPin == '888888' || newPin == '999999') {
      _showSnackBar('Mật mã không được là 6 số trùng nhau!', Colors.red);
      return;
    }

    if (newPin != confirmPin) {
      _showSnackBar('Mật mã xác nhận không trùng khớp!', Colors.red);
      return;
    }

    _showSnackBar('Cài đặt mật mã thanh toán thành công!', Colors.green);
    Navigator.pop(context);
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // Widget hiển thị dải 6 ô PIN chuẩn app chuyên nghiệp
  Widget _buildPinInputRow({
    required List<TextEditingController> controllers,
    required List<FocusNode> focusNodes,
    required List<FocusNode>? nextFocusNodes,
    required List<FocusNode>? prevFocusNodes,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(6, (index) {
        return SizedBox(
          width: 45,
          height: 52,
          child: TextField(
            controller: controllers[index],
            focusNode: focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            obscureText: _obscurePin,
            obscuringCharacter: '●',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              filled: true,
              fillColor: Colors.grey[50],
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[300]!, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: primaryRed, width: 2),
              ),
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                if (index < 5) {
                  FocusScope.of(context).requestFocus(focusNodes[index + 1]);
                } else if (nextFocusNodes != null) {
                  FocusScope.of(context).requestFocus(nextFocusNodes[0]);
                } else {
                  focusNodes[index].unfocus();
                }
              } else {
                if (index > 0) {
                  FocusScope.of(context).requestFocus(focusNodes[index - 1]);
                } else if (prevFocusNodes != null) {
                  FocusScope.of(context).requestFocus(prevFocusNodes[5]);
                }
              }
            },
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: primaryRed, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Mật mã thanh toán',
          style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // CARD HƯỚNG DẪN
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber[300]!),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.security, color: Colors.amber, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Mục đích sử dụng PIN',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown, fontSize: 14),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Dùng để xác minh thanh toán Voucher, Đổi điểm thưởng, Thẻ quà tặng.\n'
                          'Mật mã bao gồm 6 chữ số (không dùng 6 số trùng nhau như 111111).',
                          style: TextStyle(color: Colors.grey[800], fontSize: 12.5, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // FORM NHẬP PIN
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Mật mã mới (6 số)',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
                      ),
                      IconButton(
                        onPressed: () => setState(() => _obscurePin = !_obscurePin),
                        icon: Icon(
                          _obscurePin ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: Colors.grey[600],
                          size: 20,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildPinInputRow(
                    controllers: _newPinControllers,
                    focusNodes: _newPinFocusNodes,
                    nextFocusNodes: _confirmPinFocusNodes,
                    prevFocusNodes: null,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Xác nhận lại mật mã mới',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 12),
                  _buildPinInputRow(
                    controllers: _confirmPinControllers,
                    focusNodes: _confirmPinFocusNodes,
                    nextFocusNodes: null,
                    prevFocusNodes: _newPinFocusNodes,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 35),

            // NÚT ĐỒNG Ý
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryRed,
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
                onPressed: _submitPin,
                child: const Text(
                  'CẬP NHẬT MẬT MÃ',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15, letterSpacing: 1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}