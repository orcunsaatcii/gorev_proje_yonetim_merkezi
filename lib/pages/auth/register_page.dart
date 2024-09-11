import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gorev_proje_yonetim_uygulamasi/constants/constants.dart';
import 'package:gorev_proje_yonetim_uygulamasi/models/department.dart';
import 'package:gorev_proje_yonetim_uygulamasi/pages/auth/login_page.dart';
import 'package:gorev_proje_yonetim_uygulamasi/providers/authentication_provider.dart';
import 'package:gorev_proje_yonetim_uygulamasi/providers/departments_provider.dart';
import 'package:gorev_proje_yonetim_uygulamasi/services/auth_service.dart';
import 'package:gorev_proje_yonetim_uygulamasi/services/firebase_storage_service.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  ValueNotifier<bool> isEmployee = ValueNotifier<bool>(true);
  final _formKey = GlobalKey<FormState>();
  File? _selectedImage;
  int? _selectedIndex;
  String _name = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  String _managerKey = '';

  Future<void> signUp() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_selectedImage != null) {
        if (isEmployee.value) {
          if (_selectedIndex == null) {
            return;
          }
          if (_password == _confirmPassword) {
            ref.watch(authenticationProvider.notifier).startAuthentication();
            final profilePicUrl =
                await FirebaseStorageService.uploadProfilePicture(
                    _selectedImage!);
            final isRegistered = await AuthService.employeeSignUp(
              _name,
              _email,
              _password,
              _selectedIndex!,
              profilePicUrl!,
            );

            if (isRegistered == 'success' && mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Başarı ile kayıt olundu'),
                ),
              );
              _formKey.currentState!.reset();
              _selectedIndex = null;
              ref.watch(authenticationProvider.notifier).stopAuthentication();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
            } else if (isRegistered == 'weak-password') {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isRegistered),
                  ),
                );
                ref.watch(authenticationProvider.notifier).stopAuthentication();
              }
            } else if (isRegistered == 'email-already-in-use') {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isRegistered),
                  ),
                );
                ref.watch(authenticationProvider.notifier).stopAuthentication();
              }
            } else {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isRegistered),
                  ),
                );
                ref.watch(authenticationProvider.notifier).stopAuthentication();
              }
            }
          } else {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Şifreler eşleşmiyor'),
                ),
              );
            }
          }
        } else {
          if (_password == _confirmPassword) {
            if (_managerKey == '225714') {
              ref.watch(authenticationProvider.notifier).startAuthentication();
              final profilePicUrl =
                  await FirebaseStorageService.uploadProfilePicture(
                      _selectedImage!);
              final isRegistered = await AuthService.managerSignUp(
                _name,
                _email,
                _password,
                profilePicUrl!,
              );

              if (isRegistered == 'success' && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Başarı ile kayıt olundu'),
                  ),
                );
                _formKey.currentState!.reset();
                _selectedIndex = null;
                ref.watch(authenticationProvider.notifier).stopAuthentication();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              } else if (isRegistered == 'weak-password') {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isRegistered),
                    ),
                  );
                  ref
                      .watch(authenticationProvider.notifier)
                      .stopAuthentication();
                }
              } else if (isRegistered == 'email-already-in-use') {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isRegistered),
                    ),
                  );
                  ref
                      .watch(authenticationProvider.notifier)
                      .stopAuthentication();
                }
              } else {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isRegistered),
                    ),
                  );
                  ref
                      .watch(authenticationProvider.notifier)
                      .stopAuthentication();
                }
              }
            } else {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Yanlış yönetici anahtarı'),
                  ),
                );
              }
            }
          } else {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Şifreler eşleşmiyor'),
                ),
              );
            }
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Lütfen bir profil fotoğrafı seçiniz'),
            ),
          );
        }
      }
    }
  }

  Future<void> _pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) {
      return;
    }
    setState(() {
      _selectedImage = File(image.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final List<Department> departments = ref.watch(departmentProvider);
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
                    width: 150,
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
                                        'Çalışan Kayıt',
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
                                        'Yönetici Kayıt',
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
                  const SizedBox(
                    height: 10.0,
                  ),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: screenWidth * 0.25,
                      height: screenWidth * 0.25,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: _selectedImage != null
                              ? DecorationImage(
                                  image: FileImage(_selectedImage!),
                                )
                              : null,
                          color: lightGrey,
                          border: Border.all(
                            color: isEmployee.value ? mainColor : secondColor,
                          )),
                      child: _selectedImage == null
                          ? const Icon(Icons.add_a_photo, size: 35)
                          : null,
                    ),
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
                            decoration: InputDecoration(
                              labelText: 'Adı',
                              hintText: 'Adınızı giriniz',
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
                              prefixIcon: const Icon(Icons.person),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Bu alan zorunludur';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              _name = newValue!;
                            },
                          ),
                          const SizedBox(
                            height: 10.0,
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
                          const SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Şifre Tekrar',
                              hintText: 'Şifrenizi tekrar giriniz',
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

                              return null;
                            },
                            onSaved: (newValue) {
                              _confirmPassword = newValue!;
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
                          if (isEmployee.value)
                            Column(
                              children: [
                                const SizedBox(
                                  height: 10.0,
                                ),
                                DropdownButtonFormField<int>(
                                  decoration: InputDecoration(
                                    labelText: 'Departman Seçiniz',
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
                                    prefixIcon: const Icon(Icons.business),
                                  ),
                                  items: departments
                                      .map(
                                        (department) => DropdownMenuItem<int>(
                                          value: department.id,
                                          child: Text(department.name),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedIndex = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Bir departman seçiniz';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          SizedBox(
                            height: screenHeight * 0.02,
                          ),
                          GestureDetector(
                            onTap: signUp,
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
                                          'Kayıt Ol',
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
                              const Text('Zaten bir hesabın var mı?'),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Giriş Yap',
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
