import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  final String title;
  final String desc;
  final List<String> assignedTo;
  final int status;
  final String date;
  final int department;

  Task(
      {required this.id,
      required this.title,
      required this.desc,
      required this.assignedTo,
      required this.status,
      required this.date,
      required this.department});

  factory Task.fromFireStore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Task(
      id: doc.id,
      title: data['baslik'],
      desc: data['aciklama'],
      assignedTo: List<String>.from(data['atanan']),
      status: data['durum'],
      date: data['teslim_tarihi'],
      department: data['departman'],
    );
  }
}
