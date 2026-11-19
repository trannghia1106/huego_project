import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hue_go/View/Details/TinTucDetail.dart';
import '../../Model/TinTuc.dart';
import '../../services/tintuc_service.dart';

class TinHotWidget extends StatefulWidget {
  const TinHotWidget({super.key});

  @override
  State<TinHotWidget> createState() => _TinHotWidgetState();
}

class _TinHotWidgetState extends State<TinHotWidget> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;
  List<TinTucModel> _listTinHot = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTinHot();
  }

  void _loadTinHot() async {
    try {
      final data = await TinTucService.fetchTinHot();
      if (mounted) {
        setState(() {
          _listTinHot = data;
          _isLoading = false;
        });
        _startAutoSlide();
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _startAutoSlide() {
    if (_listTinHot.isEmpty) return;
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < _listTinHot.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        height: 160,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_listTinHot.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemCount: _listTinHot.length,
              itemBuilder: (context, index) {
                final item = _listTinHot[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context)=> TinTucDetail(tinTuc: item)
                      )
                    );
                  },
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        'asset/images/uploads/news/${item.hinhAnh}',
                        fit: BoxFit.fill,
                        errorBuilder: (_, __, ___) => Container(color: Colors.grey),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 24,
                        left: 16,
                        right: 16,
                        child: Text(
                          item.tieuDe,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.local_fire_department, color: Colors.white, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'TIN HOT HUẾ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              right: 16,
              child: Row(
                children: List.generate(
                  _listTinHot.length,
                      (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: _currentPage == index ? 16 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: _currentPage == index ? Colors.white : Colors.white70,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}