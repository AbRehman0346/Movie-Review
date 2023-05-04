// import 'dart:typed_data';
// import '../../constants.dart';
// import '../../models/review_model.dart';
// import '../../service/firebase_storage_service.dart';
// import '../../service/firestore_service.dart';
// import '../../xutils/alerts.dart';
//
// class EditScreenFunctions{
//   void update(List<dynamic> _imgBytes, List<dynamic> _imageURL) async {
//     List<String> urls = [];
//     if (_imgBytes.isNotEmpty) {
//       FirebaseStorageService storage =
//       FirebaseStorageService();
//
//       List<Uint8List> img = [];
//       for (var element in _imgBytes) {
//         if (element != null) {
//           img.add(element);
//         }
//       }
//       if (_imageURL.isNotEmpty) {
//         storage.deletePic(_imageURL!);
//       }
//       urls = await storage.uploadUint8ListFile(img);
//     } else {
//       if (_imageURL.isNotEmpty) {
//         urls.add(_imageURL.first!);
//       } else {
//         urls.add("");
//       }
//     }
//
//     if (urls.isEmpty) {
//       urls.add("");
//     }
//
//     //Gathering Data. Above urls also include.
//     String title = _titleController.text;
//     String review = jsonEncode(
//         _quillController.document.toDelta().toJson());
//     DateTime date = DateTime.now();
//     List<dynamic> links = _videoLinks;
//     String docId = widget.doc.id;
//
//     FirebaseFirestoreService().addWithDocId(
//         ReviewModel(
//           title: title,
//           review: review,
//           date: date,
//           videoLinks: links,
//           imgUrls: urls,
//           userEmail: Constants.user!.email!,
//         ).toMap(),
//         docId);
//     Alerts().alertPrimary(context, "Review Updated");
//   }
// }
