import 'package:flutter/material.dart';

class PointPage extends StatefulWidget {
  const PointPage({super.key});

  @override
  State<PointPage> createState() => _PointPageState();
}

class _PointPageState extends State<PointPage> with SingleTickerProviderStateMixin {
  static const Color primaryRed = Color(0xFFE52521);
  late TabController _tabController;

  // Giả lập điểm thưởng của người dùng
  final int _currentPoints = 120; // Số điểm hiện tại
  final int _nextTierPoints = 500; // Điểm cần để lên VIP

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double progress = (_currentPoints / _nextTierPoints).clamp(0.0, 1.0);

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
          'Điểm thưởng CGV',
          style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ================= 1. CARD ĐIỂM THƯỞNG METALLIC =================
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFF2C3E50), Color(0xFF000000)], // Gradient đen xám VIP sang trọng
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.stars_rounded, color: Colors.amber, size: 24),
                          const SizedBox(width: 8),
                          Text(
                            'CGV POINTS',
                            style: TextStyle(
                              color: Colors.amber[400],
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: primaryRed,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'MEMBER',
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Số điểm khả dụng
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '$_currentPoints',
                        style: const TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          fontFamily: 'monospace',
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'điểm',
                        style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const Spacer(),
                      Text(
                        '≈ ${(_currentPoints * 1000).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')} đ',
                        style: TextStyle(color: Colors.amber[200], fontSize: 14, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),

                  const SizedBox(height: 20),
                  const Divider(color: Colors.white24, height: 1),
                  const SizedBox(height: 16),

                  // Progress Bar Nâng Hạng VIP
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Tiến trình lên hạng VIP', style: TextStyle(color: Colors.white70, fontSize: 11)),
                      Text('$_currentPoints / $_nextTierPoints P', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: Colors.white24,
                      valueColor: const AlwaysStoppedAnimation<Color>(primaryRed),
                    ),
                  ),
                ],
              ),
            ),

            // ================= 2. QUY ĐỔI ĐIỂM BẮT MẮT =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: _buildQuickActionTile(
                      icon: Icons.confirmation_num_outlined,
                      title: 'Đổi Vé Xem Phim',
                      subtitle: 'Chỉ từ 20 P',
                      color: Colors.red[50]!,
                      iconColor: primaryRed,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildQuickActionTile(
                      icon: Icons.fastfood_outlined,
                      title: 'Đổi Combo Bỏng Nước',
                      subtitle: 'Chỉ từ 15 P',
                      color: Colors.orange[50]!,
                      iconColor: Colors.orange[800]!,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ================= 3. TAB LỊCH SỬ & ĐIỂM HẾT HẠN =================
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    indicatorColor: primaryRed,
                    labelColor: primaryRed,
                    unselectedLabelColor: Colors.grey[600],
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    tabs: const [
                      Tab(text: 'Điểm sắp hết hạn'),
                      Tab(text: 'Lịch sử tích/tiêu'),
                    ],
                  ),
                  SizedBox(
                    height: 320,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // TAB 1: ĐIỂM SẮP HẾT HẠN
                        _buildExpiringPointsTab(),

                        // TAB 2: LỊCH SỬ TÍCH ĐIỂM
                        _buildHistoryTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color,
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 10, color: Colors.grey[600], fontWeight: FontWeight.w500),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildExpiringPointsTab() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.amber[50],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.verified_outlined,
              size: 48,
              color: Colors.amber[800],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Không có điểm nào sắp hết hạn',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 6),
          Text(
            'Bạn chưa có điểm CGV nào sắp hết hạn trong vòng 3 tháng tới. Hãy yên tâm tích điểm nhé!',
            style: TextStyle(color: Colors.grey[600], fontSize: 12.5, height: 1.4),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    final List<Map<String, String>> sampleHistory = [
      {'title': 'Tích điểm xem phim Lật Mặt 7', 'date': '28/05/2026', 'points': '+20 P', 'color': 'green'},
      {'title': 'Đổi Combo Popcorn Sweet', 'date': '15/04/2026', 'points': '-15 P', 'color': 'red'},
      {'title': 'Thưởng sinh nhật thành viên', 'date': '01/01/2026', 'points': '+50 P', 'color': 'green'},
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: sampleHistory.length,
      separatorBuilder: (_, __) => const Divider(height: 20),
      itemBuilder: (context, index) {
        final item = sampleHistory[index];
        final bool isPositive = item['color'] == 'green';

        return Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: isPositive ? Colors.green[50] : Colors.red[50],
              child: Icon(
                isPositive ? Icons.add_rounded : Icons.remove_rounded,
                color: isPositive ? Colors.green : primaryRed,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title']!,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item['date']!,
                    style: TextStyle(color: Colors.grey[500], fontSize: 11),
                  ),
                ],
              ),
            ),
            Text(
              item['points']!,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isPositive ? Colors.green : primaryRed,
              ),
            ),
          ],
        );
      },
    );
  }
}