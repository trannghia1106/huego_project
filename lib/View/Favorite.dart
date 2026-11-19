import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/diadiem_provider.dart';
import '../providers/yeuthich_provider.dart';
import '../Model/DiaDiem.dart';
import '../providers/user_provider.dart';
import 'Details/DiaDiemDetail.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  int _selectedTab = 0; // 0: Địa điểm, 1: Tour, 2: Tin tức
  bool _isEditing = false;
  int? _maNguoiDung; // Đổi sang nullable để tránh lỗi LateInitializationError

  @override
  void initState() {
    super.initState();

    // Load dữ liệu khi vào trang
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<UserProvider>().getUser;
      if (user != null) {
        setState(() {
          _maNguoiDung = user.maNguoiDung;
        });
        context.read<DiadiemProvider>().loadDiaDiem();
        context.read<YeuThichProvider>().loadFavorites(_maNguoiDung!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final diaDiemProvider = context.watch<DiadiemProvider>();
    final yeuThichProvider = context.watch<YeuThichProvider>();

    // Lọc ra danh sách Địa Điểm mà người dùng ĐÃ BẤM YÊU THÍCH
    final List<Diadiem> favDiaDiemList = diaDiemProvider.diaDiem.where((item) {
      return item.maDiaDiem != null &&
          yeuThichProvider.isFavorite(item.maDiaDiem!);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Stack(
        children: [
          // Background Gradient Header
          Container(
            height: 180,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Top Navigation Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(

                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        'Yêu thích',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                    ],
                  ),
                ),

                // Main Content Frame
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        _buildCategoryTabs(),
                        const SizedBox(height: 16),

                        // Render danh sách theo Tab đang chọn
                        Expanded(
                          child: (diaDiemProvider.isLoading || yeuThichProvider.isLoading)
                              ? const Center(child: CircularProgressIndicator())
                              : _buildTabContent(favDiaDiemList, yeuThichProvider),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Phân chia danh sách hiển thị theo Tab
  Widget _buildTabContent(List<Diadiem> favList, YeuThichProvider yeuThichProvider) {
    if (_selectedTab == 0) {
      if (favList.isEmpty) {
        return const Center(
          child: Text(
            'Chưa có địa điểm yêu thích nào',
            style: TextStyle(color: Colors.grey, fontSize: 15),
          ),
        );
      }
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: favList.length,
        itemBuilder: (context, index) {
          final item = favList[index];
          return _buildFavoriteItem(item, yeuThichProvider);
        },
      );
    } else if (_selectedTab == 1) {
      return const Center(child: Text('Chưa có Tour yêu thích'));
    } else {
      return const Center(child: Text('Chưa có Tin tức yêu thích'));
    }
  }

  // Segmented Tabs
  Widget _buildCategoryTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F7),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          _buildTabButton(0, 'Địa điểm'),
          _buildTabButton(1, 'Tour'),
          _buildTabButton(2, 'Tin tức'),
        ],
      ),
    );
  }

  Widget _buildTabButton(int index, String title) {
    bool isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF7C3AED) : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  // Item Địa Điểm Yêu Thích lấy từ Model Diadiem
  Widget _buildFavoriteItem(Diadiem item, YeuThichProvider yeuThichProvider) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Diadiemdetail(diaDiem: item),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        color: Colors.transparent, // Đảm bảo bấm vào khoảng trắng vẫn nhận event
        child: Row(
          children: [
            // Hình ảnh địa điểm
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'asset/images/uploads/location/${item.anhChinh}',
                width: 110,
                height: 75,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 110,
                  height: 75,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Thông tin địa điểm
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.tenDiaDiem,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 18, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        '4.8',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, color: Colors.grey, size: 14),
                      const SizedBox(width: 2),
                      Expanded( // 👈 Bọc Expanded ở đây để địa chỉ dài không làm lỗi Yellow-Black Striped Box (Overflow)
                        child: Text(
                          item.diaChi,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Nút xóa/bỏ thích
            IconButton(
              icon: Icon(
                _isEditing ? Icons.remove_circle_outline : Icons.favorite,
                color: _isEditing ? Colors.red : const Color(0xFFFF4B72),
                size: 26,
              ),
              onPressed: () {
                if (item.maDiaDiem != null && _maNguoiDung != null) {
                  yeuThichProvider.toggleFavorite(
                    _maNguoiDung!,
                    item.maDiaDiem!,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}