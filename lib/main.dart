import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gorev_proje_yonetim_uygulamasi/pages/landing/landing_page.dart';
import 'package:gorev_proje_yonetim_uygulamasi/providers/departments_provider.dart';
import 'package:gorev_proje_yonetim_uygulamasi/providers/employees_provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(employeesProvider.notifier).loadEmployees();
    ref.read(departmentProvider.notifier).loadDepartments();
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.ubuntuTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const LandingPage(),
    );
  }
}
