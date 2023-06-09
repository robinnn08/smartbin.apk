import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

//halaman boarding pertama
class FirstBoarding extends StatelessWidget {
  const FirstBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(children: [
          const SizedBox(height: 150),
          Lottie.network(
              'https://assets7.lottiefiles.com/packages/lf20_MKYC9r.json'),
          const SizedBox(height: 60),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Tired of seeing overflowed trash cans?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10.0, left: 30, right: 30),
            child: Text(
              'Who doesn\'t? It\'s bad for sure, but we can do something about it.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromARGB(255, 124, 122, 122),
                fontFamily: 'Nunito',
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
