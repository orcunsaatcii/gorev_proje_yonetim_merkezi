import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gorev_proje_yonetim_uygulamasi/models/department.dart';
import 'package:gorev_proje_yonetim_uygulamasi/models/employee.dart';
import 'package:gorev_proje_yonetim_uygulamasi/models/task.dart';
import 'package:gorev_proje_yonetim_uygulamasi/services/auth_service.dart';

class EmployeesNotifier extends StateNotifier<List<Employee>> {
  EmployeesNotifier() : super([]);

  Future<void> loadEmployees() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('kullanicilar').get();

      List<Employee> loadedEmployees = [];

      for (var doc in querySnapshot.docs) {
        if (!doc['yetkili']) {
          QueryDocumentSnapshot? userDepartmentDoc =
              await AuthService.getDepartment(doc['departman']);
          Map<String, dynamic> departmentData =
              userDepartmentDoc!.data() as Map<String, dynamic>;

          final department = Department(
              id: departmentData['id'],
              name: departmentData['isim'],
              icon: departmentData['ikon']);

          List<Task> userTasks = [];
          List<String> taskIds = List<String>.from(doc['gorevler']);
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

          loadedEmployees.add(
            Employee(
              id: doc['id'],
              name: doc['isim'],
              email: doc['email'],
              password: doc['sifre'],
              authority: doc['yetkili'],
              department: department,
              tasks: userTasks,
              pictureUrl: doc['profil_resim'],
            ),
          );
        }
      }

      state = loadedEmployees;
    } catch (e) {
      print('Çalışanlar yüklenirken hata oluştu: $e');
    }
  }

  void reset() {
    state = [];
  }
}

final employeesProvider =
    StateNotifierProvider<EmployeesNotifier, List<Employee>>((ref) {
  return EmployeesNotifier();
});
