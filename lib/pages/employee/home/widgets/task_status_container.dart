import 'package:flutter/material.dart';
import 'package:gorev_proje_yonetim_uygulamasi/constants/constants.dart';
import 'package:gorev_proje_yonetim_uygulamasi/models/task.dart';
import 'package:gorev_proje_yonetim_uygulamasi/pages/employee/task_list/task_list.dart';

class TaskStatusContainer extends StatelessWidget {
  const TaskStatusContainer({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.taskCount,
    required this.screenWidth,
    required this.taskList,
  });

  final String title;
  final IconData icon;
  final Color color;
  final int taskCount;
  final double screenWidth;
  final List<Task> taskList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskList(taskList: taskList),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
          width: screenWidth * 0.401,
          height: screenWidth * 0.45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            border: Border.all(
              color: mainColor,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: color.withOpacity(0.5),
                ),
                child: Icon(
                  icon,
                  color: color,
                ),
              ),
              const SizedBox(height: 15.0),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: grey,
                    ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    taskCount.toString(),
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(width: 5.0),
                  Text(
                    'Görev',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
