import 'package:flutter/material.dart';
import '../../Model/TinTuc.dart';

class TinTucDetail extends StatelessWidget {
  final TinTucModel tinTuc;

  const TinTucDetail({super.key, required this.tinTuc});

  @override
  Widget build(BuildContext context) {
    bool hasThoiGian = tinTuc.thoiGianToChuc.isNotEmpty;
    bool hasDiaDiem = tinTuc.diaDiemToChuc != null && tinTuc.diaDiemToChuc!.isNotEmpty;
    bool hasEventInfo = hasThoiGian || hasDiaDiem;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Hình ảnh + Nút Back
              Stack(
                children: [
                  Image.asset(
                    'asset/images/uploads/news/${tinTuc.hinhAnh}',
                    width: double.infinity,
                    height: 230,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 230,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.image, size: 50, color: Colors.grey),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: CircleAvatar(
                      backgroundColor: Colors.black.withOpacity(0.3),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
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
                    // 2. Nhãn Loại tin & Ngày đăng
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6C5CE7),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            tinTuc.loai,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey),
                            const SizedBox(width: 6),
                            Text(
                              tinTuc.ngayDang,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 3. Tiêu đề
                    Text(
                      tinTuc.tieuDe,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        height: 1.35,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 4. Thông tin Tác giả
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 18,
                          backgroundColor: Color(0xFF6C5CE7),
                          child: Text(
                            'HueGo',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        RichText(
                          text: const TextSpan(
                            text: 'HueGo ',
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                            children: [
                              TextSpan(
                                text: '• Ban biên tập',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // 5. Nội dung bài viết
                    Text(
                      tinTuc.noiDung,
                      style: const TextStyle(
                        fontSize: 14.5,
                        height: 1.6,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 6. Khung Thông tin chi tiết (Lấy chuẩn theo CSDL)
                    if (hasEventInfo) ...[
                      _buildSectionTitle('Thông tin chi tiết'),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            if (hasThoiGian) ...[
                              _buildInfoRow(
                                Icons.calendar_today_rounded,
                                'Thời gian: ${tinTuc.thoiGianToChuc}',
                              ),
                            ],
                            if (hasThoiGian && hasDiaDiem) const SizedBox(height: 12),
                            if (hasDiaDiem) ...[
                              _buildInfoRow(
                                Icons.location_on_outlined,
                                'Địa điểm: ${tinTuc.diaDiemToChuc}',
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: const Color(0xFF6C5CE7),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15.5,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF6C5CE7)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13.5,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}