import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../Model/User.dart';
import '../services/user_service.dart';

class UserProvider extends ChangeNotifier {
  final UserService _userService = UserService();

  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get issLoggedIn => _user != null;
  User? get getUser => _user;

  Future<bool> login(String emailphone, String matkhau) async{
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try{
      final user = await _userService.login(emailphone, matkhau);

      if(user!= null){
        _user = user;
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _errorMessage = 'Email/Số điện thoại hoặc mật khẩu không đúng';
      _isLoading = false;
      notifyListeners();
      return false;
    }catch(e){
      _errorMessage = 'Không thể kết nối đến máy chủ';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> loginGoogle() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _userService.loginGoogle();

      if (user != null) {
        _user = user;
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _errorMessage = 'Đăng nhập Google thất bại';
      _isLoading = false;
      notifyListeners();
      return false;

    } catch (e) {
      print('LỖI GOOGLE LOGIN: $e');

      _errorMessage = 'Đăng nhập Google thất bại';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _user = null;
    _errorMessage = null;
    notifyListeners();
  }

}