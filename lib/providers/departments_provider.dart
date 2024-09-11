import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gorev_proje_yonetim_uygulamasi/models/department.dart';

class DepartmentNotifier extends StateNotifier<List<Department>> {
  DepartmentNotifier() : super([]);

  Future<void> loadDepartments() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('departmanlar').get();

      List<Department> loadedDepartments = [];

      for (var doc in querySnapshot.docs) {
        loadedDepartments.add(
          Department(
            id: doc['id'],
            name: doc['isim'],
            icon: doc['ikon'],
          ),
        );
      }

      state = loadedDepartments;
    } catch (e) {
      print('Departmanlar yüklenirken hata oluştu: $e');
    }
  }
}

final departmentProvider =
    StateNotifierProvider<DepartmentNotifier, List<Department>>((ref) {
  return DepartmentNotifier();
});
