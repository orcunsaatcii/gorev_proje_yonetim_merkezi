import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gorev_proje_yonetim_uygulamasi/constants/constants.dart';
import 'package:gorev_proje_yonetim_uygulamasi/models/department.dart';
import 'package:gorev_proje_yonetim_uygulamasi/models/task.dart';
import 'package:gorev_proje_yonetim_uygulamasi/pages/base_page.dart';
import 'package:gorev_proje_yonetim_uygulamasi/providers/departments_provider.dart';
import 'package:gorev_proje_yonetim_uygulamasi/providers/employees_provider.dart';
import 'package:gorev_proje_yonetim_uygulamasi/services/firestore_service.dart';
import 'package:transparent_image/transparent_image.dart';

class TaskDetailPage extends ConsumerWidget {
  const TaskDetailPage(
      {super.key, required this.task, required this.authority});

  final Task task;
  final bool authority;

  Future<void> _accept(String taskId) async {
    await FirestoreService.acceptTask(taskId);
  }

  Future<void> _complete(String taskId) async {
    await FirestoreService.completeTask(taskId);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final departments = ref.watch(departmentProvider);
    final employees = ref.watch(employeesProvider);
    final List<String> assignedEmployeesPhotos = [];

    final Department department = departments
        .where(
          (element) => element.id == task.department,
        )
        .first;

    for (var employeeId in task.assignedTo) {
      assignedEmployeesPhotos.add(employees
          .where(
            (element) => element.id == employeeId,
          )
          .first
          .pictureUrl);
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      department.icon,
                      width: 40,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Departman',
                          style:
                              Theme.of(context).textTheme.labelMedium!.copyWith(
                                    color: grey,
                                  ),
                        ),
                        Text(
                          department.name,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: const Color.fromARGB(255, 156, 39, 176)
                            .withOpacity(0.5),
                      ),
                      child: const Icon(
                        Icons.calendar_month_outlined,
                        size: 20,
                        color: Colors.purple,
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Teslim Tarihi',
                          style:
                              Theme.of(context).textTheme.labelMedium!.copyWith(
                                    color: grey,
                                  ),
                        ),
                        Text(
                          task.date,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 30.0,
            ),
            Text(
              'Açıklama',
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(
              height: 15.0,
            ),
            Text(
              task.desc,
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: grey,
                  ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            Row(
              children: [
                Text(
                  'Takım Üyeleri ',
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  '(${assignedEmployeesPhotos.length})',
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: grey,
                      ),
                ),
              ],
            ),
            const SizedBox(
              height: 15.0,
            ),
            SizedBox(
              height: 50,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) => const SizedBox(
                  width: 5.0,
                ),
                itemCount: assignedEmployeesPhotos.length,
                itemBuilder: (context, index) => Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: assignedEmployeesPhotos[index],
                    fit: BoxFit.cover,
                    width: 50,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            if (task.status != 2 && !authority)
              GestureDetector(
                onTap: () {
                  task.status == 0 ? _accept(task.id) : _complete(task.id);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BasePage(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  width: screenWidth,
                  decoration: BoxDecoration(
                    color: orange,
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                      colors: task.status == 0
                          ? [
                              orange,
                              orange.withOpacity(0.5),
                            ]
                          : [
                              blue,
                              blue.withOpacity(0.5),
                            ],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      task.status == 0 ? 'Onayla' : 'Tamamla',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: white,
                          ),
                    ),
                  ),
                ),
              ),
            if (task.status == 2 && !authority)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                width: screenWidth,
                decoration: BoxDecoration(
                  color: orange,
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    colors: [
                      green.withOpacity(0.5),
                      grey,
                    ],
                  ),
                ),
                child: Center(
                  child: Text(
                    'Tamamlandı',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: white,
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
