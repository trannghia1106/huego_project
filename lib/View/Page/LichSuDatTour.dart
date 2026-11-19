import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../services/UrlHttp.dart'; // Import file chứa baseUrl của bạn

class Lichsudattour extends StatefulWidget {
  final int maNguoiDung;

  const Lichsudattour({super.key, required this.maNguoiDung});

  @override
  State<Lichsudattour> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<Lichsudattour> {
  late Future<List<dynamic>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _historyFuture = fetchBookingHistory();
  }

  Future<List<dynamic>> fetchBookingHistory() async {
    final url = Uri.parse('${Urlhttp.baseUrl}/api/dat-tour/lich-su/${widget.maNguoiDung}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == true) {
        return data['data'];
      } else {
        throw Exception(data['message'] ?? 'Lỗi tải dữ liệu');
      }
    } else {
      throw Exception('Lỗi kết nối máy chủ (${response.statusCode})');
    }
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    return '${formatter.format(amount)}đ';
  }

  String _formatDate(String dateStr) {
    try {
      final dateTime = DateTime.parse(dateStr);
      return DateFormat('dd/MM/yyyy - HH:mm').format(dateTime);
    } catch (_) {
      return dateStr;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Đã xác nhận':
        return Colors.green;
      case 'Chờ xác nhận':
      case 'Chờ thanh toán':
        return Colors.orange;
      case 'Đã hủy':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
            ),
          ),
        ),
        title: const Text(
          'Lịch sử đặt tour',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _historyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF8E2DE2)));
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Lỗi: ${snapshot.error}', style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => setState(() => _historyFuture = fetchBookingHistory()),
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          final historyList = snapshot.data ?? [];

          if (historyList.isEmpty) {
            return const Center(
              child: Text('Bạn chưa có đơn đặt tour nào.', style: TextStyle(color: Colors.grey, fontSize: 16)),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _historyFuture = fetchBookingHistory();
              });
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: historyList.length,
              itemBuilder: (context, index) {
                final item = historyList[index];
                final trangThai = item['TrangThaiDatTour'] ?? 'Chờ xác nhận';
                final double tongTien = double.tryParse(item['TongTien'].toString()) ?? 0;

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Card: Mã đơn & Trạng thái
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Đơn #${item['MaDatTour']}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getStatusColor(trangThai).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                trangThai,
                                style: TextStyle(
                                  color: _getStatusColor(trangThai),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Body Card: Chi tiết Tour
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['TenTour'] ?? 'Tên tour không có',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            _buildInfoRow(Icons.calendar_today, 'Ngày đặt: ${_formatDate(item['NgayDat'])}'),
                            const SizedBox(height: 4),
                            _buildInfoRow(Icons.person_outline, 'Người đặt: ${item['TenNguoiDat'] ?? 'N/A'} (${item['SDTNguoiDat'] ?? ''})'),
                            const SizedBox(height: 4),
                            _buildInfoRow(Icons.group_outlined, 'Số lượng: ${item['SoLuong']} khách'),
                            const Divider(height: 24),

                            // Footer Card: Tổng tiền
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Tổng thanh toán:', style: TextStyle(color: Colors.grey, fontSize: 13)),
                                Text(
                                  _formatCurrency(tongTien),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF8E2DE2),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 13, color: Colors.grey[800]),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}