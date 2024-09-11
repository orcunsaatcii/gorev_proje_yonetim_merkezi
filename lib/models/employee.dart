import 'package:gorev_proje_yonetim_uygulamasi/models/department.dart';
import 'package:gorev_proje_yonetim_uygulamasi/models/task.dart';

class Employee {
  final String id;
  final String name;
  final String email;
  final String password;
  final bool authority;
  final Department department;
  final List<Task> tasks;
  final String pictureUrl;

  Employee({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.authority,
    required this.department,
    required this.tasks,
    required this.pictureUrl,
  });
}
