import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Model/Tour.dart';
import 'OrderTour.dart';

class BookingScreen extends StatefulWidget {
  final Tour tour;

  const BookingScreen({super.key, required this.tour});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();

  int _soLuongKhach = 1;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));

  // 📌 Để trống để người dùng tự nhập
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    return '${formatter.format(amount)}đ';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 180)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF8E2DE2),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tour = widget.tour;
    final tongTienTour = tour.giaTour * _soLuongKhach;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header Ảnh + Appbar
              Stack(
                children: [
                  SizedBox(
                    height: 240,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                      child: Image.asset(
                        'asset/images/uploads/tour/${tour.anhChinh}',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.image, size: 50, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.black.withOpacity(0.3),
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back, color: Colors.white),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                          const Text(
                            'Đặt tour',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.black.withOpacity(0.3),
                            child: IconButton(
                              icon: const Icon(Icons.favorite_border, color: Colors.white),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 2. Thông tin tóm tắt Tour
                    Text(
                      tour.tenTour,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 18),
                        const SizedBox(width: 4),
                        const Text('4.8', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF8E2DE2))),
                        Text(' (32 đánh giá)', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, color: Colors.grey[600], size: 16),
                        const SizedBox(width: 4),
                        Text('Huế, Thừa Thiên Huế • ${tour.thoiLuong}', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                      ],
                    ),
                    const SizedBox(height: 12),

                    _buildTagBadge(Icons.directions_car_outlined, 'Điểm đón: TP. Huế'),
                    _buildTagBadge(Icons.people_outline, 'Số chỗ còn nhận: ${tour.soCho} khách'),
                    _buildTagBadge(Icons.verified_user_outlined, 'Hủy miễn phí trước 24h'),
                    const SizedBox(height: 20),

                    // 3. Chọn ngày khởi hành
                    const Text('Chọn ngày khởi hành', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () => _selectDate(context),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF8E2DE2).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.calendar_month, color: Color(0xFF8E2DE2)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Ngày khởi hành', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                                  const SizedBox(height: 2),
                                  Text(
                                    DateFormat('dd/MM/yyyy').format(_selectedDate),
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF8E2DE2), fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 4. Số lượng khách
                    const Text('Số lượng khách', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.person, color: Color(0xFF8E2DE2)),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Số người tham gia',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove, size: 18),
                                  onPressed: _soLuongKhach > 1
                                      ? () => setState(() => _soLuongKhach--)
                                      : null,
                                ),
                                Text(
                                  '$_soLuongKhach',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add, size: 18, color: Color(0xFF8E2DE2)),
                                  onPressed: _soLuongKhach < tour.soCho
                                      ? () => setState(() => _soLuongKhach++)
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 5. Thông tin người đặt (Form Tự Nhập)
                    const Text('Thông tin người đặt', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        children: [
                          _buildInputField(
                            icon: Icons.person_outline,
                            controller: _nameController,
                            hint: 'Nhập họ và tên',
                            validatorMsg: 'Vui lòng nhập họ và tên',
                          ),
                          const Divider(height: 1),
                          _buildInputField(
                            icon: Icons.email_outlined,
                            controller: _emailController,
                            hint: 'Nhập địa chỉ email',
                            keyboardType: TextInputType.emailAddress,
                            validatorMsg: 'Vui lòng nhập email',
                          ),
                          const Divider(height: 1),
                          _buildInputField(
                            icon: Icons.phone_outlined,
                            controller: _phoneController,
                            hint: 'Nhập số điện thoại',
                            keyboardType: TextInputType.phone,
                            validatorMsg: 'Vui lòng nhập số điện thoại',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 6. Chi tiết giá
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
                          _buildPriceRow('Khách x $_soLuongKhach', _formatCurrency(tongTienTour)),
                          const SizedBox(height: 10),
                          const Divider(),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Tổng cộng', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              Text(
                                _formatCurrency(tongTienTour),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF8E2DE2),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // 7. Nút Đặt Tour Ngay
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Ordertour(
                                  tour: widget.tour,
                                  selectedDate: _selectedDate,
                                  soLuongKhach: _soLuongKhach,
                                  name: _nameController.text,
                                  email: _emailController.text,
                                  phone: _phoneController.text,
                                ),
                              ),
                            );
                          }
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
                              'ĐẶT TOUR NGAY',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTagBadge(IconData icon, String label) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF8E2DE2)),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  // Widget Ô nhập liệu có validation
  Widget _buildInputField({
    required IconData icon,
    required TextEditingController controller,
    required String hint,
    required String validatorMsg,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return validatorMsg;
          }
          return null;
        },
        decoration: InputDecoration(
          icon: Icon(icon, color: const Color(0xFF8E2DE2), size: 20),
          hintText: hint,
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          errorStyle: const TextStyle(fontSize: 11),
        ),
      ),
    );
  }

  Widget _buildPriceRow(String title, String price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
        Text(price, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      ],
    );
  }
}