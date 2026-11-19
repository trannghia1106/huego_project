import 'package:flutter/material.dart';
import 'package:hue_go/View/Page/CamNangDLPage.dart';
import 'package:hue_go/View/Page/DiaDiemPage.dart';
import 'package:hue_go/View/Page/LichTrinhPage.dart';
import 'package:hue_go/View/Page/TinTucScreen.dart';
import 'package:hue_go/View/Page/TourPage.dart';

class DanhMucWidget extends StatefulWidget {
  const DanhMucWidget({super.key});

  @override
  State<DanhMucWidget> createState() => _DanhMucWidgetState();
}

class _DanhMucWidgetState extends State<DanhMucWidget> {
  final List<Map<String, dynamic>> categories = [
    {'title': 'Địa điểm', 'icon': Icons.location_on_outlined, 'bgrcolor': Colors.blue.shade50, 'forecolor': Colors.blue, 'page': const DiaDiemPage() },
    {'title': 'Tour', 'icon': Icons.map_outlined, 'bgrcolor': Colors.purple.shade50, 'forecolor': Colors.purple, 'page': TourPage() },
    {'title': 'Sự kiện', 'icon': Icons.event_outlined, 'bgrcolor': Colors.green.shade50, 'forecolor': Colors.green, 'page': TinTucScreen() },
    {'title': 'Cẩm nang', 'icon': Icons.menu_book_outlined, 'bgrcolor': Colors.yellow.shade50, 'forecolor': Colors.yellow, 'page': CamNangScreen() },
    {'title': 'Lịch trình', 'icon': Icons.assignment, 'bgrcolor': Colors.red.shade50, 'forecolor': Colors.red, 'page': LichTrinhPage() },
  ];
  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Danh mục',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16
          ),
        ),
        SizedBox(height: 10,),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(categories.length, (index){
              return Padding(
                padding: EdgeInsetsGeometry.only(right: 13),
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => categories[index]['page'],
                      )
                    );
                  },
                  child: Container(
                    width: 80,
                    height: 75,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: categories[index]['bgrcolor'],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          categories[index]['icon'],
                          color: categories[index]['forecolor'],
                          size: 35,
                        ),
                        Text(
                          categories[index]['title'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13
                          ),
                        )
                      ],
                    ),
                  )
                ),
              );
            }),
          ),
        )
      ],
    );
  }
}
