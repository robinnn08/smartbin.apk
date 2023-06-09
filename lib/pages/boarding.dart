import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../boardings/boarding1.dart';
import '../boardings/boarding2.dart';
import 'authentication.dart';

// halaman boarding yang terdiri dari 2 halaman dalam sebuah pageview
class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        AuthPage.id: (context) => const AuthPage(data: "Auth"),
      },
      home: Scaffold(
          // digunakan stack untuk menampilkan indicator dot di atas pageview
          body: Stack(
        children: [
          PageView(
            //pageview untuk menampilkan 2 halaman boarding
            controller: _controller,
            children: const [
              FirstBoarding(),
              SecondBoarding(),
            ],
          ),
          // menampilkan indicator dot halaman
          Container(
            alignment: const Alignment(0, 0.8),
            child: SmoothPageIndicator(
              controller: _controller,
              count: 2,
              effect: const ExpandingDotsEffect(
                activeDotColor: Colors.black,
                dotColor: Colors.grey,
                dotHeight: 8,
                dotWidth: 8,
                expansionFactor: 4,
                spacing: 5,
              ),
            ),
          ),
        ],
      )),
    );
  }
}
