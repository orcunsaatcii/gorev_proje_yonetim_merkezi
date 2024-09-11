import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  static Future<String?> uploadProfilePicture(File imageFile) async {
    try {
      // Resmi yüklemek için Firebase Storage referansı oluşturmak
      final Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_pictures')
          .child('${imageFile.path.toString()}.jpg');

      // Resmi Firebase Storage'a yüklemek
      final UploadTask uploadTask = storageRef.putFile(imageFile);
      await uploadTask;

      // Yüklenen resmin URL'sini almak
      final String downloadURL = await storageRef.getDownloadURL();

      return downloadURL;
    } catch (e) {
      print('Failed to upload profile picture: $e');
    }
    return null;
  }
}
