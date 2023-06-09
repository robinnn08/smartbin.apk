import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_bin/widget/button.dart';
import 'package:smart_bin/widget/textfield.dart';
import 'package:smart_bin/widget/tile.dart';

// halaman register
class RegisterPage extends StatefulWidget {
  static const id = "RegisterPage";
  final String data;
  final Function() onTap;
  const RegisterPage({required this.data, required this.onTap, super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // fungsi untuk mendaftarkan user ke database
  void registerUser() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
            child: Center(
                child: CircularProgressIndicator(
          color: Colors.white,
        )));
      },
    );

    try {
      // jika password dan confirm password sama maka akan didaftarkan user baru yang diisi dari textfield email dan password
      // menggunakan firebase auth (createuserWithEmailAndPassword)
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        // navigator pop untuk menghilangkan loading indicator
        Navigator.pop(context);
      }
      // jika tidak sama maka akan ditunjukkan pop up error
      else {
        await Future.delayed(const Duration(milliseconds: 300));
        Navigator.pop(context);
        showError('Passwords do not match');
      }
    }
    // saat firebase auth menangkap error maka akan ditunjukkan pop up error sesuai error yang terjadi
    on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'email-already-in-use') {
        showError('Email is already in use.');
      } else if (e.code == 'invalid-email') {
        showError('Email format is invalid.');
      } else {
        showError('An error occured. Please try again later.');
      }
    }
  }

  void showError(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Registration failed'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ListView(
            children: [
              const SizedBox(height: 30),

              // logo
              const Image(
                image: AssetImage('image/trashgif.gif'),
                height: 100,
              ),

              const SizedBox(height: 30),

              const Center(
                child: Text(
                  'Enter Your Credentials Below',
                  style: TextStyle(
                    color: Color.fromARGB(255, 10, 10, 10),
                    fontSize: 18,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // username textfield
              MyTextField(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
              ),

              const SizedBox(height: 10),

              // password textfield
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),

              const SizedBox(height: 10),

              //confirm pass textfield
              MyTextField(
                controller: confirmPasswordController,
                hintText: 'Confirm Password',
                obscureText: true,
              ),

              const SizedBox(height: 20),

              Column(
                children: [
                  MyButton(
                    text: 'Register & Sign In',
                    onPressed: registerUser,
                  ),
                  const SizedBox(height: 20),
                  // or continue with
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'Or continue with',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  SquareTile(imagePath: 'image/google.png'),

                  const SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Have an account?',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      // Gesture detector pada tulisan Login here untuk berpindah ke halaman login
                      // yang dimana fungsi onTap ini adalah fungsi switchPage yang di passing dari login_register.dart
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          'Login here',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Nunito',
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
