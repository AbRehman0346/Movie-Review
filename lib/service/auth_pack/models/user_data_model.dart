import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataModel {
  String docId;
  String email;
  String firstName;
  String lastName;
  String phone;
  String date;
  UserDataModel({
    required this.docId,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.date,
  });

  factory UserDataModel.fromDocument(DocumentSnapshot snapshot) {
    return UserDataModel(
      docId: snapshot.id,
      email: snapshot["email"] ?? "",
      firstName: snapshot["firstName"] ?? "",
      lastName: snapshot["lastName"] ?? "",
      phone: snapshot["phone"] ?? "",
      date: snapshot["date"].toString(),
    );
  }

  Map<String, dynamic> toMap() {
    UserFields uf = UserFields();
    return {
      uf.id: docId,
      uf.email: email,
      uf.firstName: firstName,
      uf.lastName: lastName,
      uf.phone: phone,
      uf.date: date,
    };
  }
}

class UserFields {
  String id = "uid";
  String email = "email";
  String firstName = "firstName";
  String lastName = "lastName";
  String phone = "phone";
  String date = "date";
}
