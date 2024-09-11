import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gorev_proje_yonetim_uygulamasi/models/task.dart';
import 'package:gorev_proje_yonetim_uygulamasi/pages/employee/home/widgets/task_status_container.dart';
import 'package:gorev_proje_yonetim_uygulamasi/providers/get_logged_user_provider.dart';
import 'package:gorev_proje_yonetim_uygulamasi/constants/constants.dart';

class EmployeeHomePage extends ConsumerStatefulWidget {
  const EmployeeHomePage({super.key});

  @override
  ConsumerState<EmployeeHomePage> createState() => _EmployeeHomePageState();
}

class _EmployeeHomePageState extends ConsumerState<EmployeeHomePage> {
  Stream<DocumentSnapshot> getUserStream() async* {
    final user = FirebaseAuth.instance.currentUser;
    final userData = ref.read(getLoggedUserProvider);
    if (user != null) {
      if (userData['id'] != null) {
        yield* FirebaseFirestore.instance
            .collection('kullanicilar')
            .doc(userData['id'])
            .snapshots();
      } else {
        throw Exception('Kullanıcı bulunamadı');
      }
    } else {
      throw Exception('Kullanıcı oturum açmamış');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final currentUser = ref.watch(getLoggedUserProvider);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Merhaba,',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(width: 5.0),
                Text(
                  currentUser['isim'],
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(
              height: 30.0,
            ),
            StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('gorevler').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container();
                }
                if (snapshot.hasError) {
                  return Center(
                      child: Text('Bir hata oluştu: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('Veri bulunamadı.'));
                }

                List<QueryDocumentSnapshot> docs = snapshot.data!.docs;

                int waitingTask = 0;
                int inProgressTask = 0;
                int completedTask = 0;
                List<String> gorevler =
                    List<String>.from(currentUser['gorevler']);
                List<Task> waitingTaskList = [];
                List<Task> inProgressTaskList = [];
                List<Task> completedTaskList = [];

                for (var doc in docs) {
                  Map<String, dynamic> docData =
                      doc.data() as Map<String, dynamic>;

                  if ((gorevler).contains(docData['id'])) {
                    if (docData['durum'] == 0) {
                      waitingTask++;
                      List<String> atananlar =
                          List<String>.from(docData['atanan']);
                      waitingTaskList.add(
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
                    } else if (docData['durum'] == 1) {
                      inProgressTask++;
                      List<String> atananlar =
                          List<String>.from(docData['atanan']);
                      inProgressTaskList.add(
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
                    } else {
                      completedTask++;
                      List<String> atananlar =
                          List<String>.from(docData['atanan']);
                      completedTaskList.add(
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
                }
                return Expanded(
                  child: ListView(
                    children: [
                      TaskStatusContainer(
                        title: 'Bekleyen Görevler',
                        icon: Icons.timelapse,
                        color: orange,
                        taskCount: waitingTask,
                        screenWidth: screenWidth,
                        taskList: waitingTaskList,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      TaskStatusContainer(
                        title: 'Devam Eden Görevler',
                        icon: Icons.scale_rounded,
                        color: blue,
                        taskCount: inProgressTask,
                        screenWidth: screenWidth,
                        taskList: inProgressTaskList,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      TaskStatusContainer(
                        title: 'Tamamlanan Görevler',
                        icon: Icons.check,
                        color: green,
                        taskCount: completedTask,
                        screenWidth: screenWidth,
                        taskList: completedTaskList,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
