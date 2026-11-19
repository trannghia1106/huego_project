import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'home.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {

  final String logo = 'asset/images/logo.png';
  final _formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isChecked = true;
  bool _obpassword = true;
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFC62BEF),
              Color(0xFFE538A0),
              Color(0xFFBDD5F5),
            ],
            stops: [0.0, 0.45, 1.0]
          )
        ),
        child: Align(
          alignment: Alignment(0,-0.05),
          child: SizedBox(
            height: 500,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(25)
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  Positioned(
                    top: -114,
                    left: 40,
                    right: 40,
                    child: Image.asset(logo, width: 250,),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 100),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Form(
                        key: _formkey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Email or phone"),
                            SizedBox(height: 5,),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 8
                                ),
                                filled: true,
                                fillColor: Color(0xFFF2F2F7),
                              ),
                              validator: (value){
                                if(value==null || value.isEmpty){
                                  return 'Vui lòng nhập email';
                                }
                              },
                            ),

                            SizedBox(height: 5,),
                            Text('Mât khẩu'),
                            SizedBox(height: 5,),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obpassword,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide.none
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 8
                                ),
                                filled: true,
                                fillColor: Color(0xFFF2F2F7),
                                suffixIcon: IconButton(
                                  onPressed: (){
                                    setState(() {
                                      _obpassword = !_obpassword;
                                    });
                                  },
                                  icon: Icon(
                                    _obpassword?Icons.visibility:Icons.visibility_off
                                  )
                                )
                              ),
                              validator: (value){
                                if(value==null || value.isEmpty){
                                  return 'Vui lòng nhập password';
                                }
                              },
                            ),
                            SizedBox(height: 5,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      value: isChecked,
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      visualDensity: VisualDensity(
                                        vertical: -4,
                                        horizontal: -4
                                      ),
                                      onChanged: (value){
                                        setState(() {
                                          isChecked = value!;
                                        });
                                      }
                                    ),
                                    SizedBox(width: 5,),
                                    Text('Ghi nhớ mật khẩu')
                                  ],
                                ),

                                GestureDetector(
                                  onTap: (){
                                    print('Dang ki');
                                  },
                                  child: Text('Đăng ký?',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold
                                    ),
                                  )
                                )
                              ],
                            ),
                            SizedBox(height: 10,),
                            Container(
                              child: Center(
                                child: Column(
                                  children: [
                                    ElevatedButton(
                                        onPressed: provider.isLoading
                                          ? null
                                          : () async{
                                          if(!_formkey.currentState!.validate()){
                                            return;
                                          }

                                          final success = await context.read<UserProvider>().login(
                                              _emailController.text.trim(),
                                              _passwordController.text.trim(),
                                          );
                                          if(!mounted) return;

                                          if(success){
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Home(),
                                              ),
                                            );
                                          }else{
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  context.read<UserProvider>().errorMessage ??
                                                    'Đăng nhập thất bại',
                                                ),
                                              )
                                            );
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                         backgroundColor: Color(0xFFFF7878)
                                        ),
                                        child: Text(
                                          provider.isLoading
                                            ? 'Đang đăng nhập...'
                                            : 'Đăng nhập',
                                          style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ))
                                    ),
                                    SizedBox(height: 5,),
                                    Text('OR', style: TextStyle(fontSize: 12),),
                                    SizedBox(height: 5,),
                                    ElevatedButton(
                                      onPressed: () async {
                                        final success =
                                        await context.read<UserProvider>().loginGoogle();

                                        if (!mounted) return;

                                        if (success) {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Home(),
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                context.read<UserProvider>().errorMessage ??
                                                    'Đăng nhập Google thất bại',
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFFFF7878),
                                      ),
                                      child: Text(
                                        'Đăng nhập với Google',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],

                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}
