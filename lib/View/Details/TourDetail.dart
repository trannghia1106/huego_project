import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Model/ChiTietTour.dart';
import '../../Model/Tour.dart';
import '../../Model/ChiTietTour.dart';
import '../Page/BookingScreen.dart';

class TourDetail extends StatefulWidget {
  final Tour tour;

  const TourDetail({super.key, required this.tour});

  @override
  State<TourDetail> createState() => _TourDetailState();
}

class _TourDetailState extends State<TourDetail> {
  int _currentImageIndex = 0;

  String _formatCurrency(double amount) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    return '${formatter.format(amount)}đ';
  }

  @override
  Widget build(BuildContext context) {
    final tour = widget.tour;
    final mediaList = tour.mediaTour;
    final chiTietList = tour.chiTietTour;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. Content Scroll
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Slider Ảnh
                Stack(
                  children: [
                    SizedBox(
                      height: 280,
                      child: mediaList.isNotEmpty
                          ? PageView.builder(
                        itemCount: mediaList.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentImageIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Image.asset(
                            'asset/images/uploads/tour/${mediaList[index].duongDan}',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.image, size: 50, color: Colors.grey),
                            ),
                          );
                        },
                      )
                          : Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.image, size: 50, color: Colors.grey),
                      ),
                    ),
                    if (mediaList.length > 1)
                      Positioned(
                        bottom: 16,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            mediaList.length,
                                (index) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              width: _currentImageIndex == index ? 18 : 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: _currentImageIndex == index ? Colors.white : Colors.white54,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),

                // Thông tin chi tiết
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tour.tenTour,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          _buildInfoBadge(Icons.access_time, tour.thoiLuong),
                          const SizedBox(width: 8),
                          _buildInfoBadge(Icons.people_outline, '${tour.soCho} chỗ'),
                          const SizedBox(width: 8),
                          _buildInfoBadge(Icons.star, '4.8', iconColor: Colors.amber),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 12),

                      if (tour.lichKhoiHanh != null && tour.lichKhoiHanh!.isNotEmpty) ...[
                        Row(
                          children: [
                            const Icon(Icons.calendar_today_outlined, color: Color(0xFF8E2DE2), size: 18),
                            const SizedBox(width: 8),
                            Text(
                              'Khởi hành: ${tour.lichKhoiHanh}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],

                      const Text(
                        'Mô tả chuyến đi',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        tour.moTa.isNotEmpty ? tour.moTa : 'Chưa có thông tin mô tả.',
                        style: TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.5),
                      ),
                      const SizedBox(height: 24),

                      // 📌 Phần Timeline Lịch trình Chi Tiết
                      if (chiTietList.isNotEmpty) ...[
                        const Text(
                          'Lịch trình chi tiết',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: chiTietList.length,
                          itemBuilder: (context, index) {
                            final item = chiTietList[index];
                            final isLast = index == chiTietList.length - 1;
                            return _buildTimelineItem(item, isLast);
                          },
                        ),
                      ],

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 2. Nút Quay về
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.4),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),

          // 3. Bottom Bar
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Tổng chi phí', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        const SizedBox(height: 2),
                        Text(
                          _formatCurrency(tour.giaTour),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFEC4899),
                          ),
                        ),
                      ],
                    ),
                    Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookingScreen(tour: tour),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                            ),
                          ),
                          child: const Text(
                            'Đặt Tour ngay',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Item Timeline hiển thị Hoạt động + Tên địa điểm
  Widget _buildTimelineItem(ChiTietTour detail, bool isLast) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 65,
            child: Text(
              detail.thoiGian,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Color(0xFF8E2DE2),
              ),
            ),
          ),
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Color(0xFF8E2DE2),
                  shape: BoxShape.circle,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: Colors.grey[300],
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    detail.hoatDong,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  if (detail.tenDiaDiem != null && detail.tenDiaDiem!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 14, color: Color(0xFF8E2DE2)),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            detail.tenDiaDiem!,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF8E2DE2),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (detail.ghiChu != null && detail.ghiChu!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      detail.ghiChu!,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBadge(IconData icon, String label, {Color iconColor = Colors.grey}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}