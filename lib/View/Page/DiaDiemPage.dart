import 'package:flutter/material.dart';
import 'package:hue_go/View/Details/DiaDiemDetail.dart';
import 'package:hue_go/providers/user_provider.dart';
import 'package:provider/provider.dart';
import '../../providers/diadiem_provider.dart';
import '../../providers/yeuthich_provider.dart';

class DiaDiemPage extends StatefulWidget {
  const DiaDiemPage({super.key});

  @override
  State<DiaDiemPage> createState() => _DiaDiemPageState();
}

class _DiaDiemPageState extends State<DiaDiemPage> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  int _selectedCategoryIndex = 0;

  final List<Map<String, dynamic>> _categories = [
    {'id': null, 'ten': 'Tất cả'},
    {'id': 1, 'ten': 'Di tích'},
    {'id': 2, 'ten': 'Ẩm thực'},
    {'id': 3, 'ten': 'Thiên nhiên'},
    {'id': 4, 'ten': 'Vui chơi'},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<DiadiemProvider>().loadDiaDiem();

      final user = context.read<UserProvider>().getUser;
      final int? maNguoiDung = user?.maNguoiDung;

      if (maNguoiDung != null) {
        await context.read<YeuThichProvider>().loadFavorites(maNguoiDung);
      } else {
        await context.read<YeuThichProvider>().loadFavorites(1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DiadiemProvider>();
    final yeuThichProvider = context.watch<YeuThichProvider>();
    final user = context.watch<UserProvider>().getUser;
    final int? maNguoiDung = user?.maNguoiDung;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: _isSearching
            ? TextField(
          controller: _searchController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          decoration: const InputDecoration(
            hintText: 'Tìm kiếm địa điểm...',
            hintStyle: TextStyle(color: Colors.white70),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: (value) {
            context.read<DiadiemProvider>().searchDiaDiem(value);
          },
        )
            : const Text(
          'Địa điểm',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search, color: Colors.white),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  context.read<DiadiemProvider>().searchDiaDiem('');
                }
              });
            },
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // 1. Thanh danh mục chọn (Gia diện cố định luôn hiển thị phía trên)
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedCategoryIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategoryIndex = index;
                    });
                    final selectedCategoryId = _categories[index]['id'] as int?;
                    context.read<DiadiemProvider>().filterByCategoryID(selectedCategoryId);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF8E2DE2) : Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? Colors.transparent : Colors.grey[300]!,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _categories[index]['ten'].toString(),
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // 2. Nội dung bên dưới (Loading / Lỗi / Danh sách)
          Expanded(
            child: provider.isLoading
                ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF8E2DE2),
              ),
            )
                : provider.error != null
                ? Center(child: Text(provider.error!))
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: provider.diaDiem.length,
              itemBuilder: (context, index) {
                final diaDiem = provider.diaDiem[index];
                final isLiked = yeuThichProvider.isFavorite(diaDiem.maDiaDiem);

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Diadiemdetail(diaDiem: diaDiem),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            'asset/images/uploads/location/${diaDiem.anhChinh}',
                            width: 120,
                            height: 90,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: 120,
                              height: 90,
                              color: Colors.grey[300],
                              child: const Icon(Icons.image, color: Colors.grey),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      diaDiem.tenDiaDiem,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      if (maNguoiDung != null) {
                                        context
                                            .read<YeuThichProvider>()
                                            .toggleFavorite(maNguoiDung, diaDiem.maDiaDiem);
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Vui lòng đăng nhập để lưu yêu thích!'),
                                          ),
                                        );
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Icon(
                                        isLiked ? Icons.favorite : Icons.favorite_outline,
                                        color: isLiked ? Colors.redAccent : Colors.grey,
                                        size: 22,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: const [
                                  Icon(Icons.star, color: Colors.amber, size: 16),
                                  SizedBox(width: 4),
                                  Text(
                                    '4.8',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    '(126 đánh giá)',
                                    style: TextStyle(color: Colors.grey, fontSize: 11),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.location_on_outlined, color: Colors.grey, size: 14),
                                  const SizedBox(width: 2),
                                  Expanded(
                                    child: Text(
                                      diaDiem.diaChi,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                                    ),
                                  ),
                                  const Icon(Icons.near_me_outlined, color: Colors.grey, size: 12),
                                  const SizedBox(width: 2),
                                  const Text(
                                    '2 km',
                                    style: TextStyle(color: Colors.grey, fontSize: 11),
                                  ),
                                ],
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