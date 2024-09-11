import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gorev_proje_yonetim_uygulamasi/constants/constants.dart';
import 'package:gorev_proje_yonetim_uygulamasi/models/task.dart';
import 'package:gorev_proje_yonetim_uygulamasi/pages/employee/task_detail/task_detail_page.dart';
import 'package:gorev_proje_yonetim_uygulamasi/pages/employee/task_list/widgets/employee_icon.dart';
import 'package:gorev_proje_yonetim_uygulamasi/providers/employees_provider.dart';

class TaskListItem extends ConsumerWidget {
  const TaskListItem({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final employees = ref.watch(employeesProvider);
    List<String> assignedEmployeesPhotos = [];

    for (var employeeId in task.assignedTo) {
      assignedEmployeesPhotos.add(employees
          .where(
            (element) => element.id == employeeId,
          )
          .first
          .pictureUrl);
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskDetailPage(
              task: task,
              authority: false,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 25.0),
        height: screenHeight * 0.25,
        width: screenWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(35),
          border: Border.all(
            color: Colors.black,
            width: 2,
          ),
          gradient: LinearGradient(
            colors: task.status == 0
                ? [
                    Colors.red,
                    Colors.red.shade700,
                    Colors.red.shade300,
                    orange,
                    orange.withOpacity(0.75),
                    orange.withOpacity(0.50),
                  ]
                : task.status == 1
                    ? [
                        Colors.purple,
                        Colors.purple.shade700,
                        Colors.purple.shade300,
                        blue,
                        blue.withOpacity(0.75),
                        blue.withOpacity(0.50),
                      ]
                    : [
                        Colors.lightBlue,
                        Colors.lightBlue.shade700,
                        Colors.lightBlue.shade300,
                        green,
                        green.withOpacity(0.75),
                        green.withOpacity(0.50),
                      ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: white,
                        ),
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: assignedEmployeesPhotos.length == 1
                                  ? [
                                      EmployeeIcon(
                                        image: assignedEmployeesPhotos[0],
                                      ),
                                    ]
                                  : assignedEmployeesPhotos.length == 2
                                      ? [
                                          EmployeeIcon(
                                            image: assignedEmployeesPhotos[1],
                                          ),
                                          EmployeeIcon(
                                            image: assignedEmployeesPhotos[0],
                                          ),
                                        ]
                                      : [
                                          EmployeeIcon(
                                            image: assignedEmployeesPhotos[1],
                                          ),
                                          EmployeeIcon(
                                            image: assignedEmployeesPhotos[0],
                                          ),
                                          Center(
                                            child: Text(
                                              '+${assignedEmployeesPhotos.length - 2}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall!
                                                  .copyWith(
                                                    color: white,
                                                  ),
                                            ),
                                          ),
                                        ],
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            ),
                            color: task.status == 0
                                ? orange
                                : task.status == 1
                                    ? blue
                                    : green,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 5.0),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.calendar_month,
                                  color: white,
                                ),
                                const SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  task.date,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .copyWith(
                                        color: white,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.arrow_forward_ios,
                  color: white,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
