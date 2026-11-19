import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'UrlHttp.dart';
import '../Model/User.dart';

class UserService {
  final String baseUrl = '${Urlhttp.baseUrl}';

  // Login thường
  Future<User?> login(String emailphone, String matkhau) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/nguoidung/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'emailphone': emailphone,
        'matkhau': matkhau,
      }),
    );

    print('STATUS: ${response.statusCode}');
    print('BODY: ${response.body}');

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['success'] == true) {
      return User.fromJson(data['data']);
    }

    return null;
  }

  // Login Google
  Future<User?> loginGoogle() async {
    // Firebase Google Sign-In
    final GoogleSignIn googleSignIn = GoogleSignIn.instance;

    // Khởi tạo Google Sign-In
    await googleSignIn.initialize(
      serverClientId:
      '82248309532-m6f6ekaog08iokm2q5mpgrtn44rafmuc.apps.googleusercontent.com',
    );

    // Mở màn hình chọn tài khoản Google
    final GoogleSignInAccount googleUser =
    await googleSignIn.authenticate();
    print('GOOGLE NAME: ${googleUser.displayName}');
    print('GOOGLE EMAIL: ${googleUser.email}');
    // Lấy thông tin xác thực
    final googleAuth = googleUser.authentication;

    // Tạo credential cho Firebase
    final credential = firebase_auth.GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    // Đăng nhập Firebase
    final firebaseCredential =
    await firebase_auth.FirebaseAuth.instance
        .signInWithCredential(credential);

    final firebaseUser = firebaseCredential.user;

    if (firebaseUser == null) {
      return null;
    }

    print('Google email: ${firebaseUser.email}');
    print('Google name: ${firebaseUser.displayName}');

    // Gửi thông tin Google lên Node.js
    final response = await http.post(
      Uri.parse('$baseUrl/api/nguoidung/google-login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': firebaseUser.email,
        'hoTen': firebaseUser.displayName,
        'anhDaiDien': firebaseUser.photoURL,
      }),
    );

    print('GOOGLE STATUS: ${response.statusCode}');
    print('GOOGLE BODY: ${response.body}');

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['success'] == true) {
      return User.fromJson(data['data']);
    }

    return null;
  }
}