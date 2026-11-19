import 'package:flutter/material.dart';
import 'package:hue_go/providers/user_provider.dart';
import 'package:provider/provider.dart';

class AppBarWidget extends StatefulWidget {
  const AppBarWidget({super.key});

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  final bool _checknotice = true;
  final _searchControl = TextEditingController();

  @override
  void dispose() {
    _searchControl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();
    final user = provider.getUser;
    final String? avatar = user?.anhDaiDien;
    final int? isGG = user?.dangNhapGG;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFCB30E0),
            Color(0xFFB968E7),

          ],
          stops: [0.2, 0.8],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Row Welcome + Notification + Avatar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Welcome to Hue!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'IntelOneMono',
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => print('thông báo'),
                        child: Icon(
                          _checknotice
                              ? Icons.notifications_rounded
                              : Icons.notifications_active_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () => print('avatar'),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.white24,
                            backgroundImage: (avatar != null && avatar.isNotEmpty)
                                ? (isGG == 1
                                ? NetworkImage(avatar) as ImageProvider
                                : AssetImage('asset/images/uploads/avatar/$avatar'))
                                : null,
                            child: (avatar == null || avatar.isEmpty)
                                ? const Icon(Icons.person, color: Colors.white, size: 20)
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Ô tìm kiếm
              SizedBox(
                height: 44,
                child: TextFormField(
                  readOnly: true,
                  controller: _searchControl,
                  style: const TextStyle(fontSize: 14, color: Color(0xFF5B2C83)),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: const Color(0xFF9EBEF1).withOpacity(0.85),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    hintText: 'Bạn muốn đi đâu ở Huế?',
                    hintStyle: const TextStyle(
                      color: Color(0xFF5B2C83),
                      fontSize: 14,
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: Color(0xFF5B2C83),
                      size: 22,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}