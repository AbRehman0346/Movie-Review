import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import '../../constants.dart';
import 'requirements.dart';

class FirebaseAuthStorageServices {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  Requirements req = Requirements();
  Future<void> uploadProfileImage(Uint8List file) async {
    // Commented Code Foe Mobile Phones And Desktops.
    // await _storage
    //     .ref(req.userProfilePicture)
    //     .putFile(File("C:/Users/Abdul_Rehman/Desktop/Pro/1 (13).jpg"));
    final metadata = SettableMetadata(contentType: 'image/jpeg');
    await _storage.ref(req.userProfilePicturePath).putData(file, metadata);
  }

  Future<Uint8List?> getUint8ListImage(String imageURL) async {
    return await _storage.ref(imageURL).getData();
  }

  Future<String> getImageDownloadURL(String imageURL) async {
    return await _storage.ref(imageURL).getDownloadURL();
  }
}
