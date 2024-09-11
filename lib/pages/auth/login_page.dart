import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gorev_proje_yonetim_uygulamasi/constants/constants.dart';
import 'package:gorev_proje_yonetim_uygulamasi/pages/auth/register_page.dart';
import 'package:gorev_proje_yonetim_uygulamasi/pages/base_page.dart';
import 'package:gorev_proje_yonetim_uygulamasi/pages/manager/home/manager_home_page.dart';
import 'package:gorev_proje_yonetim_uygulamasi/providers/authentication_provider.dart';
import 'package:gorev_proje_yonetim_uygulamasi/providers/get_logged_user_provider.dart';
import 'package:gorev_proje_yonetim_uygulamasi/services/auth_service.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  ValueNotifier<bool> isEmployee = ValueNotifier<bool>(true);
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _managerKey = '';

  void signIn() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      ref.read(authenticationProvider.notifier).startAuthentication();

      if (isEmployee.value) {
        final isUserExist = await AuthService.userSignIn(_email, _password);

        if (isUserExist == 'success') {
          await ref.read(getLoggedUserProvider.notifier).getLoggedUser();
          ref.watch(authenticationProvider.notifier).stopAuthentication();
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const BasePage(),
              ),
            );
          }
        } else if (isUserExist == 'invalid-credential') {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(isUserExist),
              ),
            );
            ref.watch(authenticationProvider.notifier).stopAuthentication();
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(isUserExist),
              ),
            );
            ref.watch(authenticationProvider.notifier).stopAuthentication();
          }
        }
      } else {
        if (_managerKey == '225714') {
          final isUserExist = await AuthService.userSignIn(_email, _password);

          if (isUserExist == 'success') {
            QueryDocumentSnapshot? userDoc =
                await AuthService.getLoggedInUser(_email, _password);

            ref.watch(authenticationProvider.notifier).stopAuthentication();
            if (mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ManagerHomePage(userDoc: userDoc!),
                ),
              );
            }
          } else if (isUserExist == 'invalid-credential') {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isUserExist),
                ),
              );
              ref.watch(authenticationProvider.notifier).stopAuthentication();
            }
          } else {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isUserExist),
                ),
              );
              ref.watch(authenticationProvider.notifier).stopAuthentication();
            }
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Yanlış yönetici anahtarı'),
              ),
            );
            ref.watch(authenticationProvider.notifier).stopAuthentication();
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final bool isAuthenticating = ref.watch(authenticationProvider);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 300,
                  ),
                  const SizedBox(
                    height: 50.0,
                  ),
                  Row(
                    children: [
                      ValueListenableBuilder(
                        valueListenable: isEmployee,
                        builder: (context, value, child) => Expanded(
                          child: GestureDetector(
                            onTap: () {
                              _formKey.currentState!.reset();
                              isEmployee.value = true;
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 1500),
                              curve: Curves.fastOutSlowIn,
                              height: screenHeight * 0.07,
                              decoration: BoxDecoration(
                                color: isEmployee.value ? mainColor : lightGrey,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      child: Text(
                                        'Çalışan Giriş',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                              color: white,
                                            ),
                                      ),
                                    ),
                                    Image.asset('assets/images/employee.png',
                                        width: 50),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 25.0,
                      ),
                      ValueListenableBuilder(
                        valueListenable: isEmployee,
                        builder: (context, value, child) => Expanded(
                          child: GestureDetector(
                            onTap: () {
                              _formKey.currentState!.reset();
                              isEmployee.value = false;
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 1500),
                              curve: Curves.fastOutSlowIn,
                              height: screenHeight * 0.07,
                              decoration: BoxDecoration(
                                color:
                                    !isEmployee.value ? secondColor : lightGrey,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      child: Text(
                                        'Yönetici Giriş',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                              color: white,
                                            ),
                                      ),
                                    ),
                                    Image.asset(
                                      'assets/images/manager.png',
                                      width: 50,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ValueListenableBuilder(
                    valueListenable: isEmployee,
                    builder: (context, value, child) => Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(
                            height: screenHeight * 0.02,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              hintText: 'Email adresinizi giriniz',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: isEmployee.value
                                      ? mainColor
                                      : secondColor,
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: isEmployee.value
                                      ? mainColor
                                      : secondColor,
                                  width: 2,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: isEmployee.value
                                      ? mainColor
                                      : secondColor,
                                  width: 2,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: isEmployee.value
                                      ? mainColor
                                      : secondColor,
                                  width: 2,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: isEmployee.value
                                      ? mainColor
                                      : secondColor,
                                  width: 2,
                                ),
                              ),
                              prefixIcon: const Icon(Icons.email),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Bu alan zorunludur';
                              }
                              if (!value.trim().contains('@')) {
                                return 'Geçerli bir email adresi giriniz';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              _email = newValue!;
                            },
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Şifre',
                              hintText: 'Şifrenizi giriniz',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: isEmployee.value
                                      ? mainColor
                                      : secondColor,
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: isEmployee.value
                                      ? mainColor
                                      : secondColor,
                                  width: 2,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: isEmployee.value
                                      ? mainColor
                                      : secondColor,
                                  width: 2,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: isEmployee.value
                                      ? mainColor
                                      : secondColor,
                                  width: 2,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: isEmployee.value
                                      ? mainColor
                                      : secondColor,
                                  width: 2,
                                ),
                              ),
                              prefixIcon: const Icon(Icons.lock),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Bu alan zorunludur';
                              }
                              if (value.length < 6) {
                                return 'Şifre en az 6 karakter olmalıdır';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              _password = newValue!;
                            },
                          ),
                          if (!isEmployee.value)
                            Column(
                              children: [
                                const SizedBox(
                                  height: 10.0,
                                ),
                                TextFormField(
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    labelText: 'Yönetici Anahtarı',
                                    hintText: 'Yönetici anahtarınızı giriniz',
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: isEmployee.value
                                            ? mainColor
                                            : secondColor,
                                        width: 2,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: isEmployee.value
                                            ? mainColor
                                            : secondColor,
                                        width: 2,
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: isEmployee.value
                                            ? mainColor
                                            : secondColor,
                                        width: 2,
                                      ),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: isEmployee.value
                                            ? mainColor
                                            : secondColor,
                                        width: 2,
                                      ),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: isEmployee.value
                                            ? mainColor
                                            : secondColor,
                                        width: 2,
                                      ),
                                    ),
                                    prefixIcon: const Icon(Icons.vpn_key),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Bu alan zorunludur';
                                    }
                                    return null;
                                  },
                                  onSaved: (newValue) {
                                    _managerKey = newValue!;
                                  },
                                ),
                              ],
                            ),
                          SizedBox(
                            height: screenHeight * 0.02,
                          ),
                          GestureDetector(
                            onTap: signIn,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 1500),
                              curve: Curves.fastOutSlowIn,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color:
                                    isEmployee.value ? mainColor : secondColor,
                              ),
                              width: double.infinity,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20.0),
                                  child: isAuthenticating
                                      ? const CircularProgressIndicator()
                                      : Text(
                                          'Giriş Yap',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .copyWith(
                                                color: white,
                                              ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Hesabınız yok mu?'),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Kayıt Ol',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                        color: mainColor,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
