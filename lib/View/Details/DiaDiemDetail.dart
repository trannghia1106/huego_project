import 'package:flutter/material.dart';
import '../../Model/DiaDiem.dart';

class Diadiemdetail extends StatefulWidget {
  final Diadiem diaDiem;

  const Diadiemdetail({super.key, required this.diaDiem});

  @override
  State<Diadiemdetail> createState() => _DiadiemdetailState();
}

class _DiadiemdetailState extends State<Diadiemdetail> {
  int _currentImageIndex = 0;

  // Hàm chuyển tên file thành đường dẫn Asset
  String _getAssetPath(String fileName) {
    String cleanName = fileName.trim();
    if (cleanName.isEmpty) return 'asset/images/logo.png';
    return 'asset/images/uploads/location/$cleanName';
  }

  @override
  Widget build(BuildContext context) {
    final diaDiem = widget.diaDiem;
    final List mediaList = diaDiem.dsMedia;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. Nội dung cuộn chính
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner ảnh + Nút quay lại + Indicator đếm ảnh
                Stack(
                  children: [
                    Container(
                      height: 280,
                      width: double.infinity,
                      // decoration: const BoxDecoration(
                      //   gradient: LinearGradient(
                      //     colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                      //     begin: Alignment.topCenter,
                      //     end: Alignment.bottomCenter,
                      //   ),
                      // ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(24),
                        ),
                        child: mediaList.isEmpty
                            ? Image.asset(
                          'asset/images/logo.png',
                          fit: BoxFit.cover,
                        )
                            : PageView.builder(
                          itemCount: mediaList.length,
                          onPageChanged: (index) {
                            setState(() {
                              _currentImageIndex = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            final media = mediaList[index];
                            final assetPath = _getAssetPath(media.duongDan);

                            return Image.asset(
                              assetPath,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300],
                                  child: const Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      size: 40,
                                      color: Colors.grey,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),

                    // Nút quay lại
                    Positioned(
                      top: 40,
                      left: 16,
                      child: CircleAvatar(
                        backgroundColor: Colors.black38,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),

                    // Indicator đếm số ảnh động (vd: 1/2)
                    if (mediaList.isNotEmpty)
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.camera_alt, color: Colors.white, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                '${_currentImageIndex + 1}/${mediaList.length}',
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      )
                  ],
                ),

                // Nội dung chi tiết địa điểm
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tên & Tag phân loại
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              diaDiem.tenDiaDiem,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0E6FF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Địa điểm',
                              style: TextStyle(
                                color: Color(0xFF8E2DE2),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Rating & Địa chỉ
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 18),
                              SizedBox(width: 4),
                              Text(
                                '4.8',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Icon(Icons.location_on_outlined, color: Colors.grey, size: 16),
                                const SizedBox(width: 2),
                                Flexible(
                                  child: Text(
                                    diaDiem.diaChi,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Giới thiệu
                      const Text(
                        'Giới thiệu',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        diaDiem.moTa,
                        style: const TextStyle(color: Colors.black87, height: 1.5, fontSize: 14),
                      ),
                      const SizedBox(height: 16),

                      // Khung Giờ mở cửa & Giá vé
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Row(
                          children: [
                            // Giờ mở cửa
                            Expanded(
                              child: Row(
                                children: [
                                  const Icon(Icons.access_time, color: Colors.amber),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('Giờ mở cửa', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                        Text(
                                          (diaDiem.gioDongCua == null || diaDiem.gioDongCua.toString() == 'null' || diaDiem.gioDongCua.toString().isEmpty)
                                              ? '${diaDiem.gioMoCua} - Tự do'
                                              : '${diaDiem.gioMoCua} - ${diaDiem.gioDongCua}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(height: 30, width: 1, color: Colors.grey[300]),
                            // Giá vé
                            Expanded(
                              child: Row(
                                children: [
                                  const SizedBox(width: 12),
                                  const Icon(Icons.confirmation_number_outlined, color: Colors.green),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Giá vé', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                      Text(
                                        diaDiem.giaVe == 0
                                            ? 'Miễn phí'
                                            : '${diaDiem.giaVe.toStringAsFixed(0)} VNĐ',
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Tiện ích / Biểu tượng
                      const Text(
                        'Dịch vụ tiện ích',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildUtilityItem(Icons.wc, 'WC'),
                          _buildUtilityItem(Icons.local_parking, 'Gửi xe'),
                          _buildUtilityItem(Icons.camera_alt_outlined, 'Chụp ảnh'),
                          _buildUtilityItem(Icons.restaurant_outlined, 'Ăn uống'),
                        ],
                      ),
                      const SizedBox(height: 100), // Khoảng trống cho nút Chỉ đường
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 2. Nút Chỉ đường cố định phía dưới (Bottom Bar)
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.navigation, color: Colors.white),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8E2DE2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 5,
                ),
                onPressed: () {
                  // Tọa độ địa điểm: diaDiem.kinhDo, diaDiem.viDo
                },
                label: const Text(
                  'Chỉ đường',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // Widget con hiển thị Icon tiện ích
  Widget _buildUtilityItem(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: Colors.grey[700], size: 20),
    );
  }
}