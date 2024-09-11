import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gorev_proje_yonetim_uygulamasi/models/department.dart';
import 'package:gorev_proje_yonetim_uygulamasi/models/employee.dart';
import 'package:gorev_proje_yonetim_uygulamasi/models/task.dart';
import 'package:gorev_proje_yonetim_uygulamasi/services/auth_service.dart';

class FirestoreService {
  static final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore.instance;

  static Future<List<Employee>?> fetchEmployees(int departmentId) async {
    QuerySnapshot querySnapshot = await _firebaseFirestore
        .collection('kullanicilar')
        .where('departman', isEqualTo: departmentId)
        .get();

    List<Employee> employees = [];
    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;

      QueryDocumentSnapshot? userDepartmentDoc =
          await AuthService.getDepartment(docData['departman']);
      Map<String, dynamic> departmentData =
          userDepartmentDoc!.data() as Map<String, dynamic>;

      final department = Department(
          id: departmentData['id'],
          name: departmentData['isim'],
          icon: departmentData['ikon']);

      List<Task> userTasks = [];
      List<String> taskIds = List<String>.from(docData['gorevler']);
      List<QuerySnapshot> userTasksSnapshots =
          await AuthService.getTasks(taskIds);

      for (var snapshot in userTasksSnapshots) {
        for (var doc in snapshot.docs) {
          Map<String, dynamic> task = doc.data() as Map<String, dynamic>;

          List<String> atananlar = List<String>.from(task['atanan']);
          userTasks.add(
            Task(
              id: task['id'],
              title: task['baslik'],
              desc: task['aciklama'],
              assignedTo: atananlar,
              status: task['durum'],
              date: task['teslim_tarihi'],
              department: task['departman'],
            ),
          );
        }
      }

      employees.add(
        Employee(
          id: docData['id'],
          name: docData['isim'],
          email: docData['email'],
          password: docData['sifre'],
          authority: docData['yetkili'],
          department: department,
          tasks: userTasks,
          pictureUrl: docData['profil_resim'],
        ),
      );
    }

    if (employees.isEmpty) {
      return null;
    } else {
      return employees;
    }
  }

  static Future<void> addTask(String title, String desc,
      List<String> assignedTo, int department, String date) async {
    final docRef = await _firebaseFirestore.collection('gorevler').add(
      {
        'baslik': title,
        'aciklama': desc,
        'atanan': assignedTo,
        'durum': 0,
        'departman': department,
        'teslim_tarihi': date,
      },
    );
    await docRef.update(
      {
        'id': docRef.id,
      },
    );

    for (var employeeId in assignedTo) {
      final userDocRef = await _firebaseFirestore
          .collection('kullanicilar')
          .doc(employeeId)
          .get();
      Map<String, dynamic> userData = userDocRef.data() as Map<String, dynamic>;

      List<String> tasks = List<String>.from(userData['gorevler']);

      tasks.add(docRef.id);
      await _firebaseFirestore
          .collection('kullanicilar')
          .doc(employeeId)
          .update(
        {
          'gorevler': tasks,
        },
      );
    }
  }

  static Future<void> acceptTask(String taskId) async {
    await _firebaseFirestore.collection('gorevler').doc(taskId).update(
      {
        'durum': 1,
      },
    );
  }

  static Future<void> completeTask(String taskId) async {
    await _firebaseFirestore.collection('gorevler').doc(taskId).update(
      {
        'durum': 2,
      },
    );
  }

  static Future<void> sendMessage(
      String message, Map<String, dynamic> user) async {
    await _firebaseFirestore.collection('sohbet').add(
      {
        'mesaj': message,
        'gonderildi': Timestamp.now(),
        'calisan_id': user['id'],
        'calisan_isim': user['isim'],
        'calisan_resim': user['profil_resim'],
      },
    );
  }
}
