

/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gorev_proje_yonetim_uygulamasi/constants/constants.dart';
import 'package:gorev_proje_yonetim_uygulamasi/models/department.dart';
import 'package:gorev_proje_yonetim_uygulamasi/models/employee.dart';
import 'package:gorev_proje_yonetim_uygulamasi/providers/departments_provider.dart';
import 'package:gorev_proje_yonetim_uygulamasi/providers/employees_provider.dart';
import 'package:gorev_proje_yonetim_uygulamasi/services/firestore_service.dart';
import 'package:transparent_image/transparent_image.dart';

class ChangeDepartmentPage extends ConsumerStatefulWidget {
  const ChangeDepartmentPage({super.key});

  @override
  ConsumerState<ChangeDepartmentPage> createState() =>
      _ChangeDepartmentPageState();
}

class _ChangeDepartmentPageState extends ConsumerState<ChangeDepartmentPage> {
  final _currentDepartmentController = TextEditingController();
  int? _selectedNewDepartment;
  String? _selectedEmployee;

  Future<void> save() async {
    if (_selectedEmployee == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bir çalışan seçiniz'),
          ),
        );
      }
    } else if (_selectedNewDepartment == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bir departman seçiniz'),
          ),
        );
      }
    } else {
      final employees = ref.read(employeesProvider);
      final employee = employees
          .where(
            (element) => element.id == _selectedEmployee,
          )
          .first;

      if (employee.tasks.isEmpty) {
        await FirestoreService.changeDepartment(
            employee.id, _selectedNewDepartment!);
        ref.read(employeesProvider.notifier).loadEmployees();
        setState(() {
          _selectedNewDepartment = null;
          _selectedEmployee = null;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Çalışanın departmanı değiştirildi'),
            ),
          );
        }
      } else {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Tamam'),
              ),
            ],
            icon: const Icon(
              Icons.cancel,
              color: Colors.red,
              size: 50,
            ),
            content: const Text(
                'Çalışanın mevcut departmanında tamamlanmamış görevi bulunuyor.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final List<Department> departments = ref.watch(departmentProvider);
    final List<Employee> employees = ref.watch(employeesProvider);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Departman Değiştir'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Çalışanlar',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(
              height: 15.0,
            ),
            DropdownButtonFormField<String>(
              value: _selectedEmployee,
              menuMaxHeight: 270,
              decoration: InputDecoration(
                labelText: _selectedEmployee == null ? 'Çalışan Seçiniz' : null,
                filled: true,
                fillColor: white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: secondColor,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: secondColor),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: secondColor),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: secondColor,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: secondColor),
                ),
                prefixIcon: const Icon(Icons.business),
              ),
              items: employees
                  .map(
                    (employee) => DropdownMenuItem<String>(
                      value: employee.id,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Row(
                          children: [
                            ClipOval(
                              clipBehavior: Clip.hardEdge,
                              child: FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage,
                                image: employee.pictureUrl,
                                fit: BoxFit.cover,
                                width: 50,
                                height: 50,
                              ),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              employee.name,
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                final docRef = FirebaseFirestore.instance
                    .collection('kullanicilar')
                    .doc(value);

                docRef.snapshots().listen(
                  (DocumentSnapshot docSnapshot) {
                    final data = docSnapshot.data() as Map<String, dynamic>;
                    final departmentId = data['departman'];
                    final currentDepartment = (FirebaseFirestore.instance
                        .collection('departmanlar')
                        .doc(departmentId));
                    currentDepartment.snapshots().listen(
                      (DocumentSnapshot docSnapshot) {
                        final data = docSnapshot.data() as Map<String, dynamic>;
                        final departmentName = data['isim'];
                        _currentDepartmentController.text = departmentName;
                      },
                    );
                  },
                );

                setState(() {
                  _selectedEmployee = value;
                });
              },
              selectedItemBuilder: (context) {
                return employees.map((employee) {
                  return Text(employee.name);
                }).toList();
              },
            ),
            const SizedBox(
              height: 15.0,
            ),
            if (_selectedEmployee != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mevcut Departman',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _currentDepartmentController,
                          style: Theme.of(context).textTheme.titleMedium,
                          readOnly: true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: secondColor,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: secondColor),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: secondColor),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: secondColor,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: secondColor),
                            ),
                            prefixIcon: const Icon(Icons.business),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20.0,
                      ),
                      Image.asset(
                        employees
                            .where(
                              (element) => element.id == _selectedEmployee,
                            )
                            .first
                            .department
                            .icon,
                        width: 55,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Center(
                    child: Image.asset(
                      'assets/images/change.png',
                      fit: BoxFit.cover,
                      width: 50,
                    ),
                  ),
                ],
              ),
            Text(
              'Yeni Departman',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(
              height: 15.0,
            ),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _selectedNewDepartment,
                    menuMaxHeight: 270,
                    style: Theme.of(context).textTheme.titleMedium,
                    decoration: InputDecoration(
                      labelText: _selectedNewDepartment == null
                          ? 'Departman Seçiniz'
                          : null,
                      filled: true,
                      fillColor: white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: secondColor,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: secondColor),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: secondColor),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: secondColor,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: secondColor),
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
                        _selectedNewDepartment = value;
                      });
                    },
                  ),
                ),
                if (_selectedNewDepartment != null)
                  Row(
                    children: [
                      const SizedBox(
                        width: 20.0,
                      ),
                      Image.asset(
                        departments
                            .where(
                              (element) => element.id == _selectedNewDepartment,
                            )
                            .first
                            .icon,
                        width: 55,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(
              height: 15.0,
            ),
            GestureDetector(
              onTap: save,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                width: screenWidth,
                decoration: BoxDecoration(
                  color: blue,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    'Kaydet',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: white,
                        ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/