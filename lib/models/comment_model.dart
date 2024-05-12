import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final int ratting;
  final String commentator;
  final String comment;
  final String date;
  String? docId;
  String? profile; //Profile Image Link of Commentator
  CommentModel({
    required this.ratting,
    required this.commentator,
    required this.comment,
    required this.date,
    this.docId,
    this.profile,
  });

  factory CommentModel.fromDocument(DocumentSnapshot snap) {
    CommentModelFields fields = CommentModelFields();

    return CommentModel(
      ratting: snap.get(fields.ratting),
      comment: snap.get(fields.comment),
      commentator: snap.get(fields.commentator),
      date: snap.get(fields.date),
      docId: snap.id,
      profile: snap.get(fields.profile),
    );
  }

  Map<String, dynamic> toMap() {
    CommentModelFields fields = CommentModelFields();
    return {
      fields.ratting: ratting,
      fields.comment: comment,
      fields.date: date,
      fields.commentator: commentator,
      fields.profile: profile //Profile Image Link of Commentator
    };
  }
}

class CommentModelFields {
  String ratting = "ratting";
  String comment = "comment";
  String date = "date";
  String commentator = "commentator";
  String profile = 'profile'; //Profile Image of Commentator.s
}
