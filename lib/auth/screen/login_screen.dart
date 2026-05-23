
import 'package:flutter/material.dart';
import 'package:task_shefa/auth/screen/register_screen.dart';

import '../service/auth_service.dart';
import 'home_screen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;


  final AuthService _authService = AuthService();

  Future<void> login(String text, String text1) async {
    try {
      await _authService.login(
        _emailController.text,
        _passwordController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login successful')),
      );
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
        ),
        body:
        Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Center(
                child: Column(
                    children: [
                      const SizedBox(height:10),
                      const Icon(Icons.checklist, size: 120,color: Colors.blueGrey,),
                      const SizedBox(height:15),
                      const Text('Welcome Back!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5,),
                      const Text('login to your account', style: TextStyle(fontSize: 16,)),
                      const SizedBox(height: 44,),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(color: Colors.black),

                          ),
                        ),
                      ),
                      const SizedBox(height: 20,),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },

                        obscureText: _obscureText,
                        controller: _passwordController,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          labelText: 'Password',

                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(color: Colors.black),

                          ),
                          suffixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              child: Icon(_obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off)),



                        ),

                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 215,top: 7),
                        child: InkWell(child: Text('Forgot Password?',
                            style: TextStyle(color: Colors.blueGrey, fontSize: 12, fontWeight: FontWeight.bold))
                        ),

                      ),
                      const SizedBox(height: 30,),
                      ElevatedButton(onPressed: (){
                        if (_formKey.currentState!.validate()){
                          login(
                            _emailController.text,
                            _passwordController.text,
                          );
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
                        }
                      }, child: const Text('Login',
                          style: TextStyle(fontSize: 37, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            minimumSize:  Size(250, 30),
                            backgroundColor: Colors.blueGrey,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(

                              borderRadius: BorderRadius.circular(10),
                            ),
                          )
                      ),


                      const SizedBox(height: 20,),
                      Row(
                        children: [
                          Expanded(child: Divider(color: Colors.grey[400],)),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text('or', style: TextStyle(color: Colors.grey),),
                          ),
                          Expanded(child: Divider(color: Colors.grey[400],)),
                        ],
                      ),
                      const SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(

                            style: ElevatedButton.styleFrom(
                                minimumSize:  Size(250, 50),
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black87,

                                shape: RoundedRectangleBorder(

                                    borderRadius: BorderRadius.circular(10),
                                    side: const BorderSide(color: Colors.black45)
                                )
                            ),
                            onPressed: () {},
                            icon: Image.asset(
                              'assets/google.png',
                              width: 30,
                              height: 30,
                            ),
                            label: const Text(
                              'Login With Google',
                              style: TextStyle(fontSize: 17),

                            ),
                          ),

                        ],
                      ),
                      SizedBox(height: 25,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Don\'t have an account?', style: TextStyle(color: Colors.grey[700]),),
                          SizedBox(width: 10,),
                          InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> const RegesterScreen()));
                            },
                            child: Text('Sign Up', style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold),),
                          )
                        ],)



                    ]

                ),


              ),
            ),
          ),
        )
    );

  }
}
