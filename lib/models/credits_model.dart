import 'package:cloud_firestore/cloud_firestore.dart';

class CreditsModel {
  final String name;
  final String phone;
  final String email;
  final String desc;
  CreditsModel({
    required this.name,
    required this.phone,
    required this.email,
    required this.desc,
  });

  factory CreditsModel.fromDocument(DocumentSnapshot snap) {
    CreditFields fields = CreditFields();

    return CreditsModel(
      name: snap[fields.name],
      phone: snap[fields.phone],
      email: snap[fields.email],
      desc: snap[fields.desc],
    );
  }

  Map<String, dynamic> toMap() {
    CreditFields fields = CreditFields();
    return {
      fields.name: name,
      fields.phone: phone,
      fields.email: email,
      fields.desc: desc,
    };
  }
}

class CreditFields {
  String name = 'name';
  String phone = 'phone';
  String desc = 'desc';
  String email = 'email';
}
