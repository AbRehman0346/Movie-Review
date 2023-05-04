import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class ReviewModel {
  final String title;
  final dynamic review;
  final DateTime date;
  final List<dynamic> videoLinks;
  final List<dynamic> imgUrls; //Image URLs From Firebase Storage
  final int views;
  String? docId;
  final String userEmail;
  ReviewModel({
    required this.title,
    required this.review,
    required this.date,
    required this.videoLinks,
    required this.imgUrls,
    required this.userEmail,
    required this.views,
    this.docId,
  });

  factory ReviewModel.fromDocument(DocumentSnapshot snap) {
    ReviewModelFields fields = ReviewModelFields();

    //Getting Plain Text of Quill Delta Review
    quill.QuillController controller = quill.QuillController(
      document: quill.Document.fromJson(jsonDecode(snap.get(fields.review))),
      selection: const TextSelection.collapsed(offset: 0),
    );

    return ReviewModel(
      title: snap[fields.title],
      review: controller.document.toPlainText(),
      date: DateTime.parse(snap[fields.date]),
      videoLinks: snap[fields.videoLinks],
      imgUrls: snap[fields.imgUrls],
      userEmail: snap[fields.user],
      views: int.parse(snap[fields.views].toString()),
      docId: snap.id,
    );
  }

  Map<String, dynamic> toMap() {
    ReviewModelFields fields = ReviewModelFields();
    return {
      fields.title: title,
      fields.review: review,
      fields.date: date.toIso8601String(),
      fields.videoLinks: videoLinks,
      fields.imgUrls: imgUrls,
      fields.user: userEmail,
      fields.views: views,
    };
  }
}

class ReviewModelFields {
  String title = "title";
  String review = "review";
  String date = "date";
  String videoLinks = "videoLinks";
  String imgUrls = "imgURLs";
  String user = 'user';
  String views = 'views';
}
