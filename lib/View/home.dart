import 'package:flutter/material.dart';
import 'package:hue_go/View/Account.dart';
import 'package:hue_go/View/ChatAI.dart';
import 'package:hue_go/View/Favorite.dart';
import 'package:hue_go/View/MyWidget/danhmucWidget.dart';
import 'package:hue_go/View/MyWidget/diadiemWidget.dart';
import 'package:hue_go/View/MyWidget/sukienWidget.dart';
import 'package:hue_go/View/MapPage.dart';
import 'package:provider/provider.dart';

import '../providers/diadiem_provider.dart';
import 'MyWidget/appbarWidget.dart';
import 'MyWidget/TinHotWidget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Map<String, dynamic>> bottomitems = [
    {'title': 'Trang chủ', 'icon': Icons.home_outlined, 'page' : Home(), 'isCenter': false},
    {'title': 'Bản đồ', 'icon': Icons.pin_drop_outlined, 'page' : MapPage(), 'isCenter': false},
    {'title': 'Chat AI', 'icon': Icons.message_outlined, 'page' : ChatAI(), 'isCenter': true},
    {'title': 'Yêu thích', 'icon': Icons.favorite_outline, 'page' :  Favorite(), 'isCenter': false},
    {'title': 'Cá nhân', 'icon': Icons.account_circle_outlined, 'page' : Account(), 'isCenter': false},
  ];
  @override
  void initState() {
    super.initState();
    // Gọi hàm lấy danh sách địa điểm ngay khi màn hình khởi tạo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DiadiemProvider>(context, listen: false).loadDiaDiem();
      // ⚠️ LƯU Ý: Thay 'getDiaDiem()' thành tên hàm gọi dữ liệu thực tế trong DiadiemProvider của bạn
      // Ví dụ: fetchDiaDiem(), loadData(), getAll(),...
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(bottomitems.length, (index){
            if(bottomitems[index]['isCenter']){
              return SizedBox(
                width: 70,
                height: 70,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: -30,
                      left: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_)=> bottomitems[index]['page'])
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.blue.shade300,
                              radius: 28,
                              child: Icon(bottomitems[index]['icon'], size: 25,),
                            ),
                            SizedBox(height: 5,),
                            Text(bottomitems[index]['title'])
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
            return GestureDetector(
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_)=> bottomitems[index]['page'])
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(bottomitems[index]['icon'], size: 25, color: Colors.black54,),
                  Text(bottomitems[index]['title'], style: TextStyle(color: Colors.black87),)
                ],
              ),
            );
          })
        )
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              AppBarWidget(),
              SizedBox(height: 20,),
              //Thời tiết
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child:  Container(
                  child: Column(
                    children: [
                      TinHotWidget(),
                      SizedBox(height: 20,),
                      DanhMucWidget(),
                      SizedBox(height: 20,),
                      DiaDiemWidget(),
                      SizedBox(height: 20,),
                      SuKienWidget(),
                    ],
                  ),
                ),
              )
            ],
          ),
        
        ),
      ),

    );
  }
}
