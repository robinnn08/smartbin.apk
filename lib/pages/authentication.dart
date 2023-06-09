import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_bin/pages/login_register.dart';
import 'package:smart_bin/pages/navpage.dart';

// page untuk menentukan apakah user sudah login atau belum,
//jika sudah maka akan diarahkan ke halaman navpage, jika belum maka akan diarahkan ke halaman login/register
//UI berubah sesuai status authentikasi user
class AuthPage extends StatelessWidget {
  static const id = "AuthPage";
  final String data;
  const AuthPage({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // Streambuilder untuk mengecek status autentikasi user menggunakan
        // stream authStateChanges() dari firebase auth
        body: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // jika snapshot memiliki data maka user sudah login dan akan diarahkan ke halaman navpage
        if (snapshot.hasData) {
          return const NavPage(data: 'Nav Page');
        }
        // jika snapshot tidak memiliki data maka user belum login dan akan diarahkan ke halaman login/register
        else {
          return const LogOrRegister();
        }
      },
    ));
  }
}
