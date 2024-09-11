import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gorev_proje_yonetim_uygulamasi/constants/constants.dart';
import 'package:gorev_proje_yonetim_uygulamasi/models/task.dart';
import 'package:gorev_proje_yonetim_uygulamasi/pages/employee/task_detail/task_detail_page.dart';
import 'package:gorev_proje_yonetim_uygulamasi/providers/employees_provider.dart';

class TaskItem extends ConsumerStatefulWidget {
  const TaskItem({super.key, required this.task, required this.taskIcon});

  final Task task;
  final String taskIcon;

  @override
  ConsumerState<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends ConsumerState<TaskItem> {
  List<String> assignedEmployeesPhotos = [];

  @override
  Widget build(BuildContext context) {
    final employees = ref.watch(employeesProvider);

    for (var employeeId in widget.task.assignedTo) {
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
              task: widget.task,
              authority: true,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(15.0),
        width: 175,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: const Color.fromARGB(255, 243, 243, 243),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  widget.taskIcon,
                  width: 40,
                ),
                Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: taskStatus[widget.task.status]!.values.first,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 150,
              height: 50,
              child: Text(
                widget.task.title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              'Teslim Tarihi',
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: grey,
                  ),
            ),
            Text(
              widget.task.date,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            const SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }
}
