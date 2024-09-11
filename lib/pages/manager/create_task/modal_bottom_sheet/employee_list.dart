import 'package:flutter/material.dart';
import 'package:gorev_proje_yonetim_uygulamasi/constants/constants.dart';
import 'package:gorev_proje_yonetim_uygulamasi/models/employee.dart';
import 'package:gorev_proje_yonetim_uygulamasi/pages/manager/create_task/widgets/employee_list_item.dart';
import 'package:gorev_proje_yonetim_uygulamasi/services/firestore_service.dart';

class EmployeeList extends StatefulWidget {
  const EmployeeList({super.key, required this.departmentId});

  final int departmentId;

  @override
  State<EmployeeList> createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {
  List<Employee> selectedEmployees = [];
  List<Employee>? employees;
  late Future<void> _fetchEmployeesFuture;

  @override
  void initState() {
    super.initState();
    _fetchEmployeesFuture = _fetchEmployees();
  }

  Future<void> _fetchEmployees() async {
    employees = await FirestoreService.fetchEmployees(widget.departmentId);
  }

  void _onEmployeeSelected(Employee employee) {
    setState(() {
      if (selectedEmployees.contains(employee)) {
        selectedEmployees.remove(employee);
      } else {
        selectedEmployees.add(employee);
      }
    });
  }

  void _select() {
    Navigator.pop(context, selectedEmployees);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      child: Column(
        children: [
          Expanded(
            child: FutureBuilder<void>(
              future: _fetchEmployeesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Hata: ${snapshot.error}'));
                } else if (employees == null || employees!.isEmpty) {
                  return const Center(
                    child: Text('Bu departmanda bir çalışan bulunmuyor'),
                  );
                } else {
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      childAspectRatio: 0.80,
                    ),
                    itemCount: employees!.length,
                    itemBuilder: (context, index) => EmployeeListItem(
                      employee: employees![index],
                      onSelected: _onEmployeeSelected,
                    ),
                  );
                }
              },
            ),
          ),
          GestureDetector(
            onTap: _select,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              width: screenWidth,
              decoration: BoxDecoration(
                color: green,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                    color: green,
                    offset: Offset(0, -5),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'Seç',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: white,
                      ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
