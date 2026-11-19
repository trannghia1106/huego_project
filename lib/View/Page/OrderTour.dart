import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Model/Tour.dart';
import 'PaymentScreen.dart';

class Ordertour extends StatefulWidget {
  final Tour tour;
  final DateTime selectedDate;
  final int soLuongKhach;
  final String name;
  final String email;
  final String phone;

  const Ordertour({
    super.key,
    required this.tour,
    required this.selectedDate,
    required this.soLuongKhach,
    required this.name,
    required this.email,
    required this.phone,
  });

  @override
  State<Ordertour> createState() => _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<Ordertour> {
  bool _isAgreed = true;

  String _formatCurrency(double amount) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    return '${formatter.format(amount)}đ';
  }

  // Hàm tạo Link VietQR chuẩn
  String _buildVietQrUrl(double amount, String maTour, String phone) {
    const bankId = '970415';
    const accountNo = '0934791106';
    const accountName = 'TRAN_NGHIA';
    final addInfo = Uri.encodeComponent('TT_TOUR_HS_DN${maTour}_$phone');
    final formattedAmount = amount.toInt().toString();

    return 'https://img.vietqr.io/image/$bankId-$accountNo-compact2.png?amount=$formattedAmount&addInfo=$addInfo&accountName=$accountName';
  }

  // Modal hiển thị mã QR Thanh toán
  void _showQrPaymentModal(BuildContext context, double tongTien, String qrUrl) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Thanh toán qua VietQR',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Sử dụng App Ngân hàng hoặc Ví điện tử để quét mã',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),

            // Ảnh Mã QR
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF8E2DE2).withOpacity(0.3), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Image.network(
                qrUrl,
                height: 280,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const SizedBox(
                    height: 280,
                    child: Center(child: CircularProgressIndicator(color: Color(0xFF8E2DE2))),
                  );
                },
                errorBuilder: (context, error, stackTrace) => const SizedBox(
                  height: 280,
                  child: Center(child: Text('Không thể tải mã QR VietQR')),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Thông tin tài khoản
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildQrInfoRow('Chủ tài khoản:', 'TRAN NGHIA'),
                  const SizedBox(height: 6),
                  _buildQrInfoRow('Số tài khoản:', '0934791106'),
                  const SizedBox(height: 6),
                  _buildQrInfoRow('Số tiền:', _formatCurrency(tongTien), isHighlight: true),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Nút Xác nhận đã chuyển khoản
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8E2DE2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Xác nhận đặt tour thành công! Vui lòng chờ kiểm tra giao dịch.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: const Text(
                  'XÁC NHẬN ĐÃ CHUYỂN KHOẢN',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildQrInfoRow(String title, String value, {bool isHighlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isHighlight ? const Color(0xFF8E2DE2) : Colors.black87,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final tour = widget.tour;
    final tongTien = tour.giaTour * widget.soLuongKhach;
    final vietQrUrl = _buildVietQrUrl(tongTien, tour.maTour.toString().padLeft(2, '0'), widget.phone);

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
        title: const Text('Xác nhận đặt tour', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Step Progress Bar
            _buildStepIndicator(),
            const SizedBox(height: 20),

            // 2. Card Tour Tóm tắt
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'asset/images/uploads/tour/${tour.anhChinh}',
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 90, height: 90, color: Colors.grey[300], child: const Icon(Icons.image),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tour.tenTour,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 14),
                            const SizedBox(width: 2),
                            const Text('4.8', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF8E2DE2))),
                            Text(' (32 đánh giá)', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.access_time, size: 12, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(tour.thoiLuong, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF8E2DE2).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Mã tour: HS-DN${tour.maTour.toString().padLeft(2, '0')}',
                            style: const TextStyle(color: Color(0xFF8E2DE2), fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 3. Thông tin đặt tour (Đã bỏ parameter 'vi_VN' gây lỗi)
            const Text('Thông tin đặt tour', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  _buildInfoRow(
                    Icons.calendar_month,
                    'Ngày khởi hành',
                    DateFormat('dd/MM/yyyy').format(widget.selectedDate),
                    isHighlighted: true,
                  ),
                  const Divider(height: 20),
                  _buildInfoRow(
                    Icons.people_outline,
                    'Số lượng khách',
                    '${widget.soLuongKhach} khách',
                  ),
                  const Divider(height: 20),
                  _buildInfoRow(Icons.flag_outlined, 'Điểm đón', 'TP. Huế'),
                  const Divider(height: 20),
                  _buildInfoRow(Icons.access_time, 'Thời gian', tour.thoiLuong),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 4. Thông tin người đặt
            const Text('Thông tin người đặt', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  _buildContactRow(Icons.person, widget.name),
                  const Divider(height: 20),
                  _buildContactRow(Icons.email, widget.email),
                  const Divider(height: 20),
                  _buildContactRow(Icons.phone, widget.phone),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 5. Chi tiết giá
            const Text('Chi tiết giá', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  _buildPriceRow('Khách x ${widget.soLuongKhach}', _formatCurrency(tongTien), isRed: true),
                  const SizedBox(height: 8),
                  _buildPriceRow('Phí dịch vụ', '0đ'),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Tổng cộng', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      Text(
                        _formatCurrency(tongTien),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF8E2DE2)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 6. Phương thức thanh toán VietQR
            const Text('Phương thức thanh toán', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF8E2DE2), width: 1.5),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8E2DE2).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.qr_code_scanner, color: Color(0xFF8E2DE2), size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Chuyển khoản VietQR',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Quét mã QR bằng App Ngân hàng / Ví điện tử',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.check_circle, color: Color(0xFF8E2DE2)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 7. Checkbox Điều khoản
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: _isAgreed,
                    activeColor: const Color(0xFF8E2DE2),
                    onChanged: (val) => setState(() => _isAgreed = val ?? false),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: RichText(
                    text: const TextSpan(
                      text: 'Tôi đã đọc và đồng ý với ',
                      style: TextStyle(color: Colors.black87, fontSize: 12),
                      children: [
                        TextSpan(
                          text: 'Chính sách hủy tour',
                          style: TextStyle(color: Color(0xFF8E2DE2), fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: ' và '),
                        TextSpan(
                          text: 'Điều khoản dịch vụ',
                          style: TextStyle(color: Color(0xFF8E2DE2), fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 8. Nút Tiến hành thanh toán
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                ),
                onPressed: _isAgreed
                  ? () {
                    Navigator.push(
                      context,
                          MaterialPageRoute(
                          builder: (context) => PaymentScreen(
                          tour: widget.tour,
                          selectedDate: widget.selectedDate,
                          soLuongKhach: widget.soLuongKhach,
                          name: widget.name,
                          email: widget.email,
                          phone: widget.phone,
                          ),
                        ),
                      );
                  }
              : null,
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: _isAgreed
                        ? const LinearGradient(
                      colors: [Color(0xFF8E2DE2), Color(0xFFEC4899)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    )
                        : const LinearGradient(colors: [Colors.grey, Colors.grey]),
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child: const Text(
                      'TIẾN HÀNH THANH TOÁN',
                      style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Helper Widgets
  Widget _buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStepCircle('1', 'Chọn tour', isDone: true),
        _buildStepLine(isDone: true),
        _buildStepCircle('2', 'Xác nhận', isActive: true),
        _buildStepLine(isDone: false),
        _buildStepCircle('3', 'Thanh toán', isActive: false),
      ],
    );
  }

  Widget _buildStepCircle(String step, String label, {bool isDone = false, bool isActive = false}) {
    Color circleColor = Colors.grey.shade300;
    Color textColor = Colors.grey;

    if (isDone || isActive) {
      circleColor = const Color(0xFF8E2DE2);
      textColor = const Color(0xFF8E2DE2);
    }

    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(color: circleColor, shape: BoxShape.circle),
          child: Center(
            child: Text(
              step,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 11, color: textColor, fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }

  Widget _buildStepLine({required bool isDone}) {
    return Container(
      width: 40,
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: isDone ? const Color(0xFF8E2DE2) : Colors.grey.shade300,
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value, {bool isHighlighted = false}) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF8E2DE2), size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isHighlighted ? const Color(0xFF8E2DE2) : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactRow(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF8E2DE2), size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        ),
        Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[400]),
      ],
    );
  }

  Widget _buildPriceRow(String title, String price, {bool isRed = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
        Text(
          price,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: isRed ? const Color(0xFFEC4899) : Colors.black87,
          ),
        ),
      ],
    );
  }
}