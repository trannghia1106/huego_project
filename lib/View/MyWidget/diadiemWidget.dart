import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Model/DiaDiem.dart';
import '../../providers/diadiem_provider.dart';
import '../Details/DiaDiemDetail.dart';

class DiaDiemWidget extends StatefulWidget {
  const DiaDiemWidget({super.key});

  @override
  State<DiaDiemWidget> createState() => _DiaDiemWidgetState();
}

class _DiaDiemWidgetState extends State<DiaDiemWidget> {
  @override
  void initState() {
    super.initState();
    // Tự động gọi hàm lấy dữ liệu ngay khi Widget được khởi tạo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<DiadiemProvider>(context, listen: false);
      // Gọi hàm fetch/get của bạn nếu danh sách đang rỗng (Đổi tên hàm fetchDiaDiem tương ứng với Provider của bạn)
      if (provider.diaDiem.isEmpty) {
        // provider.fetchDiaDiem();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final diaDiemProvider = context.watch<DiadiemProvider>();
    final List<Diadiem> topLocations = diaDiemProvider.diaDiem.take(4).toList();

    // 1. Trường hợp đang tải dữ liệu
    if (diaDiemProvider.isLoading) {
      return const SizedBox(
        height: 150,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    // 2. Trường hợp danh sách rỗng (Hiển thị thông báo thay vì SizedBox.shrink để debug)
    if (topLocations.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Text(
          'Chưa có dữ liệu địa điểm',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    // 3. Hiển thị danh sách khi đã có dữ liệu
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Địa điểm nổi bật',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(topLocations.length, (index) {
              final item = topLocations[index];

              // Xử lý đường dẫn ảnh an toàn
              String imagePath = item.anhChinh;
              if (!imagePath.startsWith('assets/') && !imagePath.startsWith('asset/')) {
                imagePath = 'asset/images/uploads/location/$imagePath'; // Đổi đúng đường dẫn trong pubspec.yaml
              }

              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.44,
                  height: 165,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Diadiemdetail(diaDiem: item),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Anh đại diện
                          SizedBox(
                            height: 95,
                            width: double.infinity,
                            child: Image.asset(
                              imagePath,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.broken_image, color: Colors.grey),
                              ),
                            ),
                          ),

                          // Thông tin
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.tenDiaDiem,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: const [
                                        Text('4.8', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                        Icon(Icons.star_rate_rounded, color: Colors.amber, size: 14),
                                      ],
                                    ),
                                    Row(
                                      children: const [
                                        Icon(Icons.location_on_outlined, size: 12, color: Colors.grey),
                                        Text('2km', style: TextStyle(fontSize: 11, color: Colors.grey)),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        )
      ],
    );
  }
}