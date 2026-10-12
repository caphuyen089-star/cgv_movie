import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'change_password_page.dart';
import 'voucher_page.dart';
import '../ticket/ticket_history_page.dart';
import '../login/login_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final displayName = currentUser?.displayName ??
        (currentUser?.email != null ? currentUser!.email!.split('@')[0].toUpperCase() : 'THANH HUYỀN');
    final emailDisplay = currentUser?.email ?? 'Mã số: 9012 3456 7890';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Thành Viên CGV', style: TextStyle(color: Colors.white)),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 1. Thẻ thành viên CGV điện tử
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.red, Colors.black87],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('CGV MEMBER', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      Icon(Icons.nfc, color: Colors.white70),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Text(displayName, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500)),
                  Text(emailDisplay, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 20),
                  
                  // Barcode giả lập
                  Container(
                    height: 40,
                    width: double.infinity,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        25,
                        (index) => Container(
                          width: index % 3 == 0 ? 4 : (index % 2 == 0 ? 1 : 2),
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // 2. Điểm tích lũy và quà tặng
            Row(
              children: [
                _buildStatBox('Điểm CGV', '1,250 P'),
                const SizedBox(width: 16),
                _buildStatBox('Voucher', '3 thẻ'),
              ],
            ),
            const SizedBox(height: 20),

            // 3. Danh sách Menu
            _buildMenuListTile(Icons.history, 'Lịch sử đặt vé', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TicketHistoryPage()),
              );
            }),
            _buildMenuListTile(Icons.card_giftcard, 'Đổi quà tặng | Voucher', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const VoucherPage()),
              );
            }),
            _buildMenuListTile(Icons.security, 'Đổi mật khẩu', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChangePasswordPage()),
              );
            }),
            
            const SizedBox(height: 30),
            
            // Nút đăng xuất
            TextButton.icon(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: Colors.grey[900],
                    title: const Text('Đăng xuất', style: TextStyle(color: Colors.white)),
                    content: const Text('Bạn có chắc chắn muốn đăng xuất khỏi tài khoản?', style: TextStyle(color: Colors.white70)),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('HỦY', style: TextStyle(color: Colors.grey)),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text('ĐĂNG XUẤT', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  await FirebaseAuth.instance.signOut();
                  if (!context.mounted) return;
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
                  );
                }
              },
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text('ĐĂNG XUẤT', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStatBox(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuListTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
      onTap: onTap,
    );
  }
}