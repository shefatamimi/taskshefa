import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_shefa/users/models/user_models.dart';
import 'package:task_shefa/users/service/user_service.dart';

class EditProfil extends StatefulWidget {
  const EditProfil({super.key});

  @override
  State<EditProfil> createState() => _EditProfilState();
}

class _EditProfilState extends State<EditProfil> {
  final TextEditingController _emailController =
  TextEditingController();

  final TextEditingController _passwordController =
  TextEditingController();

  final TextEditingController _confirmPasswordController =
  TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final auth = FirebaseAuth.instance;

  late final user = auth.currentUser;

  final UserService userService = UserService();

  UserModel? userModel;

  late String userId;

  Future<void> loadUser() async {
    final userModel = await userService.getUser(userId);

    if (!mounted) return;

    setState(() {
      this.userModel = userModel;
    });
  }

  @override
  void initState() {
    super.initState();

    final user = auth.currentUser;

    if (user == null) return;

    userId = user.uid;

    loadUser();

    _emailController.text = user.email ?? '';
    _passwordController.text =  '*********';
    _confirmPasswordController.text = '*********';
  }

  Future<void> updateProfile(UserModel user) async {
    final user = auth.currentUser;

    if (user == null) return;

    final email = _emailController.text;

    final password = _passwordController.text;

    final confirmPassword =
        _confirmPasswordController.text;

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Passwords do not match',
          ),
        ),
      );

      return;
    }

    try {
      if (password.isNotEmpty) {
        await user.updatePassword(password);
      }

      if (email.isNotEmpty) {
        await user.verifyBeforeUpdateEmail(
          email,
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Profile updated successfully',
          ),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Failed to update profile',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
      ),

      body: Form(

        key: _formKey,

        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
            CrossAxisAlignment.start,


            children: [
              Center(
                heightFactor: 1.5,

                child: CircleAvatar(

                  radius: 80,
                 child:  Icon(
                    Icons.person,
                    size: 120,
                    color: Colors.blueGrey,
                          )

                ),
              ),


              const Padding(
                padding:
                EdgeInsets.symmetric(
                  horizontal: 10,
                ),

                child: Text(
                  'Email',

                  style: TextStyle(
                    fontSize: 17,
                    color:
                    Colors.blueGrey,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 5),

              Padding(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 10,
                ),

                child: TextFormField(
                  controller:
                  _emailController,

                  validator:
                      (value) {
                    if (value!
                        .isEmpty) {
                      return 'Please enter your email';
                    }

                    return null;
                  },

                  decoration:
                  InputDecoration(
                    border:
                    OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(
                        10,
                      ),
                    ),

                    suffixIcon:
                    const Icon(
                      Icons.edit,
                      color:
                      Colors.blueGrey,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Padding(
                padding:
                EdgeInsets.symmetric(
                  horizontal: 10,
                ),

                child: Text(
                  'Password',

                  style: TextStyle(
                    fontSize: 17,
                    color:
                    Colors.blueGrey,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 5),

              Padding(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 10,
                ),

                child: TextField(
                  controller:
                  _passwordController,

                  obscureText:
                  true,

                  decoration:
                  InputDecoration(
                    border:
                    OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(
                        10,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Padding(
                padding:
                EdgeInsets.symmetric(
                  horizontal: 10,
                ),

                child: Text(
                  'Confirm Password',

                  style: TextStyle(
                    fontSize: 17,
                    color:
                    Colors.blueGrey,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 5),

              Padding(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 10,
                ),

                child:
                TextFormField(
                  controller:
                  _confirmPasswordController,

                  validator:
                      (value) {
                    if (value!
                        .isEmpty) {
                      return 'Please enter your password';
                    }

                    return null;
                  },

                  obscureText:
                  true,

                  decoration:
                  InputDecoration(
                    border:
                    OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(
                        10,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              Center(
                child:
                GestureDetector(
                  onTap: () {
                    if (_formKey
                        .currentState!
                        .validate()) {
                      updateProfile(
                        userModel!,
                      );
                    }
                  },

                  child:
                  Container(
                    height: 55,
                    width: 300,

                    decoration:
                    BoxDecoration(
                      color:
                      Colors
                          .blueGrey,

                      borderRadius:
                      BorderRadius.circular(
                        20,
                      ),
                    ),

                    child:
                    Center(
                      child:
                      Text(
                        'Update Profile',

                        style:
                        TextStyle(
                          fontSize:
                          20,

                          color:
                          Colors.grey[
                          200],

                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}