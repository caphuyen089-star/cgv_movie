import 'package:flutter/material.dart';

class VoucherPage extends StatefulWidget {
  const VoucherPage({super.key});

  @override
  State<VoucherPage> createState() => _VoucherPageState();
}

class _VoucherPageState extends State<VoucherPage> with SingleTickerProviderStateMixin {
  static const Color primaryRed = Color(0xFFE52521);
  late TabController _tabController;

  // Dữ liệu mẫu Voucher/Coupon của người dùng
  final List<Map<String, dynamic>> _myVouchers = [
    {
      'type': 'Coupon',
      'title': 'COUPON GIẢM 50K VÉ PHIM',
      'code': 'CGV50KOFF',
      'expiry': 'HSD: 31/12/2026',
      'desc': 'Áp dụng cho mọi suất chiếu 2D toàn quốc',
      'tag': 'SẮP HẾT HẠN',
      'tagColor': Colors.red,
    },
    {
      'type': 'Coupon',
      'title': 'FREE POPCORN SWEET M',
      'code': 'FREEPOPCORN',
      'expiry': 'HSD: 15/11/2026',
      'desc': 'Đổi 01 bắp ngọt cỡ vừa tại quầy CGV Store',
      'tag': 'ƯU ĐÃI THÁNG',
      'tagColor': Colors.orange,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
          'Ví Voucher & Coupon',
          style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // ================= 1. KHUNG NHẬP MÃ ĐỔI QUÀ =================
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Nhập mã Voucher / Giftcode',
                      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
                      prefixIcon: const Icon(Icons.confirmation_number_outlined, color: primaryRed),
                      fillColor: Colors.grey[100],
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryRed,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Mã đổi quà không hợp lệ hoặc đã hết hạn!'),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                  },
                  child: const Text('ĐỔI MÃ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                ),
              ],
            ),
          ),

          // ================= 2. TAB LỌC LOẠI ƯU ĐÃI =================
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: primaryRed,
              labelColor: primaryRed,
              unselectedLabelColor: Colors.grey[600],
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              tabs: const [
                Tab(text: 'Tất cả (2)'),
                Tab(text: 'Coupon (2)'),
                Tab(text: 'Voucher (0)'),
                Tab(text: 'eGift (0)'),
                Tab(text: 'Thẻ quà tặng (0)'),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ================= 3. DANH SÁCH VOUCHER PHONG CÁCH TICKET =================
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildVoucherList(_myVouchers), // Tất cả
                _buildVoucherList(_myVouchers.where((v) => v['type'] == 'Coupon').toList()), // Coupon
                _buildEmptyState('Voucher'), // Voucher
                _buildEmptyState('eGift'), // eGift
                _buildEmptyState('Thẻ quà tặng'), // Thẻ quà tặng
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Danh sách hiển thị các thẻ ưu đãi
  Widget _buildVoucherList(List<Map<String, dynamic>> items) {
    if (items.isEmpty) {
      return _buildEmptyState('Ưu đãi');
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildVoucherCard(item);
      },
    );
  }

  // Card thiết kế chuẩn VÉ ƯU ĐÃI (Ticket Card)
  Widget _buildVoucherCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Cột trái: Icon + Dải màu
              Container(
                width: 90,
                color: primaryRed,
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.card_giftcard, color: Colors.white, size: 36),
                    const SizedBox(height: 6),
                    Text(
                      item['type'].toString().toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ],
                ),
              ),

              // Cột phải: Thông tin Voucher
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item['title'],
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: (item['tagColor'] as Color).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              item['tag'],
                              style: TextStyle(color: item['tagColor'], fontSize: 9, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['desc'],
                        style: TextStyle(color: Colors.grey[600], fontSize: 11.5),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      const Divider(height: 1, thickness: 0.6),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item['expiry'],
                            style: TextStyle(color: Colors.grey[500], fontSize: 11, fontWeight: FontWeight.w500),
                          ),
                          InkWell(
                            onTap: () {
                              _showQrModal(context, item);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: primaryRed.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'DÙNG NGAY',
                                style: TextStyle(color: primaryRed, fontWeight: FontWeight.bold, fontSize: 11),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Hiển thị Dialog mã QR quét trực tiếp tại rạp
  void _showQrModal(BuildContext context, Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 16),
              Text(item['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 6),
              Text(item['desc'], style: TextStyle(color: Colors.grey[600], fontSize: 12), textAlign: TextAlign.center),
              const SizedBox(height: 20),

              // Mã QR Mẫu
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.qr_code_2_rounded, size: 140, color: Colors.black87),
              ),
              const SizedBox(height: 10),
              Text(
                'MÃ: ${item['code']}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'monospace', letterSpacing: 1.5),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  // Trạng thái trống
  Widget _buildEmptyState(String category) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.red[50],
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.card_giftcard_outlined,
            size: 50,
            color: primaryRed,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Chưa có $category nào',
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Text(
            'Các ưu đãi $category bạn sở hữu sẽ hiển thị tại đây để áp dụng khi đặt vé.',
            style: TextStyle(color: Colors.grey[600], fontSize: 12.5, height: 1.4),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}