import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gorev_proje_yonetim_uygulamasi/constants/constants.dart';
import 'package:gorev_proje_yonetim_uygulamasi/pages/employee/chat/chat_page.dart';
import 'package:gorev_proje_yonetim_uygulamasi/pages/employee/home/employee_home_page.dart';
import 'package:gorev_proje_yonetim_uygulamasi/providers/get_logged_user_provider.dart';
import 'package:transparent_image/transparent_image.dart';

class BasePage extends ConsumerStatefulWidget {
  const BasePage({super.key});

  @override
  ConsumerState<BasePage> createState() => _BasePageState();
}

class _BasePageState extends ConsumerState<BasePage> {
  int _selectedPage = 0;

  List<Widget> pages = [
    const EmployeeHomePage(),
    const ChatPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(getLoggedUserProvider);

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 70,
        title: Text(_selectedPage == 0 ? 'GPYM' : 'Ekip İletişim'),
        leading: Image.asset(
          'assets/images/app_icon.png',
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 25.0, top: 5.0, bottom: 5.0),
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
              ),
              child: FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: NetworkImage(currentUser['profil_resim']),
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
        toolbarHeight: 65,
      ),
      body: pages[_selectedPage],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            _selectedPage = value;
          });
        },
        selectedItemColor: mainColor,
        iconSize: 30,
        currentIndex: _selectedPage,
        items: const [
          BottomNavigationBarItem(
            label: 'Ev',
            icon: Icon(
              Icons.home,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Ekip',
            icon: Icon(
              Icons.message,
            ),
          ),
        ],
      ),
    );
  }
}
