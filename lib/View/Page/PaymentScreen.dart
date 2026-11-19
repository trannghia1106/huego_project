import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../Model/Tour.dart';
import '../../providers/user_provider.dart';
import '../../services/UrlHttp.dart';

class PaymentScreen extends StatefulWidget {
  final Tour tour;
  final DateTime selectedDate;
  final int soLuongKhach;
  final String name;
  final String email;
  final String phone;

  const PaymentScreen({
    super.key,
    required this.tour,
    required this.selectedDate,
    required this.soLuongKhach,
    required this.name,
    required this.email,
    required this.phone,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  // Thông tin ngân hàng nhận thanh toán
  final String _bankId = '970415'; // VietinBank
  final String _bankName = 'VietinBank';
  final String _accountNo = '0934791106';
  final String _accountName = 'TRAN NGHIA';

  String _formatCurrency(double amount) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    return '${formatter.format(amount)}đ';
  }

  // Tạo URL VietQR động theo số tiền và thông tin đơn hàng
  String _buildVietQrUrl(double amount, String maTour, String phone) {
    final addInfo = Uri.encodeComponent('TT TOUR HS-DN$maTour $phone');
    final formattedAmount = amount.toInt().toString();

    return 'https://img.vietqr.io/image/$_bankId-$_accountNo-compact2.png?amount=$formattedAmount&addInfo=$addInfo&accountName=$_accountName';
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã sao chép $label'),
        backgroundColor: const Color(0xFF8E2DE2),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // HÀM GỌI API TẠO ĐƠN VÀ THANH TOÁN
  Future<void> _xuLyDatTourVaThanhToan(double tongTien, int maNguoiDung) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF8E2DE2)),
      ),
    );

    final url = Uri.parse('${Urlhttp.baseUrl}/api/dat-tour');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'MaNguoiDung': maNguoiDung, // ID người dùng
          'MaTour': widget.tour.maTour,
          'TenNguoiDat': widget.name,    // Thêm Tên người đặt
          'EmailNguoiDat': widget.email,  // Thêm Email người đặt
          'SDTNguoiDat': widget.phone,    // Thêm SĐT người đặt
          'SoLuong': widget.soLuongKhach,
          'TongTien': tongTien,
          'PhuongThuc': 'VietQR',
        }),
      );

      if (mounted) Navigator.pop(context);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true && mounted) {
          _showSuccessDialog();
        } else {
          _showErrorSnackBar('Đặt tour thất bại: ${data['message']}');
        }
      } else {
        _showErrorSnackBar('Lỗi máy chủ (${response.statusCode})');
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      _showErrorSnackBar('Lỗi kết nối máy chủ: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Column(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 60),
            SizedBox(height: 10),
            Text(
              'Đặt tour thành công!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        content: const Text(
          'Cảm ơn bạn đã đặt tour. Chúng tôi sẽ kiểm tra thanh toán và liên hệ lại trong thời gian sớm nhất.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8E2DE2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: () {
                Navigator.pop(context); // Đóng Dialog
                Navigator.popUntil(context, (route) => route.isFirst); // Về màn hình chính
              },
              child: const Text(
                'VỀ TRANG CHỦ',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().getUser;
    int? maNguoiDung = user?.maNguoiDung;
    final tour = widget.tour;
    final tongTien = tour.giaTour * widget.soLuongKhach;
    final maTourFormatted = tour.maTour.toString().padLeft(2, '0');
    final noiDungChuyenKhoan = 'TT TOUR HS-DN$maTourFormatted ${widget.phone}';
    final vietQrUrl = _buildVietQrUrl(tongTien, maTourFormatted, widget.phone);

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
          'Thanh toán đơn hàng',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
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
            // 1. Progress Bar Step
            _buildStepIndicator(),
            const SizedBox(height: 20),

            // 2. Mã QR Thanh Toán
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF8E2DE2).withOpacity(0.3), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'Quét mã VietQR để thanh toán',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Sử dụng App Ngân hàng / Ví điện tử bất kỳ',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),

                  // Khung hiển thị QR
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Image.network(
                      vietQrUrl,
                      height: 260,
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const SizedBox(
                          height: 260,
                          child: Center(
                            child: CircularProgressIndicator(color: Color(0xFF8E2DE2)),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => const SizedBox(
                        height: 260,
                        child: Center(child: Text('Không thể tải mã QR')),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF8E2DE2),
                      side: const BorderSide(color: Color(0xFF8E2DE2)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Đã lưu mã QR vào thư viện ảnh'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    icon: const Icon(Icons.download_rounded, size: 18),
                    label: const Text('Lưu mã QR', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 3. Thông tin chuyển khoản thủ công
            const Text(
              'Thông tin tài khoản nhận',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
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
                  _buildCopyRow('Ngân hàng', _bankName, null),
                  const Divider(height: 20),
                  _buildCopyRow('Chủ tài khoản', _accountName, () => _copyToClipboard(_accountName, 'Tên tài khoản')),
                  const Divider(height: 20),
                  _buildCopyRow('Số tài khoản', _accountNo, () => _copyToClipboard(_accountNo, 'Số tài khoản')),
                  const Divider(height: 20),
                  _buildCopyRow(
                    'Số tiền',
                    _formatCurrency(tongTien),
                        () => _copyToClipboard(tongTien.toInt().toString(), 'Số tiền'),
                    isHighlight: true,
                  ),
                  const Divider(height: 20),
                  _buildCopyRow(
                    'Nội dung CK',
                    noiDungChuyenKhoan,
                        () => _copyToClipboard(noiDungChuyenKhoan, 'Nội dung chuyển khoản'),
                    isHighlight: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 4. Lưu ý thanh toán
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.shade300),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.amber, size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Vui lòng nhập chính xác Nội dung chuyển khoản để hệ thống tự động xác nhận đơn đặt tour.',
                      style: TextStyle(fontSize: 12, color: Colors.amber.shade900),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 5. Nút Hoàn tất
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                ),
                onPressed: () {
                  // KÍCH HOẠT LƯU ĐƠN HÀNG VÀO CSDL QUA API
                  _xuLyDatTourVaThanhToan(tongTien, maNguoiDung!);
                },
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF8E2DE2), Color(0xFFEC4899)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child: const Text(
                      'TÔI ĐÃ CHUYỂN KHOẢN',
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

  Widget _buildCopyRow(String label, String value, VoidCallback? onCopy, {bool isHighlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
        const SizedBox(width: 10),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isHighlight ? const Color(0xFF8E2DE2) : Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (onCopy != null) ...[
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: onCopy,
                  child: const Icon(Icons.copy, size: 16, color: Color(0xFF8E2DE2)),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStepCircle('1', 'Chọn tour', isDone: true),
        _buildStepLine(isDone: true),
        _buildStepCircle('2', 'Xác nhận', isDone: true),
        _buildStepLine(isDone: true),
        _buildStepCircle('3', 'Thanh toán', isActive: true),
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
            child: isDone && !isActive
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : Text(
              step,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: textColor,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
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
}