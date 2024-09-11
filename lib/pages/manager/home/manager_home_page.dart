import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gorev_proje_yonetim_uygulamasi/constants/constants.dart';
import 'package:gorev_proje_yonetim_uygulamasi/models/manager.dart';
import 'package:gorev_proje_yonetim_uygulamasi/models/task.dart';
import 'package:gorev_proje_yonetim_uygulamasi/pages/manager/create_task/create_new_task_page.dart';
import 'package:gorev_proje_yonetim_uygulamasi/pages/manager/home/widgets/task_item.dart';
import 'package:gorev_proje_yonetim_uygulamasi/providers/departments_provider.dart';
import 'package:gorev_proje_yonetim_uygulamasi/providers/selected_employees_provider.dart';

class ManagerHomePage extends ConsumerStatefulWidget {
  const ManagerHomePage({super.key, required this.userDoc});

  final QueryDocumentSnapshot userDoc;

  @override
  ConsumerState<ManagerHomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<ManagerHomePage> {
  late final Manager user;

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  void _initializeUser() {
    final userData = widget.userDoc.data() as Map<String, dynamic>;
    user = Manager(
      id: userData['id'],
      name: userData['isim'],
      email: userData['email'],
      password: userData['sifre'],
      authority: userData['yetkili'],
      pictureUrl: userData['profil_resim'],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final departments = ref.watch(departmentProvider);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('GPYM'),
        leading: Image.asset(
          'assets/images/app_icon.png',
        ),
        leadingWidth: 70,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 15.0),
                decoration: const BoxDecoration(
                  color: white,
                  boxShadow: [
                    BoxShadow(
                      color: grey,
                      blurRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Atanan Görevler',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 10.0),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('gorevler')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container();
                        }
                        if (snapshot.hasError) {
                          return Center(
                              child:
                                  Text('Bir hata oluştu: ${snapshot.error}'));
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(child: Text('Veri bulunamadı.'));
                        }

                        List<QueryDocumentSnapshot> docs = snapshot.data!.docs;

                        List<Task> tasks = [];

                        for (var doc in docs) {
                          Map<String, dynamic> docData =
                              doc.data() as Map<String, dynamic>;

                          if (docData['durum'] != 2) {
                            List<String> atananlar =
                                List<String>.from(docData['atanan']);
                            tasks.add(
                              Task(
                                id: docData['id'],
                                title: docData['baslik'],
                                desc: docData['aciklama'],
                                assignedTo: atananlar,
                                status: docData['durum'],
                                date: docData['teslim_tarihi'],
                                department: docData['departman'],
                              ),
                            );
                          }
                        }
                        return SizedBox(
                          height: screenHeight * 0.23,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: tasks.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 10.0),
                            itemBuilder: (context, index) {
                              final taskItem = tasks[index];

                              final taskIcon = departments
                                  .where(
                                    (element) =>
                                        element.id == taskItem.department,
                                  )
                                  .first
                                  .icon;
                              return TaskItem(
                                task: tasks[index],
                                taskIcon: taskIcon,
                              );
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 15,
                              height: 15,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: orange,
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Text(
                              'Bekliyor',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: orange,
                                  ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 15,
                              height: 15,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: blue,
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Text(
                              'Yapılıyor',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: blue,
                                  ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 15,
                              height: 15,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: green,
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Text(
                              'Tamamlandı',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: green,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15.0),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(
                  'Yönetim',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(height: 15.0),
              GestureDetector(
                onTap: () {
                  ref.read(selectedEmployeesProvider.notifier).reset();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateNewTaskPage(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  decoration: const BoxDecoration(
                    color: white,
                    boxShadow: [
                      BoxShadow(
                        color: grey,
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 153, 137, 245),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: const Icon(
                        Icons.dashboard_customize_outlined,
                        size: 30,
                        color: white,
                      ),
                    ),
                    title: Text(
                      'Görev oluştur',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    subtitle: Text(
                      'Çalışanlar için yeni görev oluşturabilirsiniz',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: grey,
                          ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              GestureDetector(
                onTap: () {
                  /* Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChangeDepartmentPage(),
                    ),
                  ); */
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  decoration: const BoxDecoration(
                    color: white,
                    boxShadow: [
                      BoxShadow(
                        color: grey,
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 78, 129, 238),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: const Icon(
                        Icons.business,
                        size: 30,
                        color: white,
                      ),
                    ),
                    title: Text(
                      'Departman değiştir',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    subtitle: Text(
                      'Çalışanların departmanını değiştirebilirsiniz',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: grey,
                          ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  decoration: const BoxDecoration(
                    color: white,
                    boxShadow: [
                      BoxShadow(
                        color: grey,
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 20, 204, 118),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: const Icon(
                        Icons.task_outlined,
                        size: 30,
                        color: white,
                      ),
                    ),
                    title: Text(
                      'Tüm görevler',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    subtitle: Text(
                      'Tamamlanan ve devam eden tüm görevleri görebilirsiniz',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: grey,
                          ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
