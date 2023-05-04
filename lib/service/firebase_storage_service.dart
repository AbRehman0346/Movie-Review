import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import '../../constants.dart';

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<String>> uploadUint8ListFile(List<Uint8List> files) async {
    SettableMetadata metadata = SettableMetadata(contentType: 'image/jpeg');
    List<String> urls = [];
    for (Uint8List file in files) {
      Reference ref = _storage
          .ref(Constants.userDoc)
          .child(DateTime.now().millisecondsSinceEpoch.toString());
      UploadTask uploadTask = ref.putData(file, metadata);
      await uploadTask.whenComplete(() => null);
      urls.add(await ref.getDownloadURL());
    }
    return urls;
  }

  Future<Uint8List?> getUint8ListImage(String imageURL) async {
    await _storage.ref(imageURL).getData().then((value) {
      return value;
    });
  }

  Future<String> getImageDownloadURL(String imageURL) async {
    return await _storage.ref(imageURL).getDownloadURL();
  }

  Future<String> getProfileImageDownloadURL() async {
    return await _storage
        .ref(Constants().userProfilePicturePath)
        .getDownloadURL();
  }

  void deletePic(List<dynamic> imgURLs) async {
    for (var url in imgURLs) {
      print('Here is URL: $url');
      await _storage.refFromURL(url).delete();
    }
  }
}
