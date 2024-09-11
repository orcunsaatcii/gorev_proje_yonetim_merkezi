import 'package:flutter/material.dart';
import 'package:gorev_proje_yonetim_uygulamasi/constants/constants.dart';
import 'package:gorev_proje_yonetim_uygulamasi/pages/auth/login_page.dart';
import 'package:gorev_proje_yonetim_uygulamasi/pages/auth/register_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: screenHeight * 0.5,
                  width: screenWidth * 0.75,
                ),
                Text(
                  'GPYM',
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        color: mainColor,
                      ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Text(
                  'Görev ve Proje Yönetim Merkezi',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: grey,
                      ),
                ),
                const SizedBox(
                  height: 50.0,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterPage(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    width: screenWidth,
                    decoration: BoxDecoration(
                      color: mainColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        'KAYIT OL',
                        style:
                            Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  color: white,
                                ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    width: screenWidth,
                    decoration: BoxDecoration(
                      color: lightGrey,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'GİRİŞ',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
                                  color: mainColor,
                                ),
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          const Icon(
                            Icons.arrow_forward,
                            size: 30,
                            color: mainColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
