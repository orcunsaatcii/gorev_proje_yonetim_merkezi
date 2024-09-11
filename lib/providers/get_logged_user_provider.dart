import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoggedUserNotifier extends StateNotifier<Map<String, dynamic>> {
  LoggedUserNotifier() : super({}) {
    getLoggedUser();
  }

  Future<void> getLoggedUser() async {
    final user = FirebaseAuth.instance.currentUser;
    final QuerySnapshot querySnapshots =
        await FirebaseFirestore.instance.collection('kullanicilar').get();

    for (var doc in querySnapshots.docs) {
      Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
      if (docData['email'] == user!.email) {
        state = docData;
      }
    }
  }
}

final getLoggedUserProvider =
    StateNotifierProvider<LoggedUserNotifier, Map<String, dynamic>>(
  (ref) => LoggedUserNotifier(),
);
