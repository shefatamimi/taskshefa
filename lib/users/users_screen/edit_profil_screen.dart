import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_shefa/group_task/group_screens/group_task_ui.dart';
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
          backgroundColor: Colors.green,
          content: Text(
            'Profile updated successfully',
          ),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Failed to update profile',
          ),
        ),
      );
    }
  }
  Widget sectionTitle(String title) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 10,
      ),

      child: Text(
        '$title',

        style: const TextStyle(
          fontSize: 17,
          color:
          GroupTaskUi.primaryDark,
          fontWeight:
          FontWeight.bold,
        ),
      ),
    );
  }

  Widget textFieldProfil({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          suffixIcon: Icon(
            icon,
            color: GroupTaskUi.primaryDark,
          ),
        ),
      ),
    );
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
                  backgroundColor: GroupTaskUi.background,

                  radius: 80,
                 child:  Icon(
                    Icons.person,
                    size: 120,
                    color: GroupTaskUi.primary
                          )

                ),
              ),


             sectionTitle('Email'),

              const SizedBox(height: 5),

              textFieldProfil(
                controller: _emailController,
                icon: Icons.edit,
                hint: 'Enter your email',
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  }
                }
                  ),

              const SizedBox(height: 20),

              sectionTitle('Password'),

              const SizedBox(height: 5),
              textFieldProfil(
                controller: _passwordController,
                icon: Icons.lock,
                hint: 'Enter your password',
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }
                },
              ),



              const SizedBox(height: 20),

              sectionTitle('Confirm Password'),


              const SizedBox(height: 5),

              textFieldProfil(
                controller: _confirmPasswordController,
                icon: Icons.lock,
                hint: 'Confirm your password',
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please confirm your password';
                  }
                },
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
                      GroupTaskUi.primaryDark,
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