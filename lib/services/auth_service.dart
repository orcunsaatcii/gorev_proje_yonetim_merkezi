import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore.instance;

  static Future<String> employeeSignUp(String name, String email,
      String password, int department, String pictureUrl) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      DocumentReference docRef =
          await _firebaseFirestore.collection('kullanicilar').add({
        'isim': name,
        'email': email,
        'sifre': password,
        'yetkili': false,
        'gorevler': [],
        'departman': department,
        'müsaitlik': false,
        'profil_resim': pictureUrl,
        'bekleyen_gorevler': [],
        'tamamlanan_gorevler': [],
      });

      await docRef.update({'id': docRef.id});
      return 'success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'weak-password';
      } else if (e.code == 'email-already-in-use') {
        return 'Bu e-postaya sahip bir kullanıcı var';
      } else {
        return e.code;
      }
    }
  }

  static Future<String> managerSignUp(
      String name, String email, String password, String pictureUrl) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      DocumentReference docRef =
          await _firebaseFirestore.collection('kullanicilar').add({
        'isim': name,
        'email': email,
        'sifre': password,
        'yetkili': true,
        'profil_resim': pictureUrl,
      });

      await docRef.update({'id': docRef.id});
      return 'success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'weak-password';
      } else if (e.code == 'email-already-in-use') {
        return 'Bu e-postaya sahip bir kullanıcı var';
      }
      return 'Kayıt olurken bir hata oluştu';
    }
  }

  static Future<String> userSignIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return 'success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        return 'Kullanıcı bulunamadı';
      } else {
        return 'Giriş yapılırken bir hata oluştu';
      }
    }
  }

  static Future<QueryDocumentSnapshot?> getLoggedInUser(
      String email, String password) async {
    QuerySnapshot querySnapshot = await _firebaseFirestore
        .collection('kullanicilar')
        .where('email', isEqualTo: email)
        .where('sifre', isEqualTo: password)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first;
    } else {
      return null;
    }
  }

  static Future<QueryDocumentSnapshot?> getDepartment(int id) async {
    QuerySnapshot querySnapshot = await _firebaseFirestore
        .collection('departmanlar')
        .where('id', isEqualTo: id)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first;
    } else {
      return null;
    }
  }

  static Future<List<QuerySnapshot>> getTasks(List<String> taskIds) async {
    List<QuerySnapshot> querySnapshots = [];

    for (var taskId in taskIds) {
      querySnapshots.add(
        await _firebaseFirestore
            .collection('gorevler')
            .where('id', isEqualTo: taskId)
            .limit(1)
            .get(),
      );
    }

    return querySnapshots;
  }
}
