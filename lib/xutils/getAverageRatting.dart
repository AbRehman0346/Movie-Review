import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../models/comment_model.dart';
import '../service/firestore_service.dart';

class GetAverageRating {
  Future<double> getAverageRating(String docId) async {
    List<DocumentSnapshot> docs =
        await FirebaseFirestoreService().getRattingAndComments(docId);
    CommentModelFields fields = CommentModelFields();
    int? rating = 0;
    for (DocumentSnapshot doc in docs) {
      rating = (rating! + doc.get(fields.ratting)) as int?;
    }

    return rating! / docs.length;
  }
}
