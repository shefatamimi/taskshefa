
import 'package:flutter/material.dart';

import '../service/auth_service.dart';

class RegesterScreen extends StatefulWidget {
  const RegesterScreen({super.key});

  @override
  State<RegesterScreen> createState() => _RegesterScreenState();

}

class _RegesterScreenState extends State<RegesterScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  final AuthService _authService = AuthService();

  Future<void>regester() async {
    try {
      await _authService.register(
        email: _emailController.text,
        password: _passwordController.text,
        name: _nameController.text,
        phoneNumber: _phoneNumberController.text,
      );
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration successful')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blueGrey,
        title: const Text(
          'Register',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body:

      SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(height: 25),
        
                  const Icon(
                    Icons.person_add_alt_1_rounded,
                    size: 120,
                    color: Colors.blueGrey,
                  ),
        
                  const SizedBox(height: 10),
        
        
        
                  const SizedBox(height: 5),
        
                  const Text(
                    'Create Your Account',
        
                    style: TextStyle(fontSize: 20,
        
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey),
                  ),
        
                  const SizedBox(height: 30),
        
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
        
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'User Name',
                      labelText: 'User Name',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
        
                  const SizedBox(height: 20),
        
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
                      ),
                    ),
                  ),
        
                  const SizedBox(height: 20),
        
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
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: const Icon(Icons.visibility),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
        
                  const SizedBox(height: 20),
        
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                    controller: _phoneNumberController,
                    decoration: InputDecoration(
                      hintText: 'Phone Number',
                      labelText: 'Phone Number',
                      prefixIcon: const Icon(Icons.phone),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
        
                  const SizedBox(height: 30),
        
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()){
                        await regester();}
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(250, 50),
                      backgroundColor: Colors.blueGrey,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Colors.black38),
                      ),
                    ),
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
        
                  const SizedBox(height: 20),
        
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
        
                    children: [
                      Text("Already have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
        
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}