import 'package:flutter/material.dart';

class AdminRevenueReportPage extends StatefulWidget {
  const AdminRevenueReportPage({super.key});

  @override
  State<AdminRevenueReportPage> createState() => _AdminRevenueReportPageState();
}

class _AdminRevenueReportPageState extends State<AdminRevenueReportPage> {
  DateTime _fromDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _toDate = DateTime.now();
  String _reportType = 'Tháng';

  int _totalTickets = 0;
  double _totalRevenue = 0;
  bool _hasCalculated = false;

  // Hàm hỗ trợ định dạng số phân cách bằng dấu chấm (130500000 -> 130.500.000)
  String _formatNumber(num number) {
    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    String mathFunc(Match match) => '${match[1]}.';
    return number.toStringAsFixed(0).replaceAllMapped(reg, mathFunc);
  }

  void _pickDate(bool isFrom) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isFrom ? _fromDate : _toDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          _fromDate = picked;
        } else {
          _toDate = picked;
        }
      });
    }
  }

  void _calculateReport() {
    setState(() {
      _hasCalculated = true;
      _totalTickets = 1450;
      _totalRevenue = 130500000;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BM17: Báo Cáo Doanh Thu', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                        'BÁO CÁO DOANH THU',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    _buildDateRow('Từ ngày', _fromDate, () => _pickDate(true)),
                    _buildDateRow('Đến ngày', _toDate, () => _pickDate(false)),
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(top: BorderSide(color: Color(0xFFCCCCCC))),
                        color: Color(0xFFFFF8F6),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 120,
                            padding: const EdgeInsets.all(10),
                            child: const Text('Loại thống kê', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 14)),
                          ),
                          const VerticalDivider(width: 1, color: Color(0xFFCCCCCC)),
                          Expanded(
                            child: Row(
                              children: [
                                Radio<String>(
                                  value: 'Ngày',
                                  activeColor: const Color(0xFFD3432B),
                                  groupValue: _reportType,
                                  onChanged: (val) => setState(() => _reportType = val!),
                                ),
                                const Text('Ngày', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
                                Radio<String>(
                                  value: 'Tháng',
                                  activeColor: const Color(0xFFD3432B),
                                  groupValue: _reportType,
                                  onChanged: (val) => setState(() => _reportType = val!),
                                ),
                                const Text('Tháng', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
                                Radio<String>(
                                  value: 'Năm',
                                  activeColor: const Color(0xFFD3432B),
                                  groupValue: _reportType,
                                  onChanged: (val) => setState(() => _reportType = val!),
                                ),
                                const Text('Năm', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Định dạng số lượng vé (1.450 vé)
                    _buildResultRow('Tổng số vé bán:', _hasCalculated ? '${_formatNumber(_totalTickets)} vé' : ''),
                    
                    // Định dạng số tiền (130.500.000 VNĐ)
                    _buildResultRow('Tổng doanh thu:', _hasCalculated ? '${_formatNumber(_totalRevenue)} VNĐ' : ''),
                    
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(top: BorderSide(color: Color(0xFFD3432B))),
                        color: Color(0xFFFBE9E7),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: const BoxDecoration(
                                border: Border(right: BorderSide(color: Color(0xFFD3432B))),
                              ),
                              child: TextButton(
                                onPressed: _calculateReport,
                                child: const Text('[XEM BÁO CÁO]', style: TextStyle(color: Color(0xFFD3432B), fontWeight: FontWeight.bold, fontSize: 13)),
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Đang xuất file Excel...')),
                                );
                              },
                              child: const Text('[XUẤT EXCEL]', style: TextStyle(color: Color(0xFFD3432B), fontWeight: FontWeight.bold, fontSize: 13)),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateRow(String label, DateTime date, VoidCallback onTap) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFCCCCCC))),
        color: Color(0xFFFFF8F6),
      ),
      child: Row(
        children: [
          Container(
            width: 120,
            padding: const EdgeInsets.all(10),
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 14)),
          ),
          const VerticalDivider(width: 1, color: Color(0xFFCCCCCC)),
          Expanded(
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "${date.day}/${date.month}/${date.year}",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFCCCCCC))),
        color: Color(0xFFFFF8F6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 14)),
          if (value.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                value,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFFD3432B)),
              ),
            ),
        ],
      ),
    );
  }
}