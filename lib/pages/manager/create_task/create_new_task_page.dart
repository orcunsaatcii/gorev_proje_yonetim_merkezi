import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gorev_proje_yonetim_uygulamasi/constants/constants.dart';
import 'package:gorev_proje_yonetim_uygulamasi/models/department.dart';
import 'package:gorev_proje_yonetim_uygulamasi/models/employee.dart';
import 'package:gorev_proje_yonetim_uygulamasi/pages/manager/create_task/modal_bottom_sheet/employee_list.dart';
import 'package:gorev_proje_yonetim_uygulamasi/pages/manager/create_task/widgets/employee_mini_icon.dart';
import 'package:gorev_proje_yonetim_uygulamasi/providers/departments_provider.dart';
import 'package:gorev_proje_yonetim_uygulamasi/providers/selected_employees_provider.dart';
import 'package:gorev_proje_yonetim_uygulamasi/services/firestore_service.dart';

class CreateNewTaskPage extends ConsumerStatefulWidget {
  const CreateNewTaskPage({super.key});

  @override
  ConsumerState<CreateNewTaskPage> createState() => _CreateNewTaskPageState();
}

class _CreateNewTaskPageState extends ConsumerState<CreateNewTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  int? _selectedIndex;
  String _title = '';
  String _desc = '';

  Future<void> _selectDate() async {
    DateTime firstDate = DateTime.now();
    DateTime lastDate = DateTime.utc(DateTime.now().year + 1);

    final selectedDate = await showDatePicker(
        context: context, firstDate: firstDate, lastDate: lastDate);

    if (selectedDate == null) {
      return;
    }
    setState(() {
      _dateController.text =
          '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
    });
  }

  Future<void> _createTask() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final selectedEmployees = ref.read(selectedEmployeesProvider);

      List<String> assignedTo = [];
      for (var employee in selectedEmployees) {
        assignedTo.add(employee.id);
      }

      if (selectedEmployees.isNotEmpty) {
        await FirestoreService.addTask(
            _title, _desc, assignedTo, _selectedIndex!, _dateController.text);

        _formKey.currentState!.reset();
        _selectedIndex = null;
        _dateController.text = '';
        ref.read(selectedEmployeesProvider.notifier).reset();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Görev oluşturuldu'),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Görev için çalışan seçiniz'),
            ),
          );
        }
      }
    }
  }

  Future<void> _fetchEmployees() async {
    if (_selectedIndex == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bir departman seçiniz'),
          ),
        );
      }
    } else {
      final List<Employee>? result = await showModalBottomSheet<List<Employee>>(
        context: context,
        builder: (context) => EmployeeList(
          departmentId: _selectedIndex!,
        ),
      );

      if (result != null) {
        for (var e in result) {
          ref.read(selectedEmployeesProvider.notifier).addEmployee(e);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final List<Department> departments = ref.watch(departmentProvider);
    final List<Employee> selectedEmployees =
        ref.watch(selectedEmployeesProvider);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Görev Oluştur'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Başlık',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    TextFormField(
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
                          borderSide: const BorderSide(
                            color: secondColor,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: secondColor,
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: secondColor,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: secondColor,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Bu alan zorunludur';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _title = newValue!;
                      },
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Text(
                      'Açıklama',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    TextFormField(
                      maxLines: 5,
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
                          borderSide: const BorderSide(
                            color: secondColor,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: secondColor,
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: secondColor,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: secondColor,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Bu alan zorunludur';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _desc = newValue!;
                      },
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Text(
                      'Departman',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    DropdownButtonFormField<int>(
                      menuMaxHeight: 270,
                      decoration: InputDecoration(
                        labelText:
                            _selectedIndex == null ? 'Departman Seçiniz' : null,
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
                    const SizedBox(
                      height: 15.0,
                    ),
                    Text(
                      'Teslim Tarihi',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    TextFormField(
                      controller: _dateController,
                      onTap: _selectDate,
                      readOnly: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: white,
                        labelText: _dateController.text.isEmpty
                            ? 'Teslim Tarihi Seçiniz'
                            : null,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: secondColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: secondColor,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: secondColor,
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: secondColor,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: secondColor,
                          ),
                        ),
                        prefixIcon: const Icon(Icons.calendar_month),
                      ),
                      validator: (value) {
                        if (_dateController.text.isEmpty) {
                          return 'Bir tarih seçiniz';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              Text(
                'Çalışanlar',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: _fetchEmployees,
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: white,
                        border: Border.all(
                          color: secondColor,
                        ),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 30,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  if (selectedEmployees.isNotEmpty)
                    Wrap(
                      spacing: 10.0,
                      children: selectedEmployees
                          .map(
                            (employee) => EmployeeMiniIcon(employee: employee),
                          )
                          .toList(),
                    ),
                ],
              ),
              const SizedBox(
                height: 25.0,
              ),
              GestureDetector(
                onTap: _createTask,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  width: screenWidth,
                  decoration: BoxDecoration(
                    color: green,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      'Görev Oluştur',
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
      ),
    );
  }
}
