import 'package:flutter/material.dart';
import '../pages/authentication.dart';

// halaman boarding kedua
class SecondBoarding extends StatelessWidget {
  const SecondBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 150),
            Image.asset(
              'image/trashgif.gif',
              height: 260,
            ),
            const SizedBox(height: 60),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'We got you covered!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Effortlessly monitor your trash cans with our smart trash can.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromARGB(255, 124, 122, 122),
                  fontFamily: 'Nunito',
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () {
                // pindah ke halaman authentication menggunakan named route dan menghapus halaman boarding setelahnya
                Navigator.pushNamedAndRemoveUntil(
                    context, AuthPage.id, (route) => false);
              },
              child: const Text('Get Started'),
            )
          ],
        ),
      ),
    );
  }
}
