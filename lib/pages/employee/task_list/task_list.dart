import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gorev_proje_yonetim_uygulamasi/models/task.dart';
import 'package:gorev_proje_yonetim_uygulamasi/pages/employee/task_list/widgets/task_list_item.dart';

class TaskList extends StatefulWidget {
  const TaskList({super.key, required this.taskList});

  final List<Task> taskList;

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Görevler'),
        centerTitle: true,
      ),
      body: widget.taskList.isNotEmpty
          ? Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('gorevler')
                      .snapshots(),
                  builder: (context, snapshot) {
                    return ListView.separated(
                      itemCount: widget.taskList.length,
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 15.0,
                      ),
                      itemBuilder: (context, index) => TaskListItem(
                        task: widget.taskList[index],
                      ),
                    );
                  }),
            )
          : const Center(
              child: Text('Herhangi bir görev yok'),
            ),
    );
  }
}
