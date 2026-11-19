import 'package:flutter/material.dart';
import 'package:hue_go/View/login.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'Favorite.dart';
import 'Page/LichSuDatTour.dart'; // Import trang Yêu thích của bạn

class Account extends StatelessWidget {
  const Account({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().getUser;
    String? avatar = user?.anhDaiDien;
    int? isGG = user?.dangNhapGG;
    int? maNguoiDung = user?.maNguoiDung;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Stack(
        children: [
          // 1. Background Gradient phía trên Header
          Container(
            height: 220,
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
                // 2. AppBar custom (Nút back & Nút Setting)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        'Cá nhân',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.settings_outlined, color: Colors.white),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),

                // 3. Thông tin Avatar + Tên User
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 34,
                          backgroundImage: isGG == 1
                            ? NetworkImage('${avatar}')
                            : AssetImage('asset/images/uploads/avatar/${avatar}')
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.hoTen ?? '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user?.email ?? 'nguyenvana@gmail.com',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 4. Khung bo tròn chứa danh sách Menu tính năng
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: ListView(
                      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                      children: [
                        _buildMenuItem(
                          icon: Icons.person_outline,
                          title: 'Thông tin cá nhân',
                          onTap: () {},
                        ),
                        _buildMenuItem(
                          icon: Icons.calendar_today_outlined,
                          title: 'Lịch sử đặt tour',
                          onTap: () {

                            if (maNguoiDung != null) {
                              // 2. Dùng Navigator.push thay vì pushReplacement
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Lichsudattour(maNguoiDung: maNguoiDung),
                                ),
                              );
                            }
                          },
                        ),
                        _buildMenuItem(
                          icon: Icons.subtitles_outlined,
                          title: 'Lịch sử thanh toán',
                          onTap: () {
                          },
                        ),

                        // 👈 Bấm mở sang màn hình Yêu thích của tôi
                        _buildMenuItem(
                          icon: Icons.favorite_border,
                          title: 'Yêu thích của tôi',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const Favorite()),
                            );
                          },
                        ),

                        _buildMenuItem(
                          icon: Icons.notifications_none,
                          title: 'Thông báo',
                          onTap: () {},
                        ),
                        _buildMenuItem(
                          icon: Icons.language,
                          title: 'Ngôn ngữ',
                          trailingText: 'Tiếng Việt',
                          onTap: () {},
                        ),
                        _buildMenuItem(
                          icon: Icons.logout,
                          title: 'Đăng xuất',
                          textColor: Colors.black87,
                          onTap: () {
                              context.read<UserProvider>().logout();
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context)=> const login()),
                                  (route) => false,
                              );
                          },
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

  // Widget dùng chung để vẽ từng dòng Menu
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? trailingText,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      leading: Icon(icon, color: Colors.grey[700], size: 22),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? Colors.black87,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Text(
              trailingText,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        ],
      ),
      onTap: onTap,
    );
  }
}