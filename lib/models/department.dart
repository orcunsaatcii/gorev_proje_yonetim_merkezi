import 'package:cloud_firestore/cloud_firestore.dart';

class Department {
  Department({required this.id, required this.name, required this.icon});

  final int id;
  final String name;
  final String icon;

  factory Department.fromFireStore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Department(
      id: data['id'],
      name: data['isim'],
      icon: data['ikon'],
    );
  }
}
