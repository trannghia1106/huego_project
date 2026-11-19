import 'package:flutter/material.dart';

// 1. Model dữ liệu Cẩm nang
class CamNangItem {
  final String id;
  final String tieuDe;
  final String danhMuc;
  final String moTaNgan;
  final String noiDung;
  final String anhUrl;
  final String thoiGianDoc;

  CamNangItem({
    required this.id,
    required this.tieuDe,
    required this.danhMuc,
    required this.moTaNgan,
    required this.noiDung,
    required this.anhUrl,
    required this.thoiGianDoc,
  });
}

// 2. Dữ liệu cứng (Hardcoded Data)
final List<CamNangItem> danhSachCamNang = [
  CamNangItem(
    id: '1',
    tieuDe: 'Thời điểm đẹp nhất đi du lịch Cố đô Huế',
    danhMuc: 'Thời điểm',
    moTaNgan: 'Từ tháng 1 đến tháng 4 là mùa đẹp nhất để trải nghiệm không khí dịu mát của xứ Huế.',
    noiDung: 'Huế có hai mùa rõ rệt là mùa mưa và mùa khô.\n\n'
        '• Từ tháng 1 đến tháng 4: Thời tiết xuân dịu mát, cây nối chồi non, rất thích hợp để dạo chơi Đại Nội và các lăng tẩm.\n'
        '• Từ tháng 5 đến tháng 8: Mùa hè rực rỡ, thích hợp đi biển Thuận An, Lăng Cô và ngắm hoàng hôn trên sông Hương.\n'
        '• Từ tháng 9 đến tháng 12: Mùa mưa Huế mang nét buồn trầm mặc rất riêng, thích hợp thưởng thức trà chiều và các món ăn nóng hổi.',
    anhUrl: 'https://media.vietravel.com/images/Content/dia-diem-du-lich-hue-1169.jpg',
    thoiGianDoc: '3 phút đọc',
  ),
  CamNangItem(
    id: '2',
    tieuDe: 'Top 5 món ngon chuẩn vị Cố đô không thể bỏ qua',
    danhMuc: 'Ẩm thực',
    moTaNgan: 'Khám phá ẩm thực phong phú từ Bún bò, Bánh bèo, Nấm tràm đến Bánh ép Huế.',
    noiDung: 'Ẩm thực Huế nổi tiếng bởi sự tinh tế và hương vị đậm đà:\n\n'
        '1. Bún Bố Huế: Nước dùng đậm đà thơm mùi sả, mắm ruốc, ăn kèm huyết, giò heo.\n'
        '2. Bánh bèo - Nậm - Lọc: Bộ ba bánh truyền thống dẻo thơm, ăn cùng nước mắm ớt cay ngọt.\n'
        '3. Cơm Hến: Món ăn dân dã nhưng chuẩn vị cay nồng, giòn rụm của mắm ruốc và tóp mỡ.\n'
        '4. Chè Hẻm: Đủ loại chè tinh tế, đặc biệt là chè bột lọc bọc heo quay kỳ lạ mà cuốn hút.',
    anhUrl: 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?q=80&w=800',
    thoiGianDoc: '5 phút đọc',
  ),
  CamNangItem(
    id: '3',
    tieuDe: 'Lịch trình du lịch Huế 3 ngày 2 đêm tự túc',
    danhMuc: 'Lịch trình',
    moTaNgan: 'Gợi ý chi tiết lịch trình tham quan Đại Nội, các Lăng Tẩm và trải nghiệm nghe Ca Huế.',
    noiDung: 'Lịch trình tối ưu cho chuyến đi 3N2Đ:\n\n'
        '• Ngày 1: Check-in homestay - Tham quan Đại Nội - Dạo chợ Đông Ba - Bến thuyền Tòa Khâm nghe Ca Huế sông Hương.\n'
        '• Ngày 2: Lăng Minh Mạng - Lăng Khải Định - Chùa Thiên Mụ - Ngắm hoàng hôn ở Đồi Vọng Cảnh.\n'
        '• Ngày 3: Khám phá trường Quốc Học - Thưởng thức cà phê muối - Mua quà lưu niệm và kết thúc chuyến đi.',
    anhUrl: 'https://images.unsplash.com/photo-1583417319070-4a69db38a482?q=80&w=800',
    thoiGianDoc: '7 phút đọc',
  ),
  CamNangItem(
    id: '4',
    tieuDe: 'Phương tiện di chuyển phổ biến tại Huế',
    danhMuc: 'Di chuyển',
    moTaNgan: 'Hướng dẫn chọn xe máy, xích xilo, taxi hoặc xe bus hai tầng khi du lịch.',
    noiDung: 'Cách di chuyển tiện lợi nhất ở Huế:\n\n'
        '• Thêu xe máy: Giá từ 100k - 150k/ngày, phù hợp đi các lăng tẩm ở xa.\n'
        '• Xe Xích lô: Trải nghiệm thư thái dạo quanh các con phố cổ gần Đại Nội.\n'
        '• Xe Bus 2 tầng: Tuyến xe dạo quanh các điểm du lịch nổi tiếng trong trung tâm thành phố.',
    anhUrl: 'https://khamphahue.com.vn/Portals/0/Medias/Nam2022/T9/Khamphahue_PhuongTienDiLaiOHue.jpg',
    thoiGianDoc: '4 phút đọc',
  ),
];

// 3. Màn hình chính Cẩm nang
class CamNangScreen extends StatefulWidget {
  const CamNangScreen({super.key});

  @override
  State<CamNangScreen> createState() => _CamNangScreenState();
}

class _CamNangScreenState extends State<CamNangScreen> {
  String _selectedCategory = 'Tất cả';
  String _searchQuery = '';

  final List<String> _categories = [
    'Tất cả',
    'Thời điểm',
    'Ẩm thực',
    'Lịch trình',
    'Di chuyển',
  ];

  @override
  Widget build(BuildContext context) {
    // Lọc danh sách theo tìm kiếm và danh mục
    final filteredList = danhSachCamNang.where((item) {
      final matchesCategory = _selectedCategory == 'Tất cả' || item.danhMuc == _selectedCategory;
      final matchesSearch = item.tieuDe.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.moTaNgan.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

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
          'Cẩm Nang Du Lịch Huế',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Khung Tìm kiếm & Danh mục
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              children: [
                // Thanh tìm kiếm
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    onChanged: (value) => setState(() => _searchQuery = value),
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm bí kíp, kinh nghiệm...',
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF8E2DE2)),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      filled: true,
                      fillColor: const Color(0xFFF1F3F5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Danh mục Filter Horizontal
                SizedBox(
                  height: 38,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final isSelected = category == _selectedCategory;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedCategory = category),
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF8E2DE2) : const Color(0xFFF1F3F5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Danh sách Cẩm nang
          Expanded(
            child: filteredList.isEmpty
                ? const Center(child: Text('Không tìm thấy bài viết nào.'))
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final item = filteredList[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChiTietCamNangScreen(item: item),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hình ảnh bài viết
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          child: Image.network(
                            item.anhUrl,
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(height: 160, color: Colors.grey[300], child: const Icon(Icons.image)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF8E2DE2).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      item.danhMuc,
                                      style: const TextStyle(
                                          color: Color(0xFF8E2DE2),
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Text(
                                    item.thoiGianDoc,
                                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                item.tieuDe,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                item.moTaNgan,
                                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// 4. Màn hình Chi tiết bài viết Cẩm nang
class ChiTietCamNangScreen extends StatelessWidget {
  final CamNangItem item;

  const ChiTietCamNangScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                item.anhUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(color: Colors.grey[300], child: const Icon(Icons.image)),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Chip(
                        label: Text(item.danhMuc, style: const TextStyle(color: Colors.white, fontSize: 12)),
                        backgroundColor: const Color(0xFF8E2DE2),
                      ),
                      const SizedBox(width: 10),
                      Text(item.thoiGianDoc, style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item.tieuDe,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const Divider(height: 30),
                  Text(
                    item.noiDung,
                    style: const TextStyle(fontSize: 15, height: 1.6, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}