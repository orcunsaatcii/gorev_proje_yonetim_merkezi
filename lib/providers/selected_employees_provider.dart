import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gorev_proje_yonetim_uygulamasi/models/employee.dart';

class SelectedEmployeesNotifier extends StateNotifier<List<Employee>> {
  SelectedEmployeesNotifier() : super([]);

  void addEmployee(Employee employee) {
    if (!state.any((element) => element.id == employee.id)) {
      state = [...state, employee];
    }
  }

  void deleteEmployee(Employee employee) {
    state = state.where((e) => e.id != employee.id).toList();
  }

  void reset() {
    state = [];
  }
}

final selectedEmployeesProvider =
    StateNotifierProvider<SelectedEmployeesNotifier, List<Employee>>(
  (ref) => SelectedEmployeesNotifier(),
);
