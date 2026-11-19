import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  int _selectedFilter = 0;
  final List<String> _filters = ['Địa điểm', 'Ẩm thực', 'Tour', 'Lưu trú'];

  // Tọa độ các điểm ghim mẫu tại Huế
  final List<Map<String, dynamic>> _locations = [
    {
      'title': 'Đại Nội Huế',
      'point': const LatLng(16.4688, 107.5796),
      'image': 'asset/images/uploads/location/dainoi.jpg',
      'rating': '4.8',
      'reviews': '126',
      'distance': '2 km',
    },
    {
      'title': 'Chùa Thiên Mụ',
      'point': const LatLng(16.4532, 107.5452),
      'image': 'asset/images/uploads/location/thienmu.jpg',
      'rating': '4.7',
      'reviews': '98',
      'distance': '4.5 km',
    },
    {
      'title': 'Cầu Tràng Tiền',
      'point': const LatLng(16.4678, 107.5947),
      'image': 'asset/images/uploads/location/trangtien.jpg',
      'rating': '4.9',
      'reviews': '210',
      'distance': '1.2 km',
    },
  ];

  late Map<String, dynamic> _selectedLocation;

  @override
  void initState() {
    super.initState();
    _selectedLocation = _locations[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Bản đồ',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
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
      body: Stack(
        children: [
          // 1. Layer Bản đồ màu sáng
          FlutterMap(
            options: MapOptions(
              initialCenter: const LatLng(16.4688, 107.5796),
              initialZoom: 14.0,
            ),
            children: [
              TileLayer(
                // Sử dụng CartoDB Positron để có bản đồ màu sáng sạch đẹp như Google Maps
                urlTemplate: 'https://a.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.hue_go',
              ),

              // 2. Các điểm ghim (Markers)
              MarkerLayer(
                markers: _locations.map((loc) {
                  final isSelected = _selectedLocation['title'] == loc['title'];
                  return Marker(
                    point: loc['point'],
                    width: 40,
                    height: 40,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedLocation = loc;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF8E2DE2) : const Color(0xFF9EBEF1),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: const [
                            BoxShadow(color: Colors.black26, blurRadius: 4)
                          ],
                        ),
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),

          // 3. Thanh Filter Chips phía trên
          Positioned(
            top: MediaQuery.of(context).padding.top + 56 + 10,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _filters.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedFilter == index;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedFilter = index),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF8E2DE2) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 4)
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _filters[index],
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
          ),

          // 4. Các nút thao tác định vị bên phải
          Positioned(
            right: 16,
            bottom: 120,
            child: Column(
              children: [
                _buildMapButton(Icons.navigation_outlined),
                const SizedBox(height: 10),
                _buildMapButton(Icons.my_location),
              ],
            ),
          ),

          // 5. Thẻ hiển thị địa điểm (Card Preview) phía dưới
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      _selectedLocation['image'],
                      width: 80,
                      height: 70,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 80,
                        height: 70,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image, color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _selectedLocation['title'],
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '${_selectedLocation['rating']} (${_selectedLocation['reviews']} đánh giá)',
                              style: const TextStyle(fontSize: 11, color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, color: Colors.grey, size: 14),
                            const SizedBox(width: 2),
                            Text(
                              _selectedLocation['distance'],
                              style: const TextStyle(fontSize: 11, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapButton(IconData icon) {
    return Container(
      width: 44,
      height: 44,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Icon(icon, color: Colors.black87, size: 20),
    );
  }
}