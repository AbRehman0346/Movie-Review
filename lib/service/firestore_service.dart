import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie_review/service/auth_pack/models/user_data_model.dart';
import '../constants.dart';
import '../models/review_model.dart';

class FirebaseFirestoreService {
  FirebaseFirestore fs = FirebaseFirestore.instance;

  //To add a post.
  void add(Map<String, dynamic> doc) async {
    await fs.collection(Constants.mainCollection).add(doc);
  }

  void addWithDocId(Map<String, dynamic> doc, String docId) async {
    await fs.collection(Constants.mainCollection).doc(docId).set(doc);
  }

  Future<QuerySnapshot> getDocs() async {
    ReviewModelFields f = ReviewModelFields();
    //Return List Of Document of Collection of Logged-In Email ID.
    return FirebaseFirestore.instance
        .collection(Constants.mainCollection)
        .orderBy(f.views, descending: true)
        .get();
  }

  Stream<QuerySnapshot> userDocumentsStream() {
    ReviewModelFields fields = ReviewModelFields();
    return fs
        .collection(Constants.mainCollection)
        .where(fields.user, isEqualTo: Constants.user!.email!)
        .snapshots();
  }

  void deleteDocument(String docId) {
    fs.collection(Constants.mainCollection).doc(docId).delete();
  }

  void uploadRattingAndComment(String docId, Map<String, dynamic> data) {
    fs
        .collection(Constants.commentAndRattingCollection)
        .doc(docId)
        .collection(Constants.commentAndRattingCollection)
        .add(data);
  }

  void uploadFeedback(Map<String, dynamic> data) {
    String feedbackCollection = 'feedback';
    fs.collection(feedbackCollection).add(data);
  }

  Stream<QuerySnapshot> getRattingAndCommentsStream(String docId) {
    return fs
        .collection(Constants.commentAndRattingCollection)
        .doc(docId)
        .collection(Constants.commentAndRattingCollection)
        .snapshots();
  }

  Future<List<DocumentSnapshot<Object?>>> getRattingAndComments(
      String docId) async {
    QuerySnapshot querysnap = await fs
        .collection(Constants.commentAndRattingCollection)
        .doc(docId)
        .collection(Constants.commentAndRattingCollection)
        .get();
    List<DocumentSnapshot> docs = querysnap.docs;
    return docs;
  }

  void addView(String docId) {
    ReviewModelFields f = ReviewModelFields();
    fs
        .collection(Constants.mainCollection)
        .doc(docId)
        .update({f.views: FieldValue.increment(1)});
  }
}
