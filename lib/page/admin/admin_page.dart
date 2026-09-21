import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cgv_movie/page/login/login_page.dart';

// Import các trang con trong admin
import 'admin_movie_page.dart';
import 'admin_showtime_page.dart';
import 'approve_movie_page.dart';
import 'room_management_page.dart';
import 'admin_employee_page.dart';
import 'admin_revenue_report_page.dart';
import 'admin_cinema_page.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  // Hàm đăng xuất
  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          "TRANG QUẢN TRỊ ADMIN",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.red[900],
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: "Đăng xuất",
            onPressed: _logout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Danh mục quản lý",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                physics: const BouncingScrollPhysics(), // Cho phép vuốt cuộn lên xuống mượt mà
                children: [
                  // 1. Quản lý phim
                  _buildAdminCard(
                    title: "Quản Lý Phim",
                    icon: Icons.movie_creation_outlined,
                    color: Colors.blueAccent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AdminMoviePage()),
                      );
                    },
                  ),

                  // 2. Quản lý suất chiếu
                  _buildAdminCard(
                    title: "Quản Lý Suất Chiếu",
                    icon: Icons.access_time_filled_outlined,
                    color: Colors.orangeAccent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AdminShowtimePage()),
                      );
                    },
                  ),

                  // 3. Quản lý phòng
                  _buildAdminCard(
                    title: "Quản Lý Phòng",
                    icon: Icons.meeting_room_outlined,
                    color: Colors.purpleAccent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RoomManagementPage()),
                      );
                    },
                  ),

                  // 4. Duyệt phim
                  _buildAdminCard(
                    title: "Duyệt Phim",
                    icon: Icons.verified_user_outlined,
                    color: Colors.green,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ApproveMoviePage()),
                      );
                    },
                  ),

                  // 5. Quản lý Rạp Chiếu
                  // 5. Quản lý Rạp Chiếu
                  _buildAdminCard(
                    title: "Quản Lý Rạp Chiếu",
                    icon: Icons.store_mall_directory_outlined,
                    color: Colors.redAccent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AdminCinemaPage()),
                      );
                    },
                  ),

                  // 6. Quản lý Nhân Viên
                  _buildAdminCard(
                    title: "Quản Lý Nhân Viên",
                    icon: Icons.badge_outlined,
                    color: Colors.tealAccent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AdminEmployeePage()),
                      );
                    },
                  ),

                  // 7. Báo Cáo Doanh Thu
                  _buildAdminCard(
                    title: "Báo Cáo Doanh Thu",
                    icon: Icons.bar_chart_outlined,
                    color: Colors.amberAccent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AdminRevenueReportPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget hiển thị từng ô chức năng
  Widget _buildAdminCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withOpacity(0.5), width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}