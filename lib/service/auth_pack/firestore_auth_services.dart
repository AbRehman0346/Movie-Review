import 'package:cloud_firestore/cloud_firestore.dart';
import '../../constants.dart';
import 'models/user_data_model.dart';
import 'requirements.dart';

class FirestoreAuthServices {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  Requirements req = Requirements();
  Future<bool> saveUserProfileData({
    required String firstName,
    required String lastName,
    required String email,
    String? phone,
  }) async {
    //Uploading Data of User to database.
    UserFields user = UserFields();
    await firebaseFirestore
        .collection(Requirements().profileCollection)
        .doc(req.userDoc)
        .set({
      user.date: DateTime.now(),
      user.firstName: firstName,
      user.lastName: lastName,
      user.email: email,
      user.phone: phone,
      user.id: req.user?.uid,
    });
    return true;
  }

  Future<DocumentSnapshot> getUserData() async {
    DocumentSnapshot snapshot = await firebaseFirestore
        .collection(Requirements().profileCollection)
        .doc(req.userDoc)
        .get();
    return snapshot;
  }

  Future<DocumentSnapshot?> getUserDataByEmail(String email) async {
    UserFields f = UserFields();
    QuerySnapshot snapshot = await firebaseFirestore
        .collection(Requirements().profileCollection)
        .where(f.email, isEqualTo: email)
        .get();
    return snapshot.docs.isNotEmpty ? snapshot.docs[0] : null;
  }

  Future<bool> verifyExistance(String collection) async {
    DocumentSnapshot snapshot = await firebaseFirestore
        .collection(Requirements().profileCollection)
        .doc(req.userDoc)
        .get();
    return snapshot.exists;
  }
}
