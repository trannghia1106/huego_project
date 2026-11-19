import 'package:flutter/material.dart';
import '../../Model/TinTuc.dart';
import '../../services/tintuc_service.dart';
import '../Details/TinTucDetail.dart';

class SuKienWidget extends StatefulWidget {
  const SuKienWidget({super.key});

  @override
  State<SuKienWidget> createState() => _SuKienWidgetState();
}

class _SuKienWidgetState extends State<SuKienWidget> {
  List<TinTucModel> _listSuKien = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSuKien();
  }

  void _loadSuKien() async {
    try {
      // Gọi đúng hàm fetchTinTuc() có sẵn trong TinTucService của bạn
      final allData = await TinTucService.fetchTinTuc(loai: 'Tất cả');

      if (mounted) {
        setState(() {
          // Lọc các bài có loại chứa chữ "sự kiện"
          _listSuKien = allData
              .where((item) =>
          item.loai.trim().toLowerCase().contains('sự kiện') ||
              item.loai.trim().toLowerCase().contains('su kien'))
              .take(5) // Lấy 5 bài mới nhất
              .toList();

          // Trường hợp trong CSDL không có bài nào ghi nhãn "Sự kiện", lấy tạm 5 bài mới nhất
          if (_listSuKien.isEmpty) {
            _listSuKien = allData.take(5).toList();
          }

          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text(
            'Tin tức mới',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),

        _isLoading
            ? const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: CircularProgressIndicator(),
          ),
        )
            : _listSuKien.isEmpty
            ? const Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'Chưa có sự kiện nào',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        )
            : ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 0),
          itemCount: _listSuKien.length,
          itemBuilder: (context, index) {
            final item = _listSuKien[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TinTucDetail(tinTuc: item),
                    ),
                  );
                },
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                      ),
                      child: Image.asset(
                        'asset/images/uploads/news/${item.hinhAnh}',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 100,
                          height: 100,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.image, color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.tieuDe,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                height: 1.25,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.calendar_today_rounded,
                                    size: 13, color: Color(0xFF6C5CE7)),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    item.thoiGianToChuc.isNotEmpty
                                        ? item.thoiGianToChuc
                                        : item.ngayDang,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 11.5,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            if (item.diaDiemToChuc != null &&
                                item.diaDiemToChuc!.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.location_on_outlined,
                                      size: 13, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      item.diaDiemToChuc!,
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 11.5,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}