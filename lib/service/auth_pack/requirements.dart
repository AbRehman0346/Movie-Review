import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import '../../constants.dart';

/*
* Placeholder Image: String
* user: User?
* Collection: Collection ->
*                          Name of the collection where users data will be saved
*                          Usually taken from User's email ID. through a function
*                          "formatEmail" in this file.
* UserProfileDataDoc: String -> Name of Document where user's data will be saved.
* userProfilePicture: String -> Path where profile picture will be saved.
* saveProfileLocally: Uint8List? -> Saves the profile picture in local variable for use in
*                     All over the application.
* */

class Requirements {
  get placeholderImage {
    return Constants.placeholderImage;
  }

  set user(User? user) {
    Constants.user = user;
  }

  User? get user => Constants.user;

  String get userDoc => Constants.userDoc;

  String get profileCollection => Constants.profileCollection;

  String get userProfilePicturePath => Constants().userProfilePicturePath;

  set saveProfileLocally(Uint8List file) {
    Constants.userProfilePicture = file;
  }

  String deformatEmail(String email) {
    String replaceKey = "character";
    String charKey = "replacement";
    List<Map> specialCharacters = [
      {replaceKey: "@", charKey: "ATTHERATE"},
      {replaceKey: "-", charKey: "HYPHEN"},
      {replaceKey: ".", charKey: "PERIOD"},
      {replaceKey: "+", charKey: "PLUS"},
    ];
    for (Map s in specialCharacters) {
      email = email.replaceAll(s[charKey], s[replaceKey]);
    }
    return email.trim();
  }

  String formatEmail(String email) {
    String charKey = "character";
    String repKey = "replacement";
    List<Map> specialCharacters = [
      {charKey: "@", repKey: "ATTHERATE"},
      {charKey: "-", repKey: "HYPHEN"},
      {charKey: ".", repKey: "PERIOD"},
      {charKey: "+", repKey: "PLUS"},
    ];
    for (Map s in specialCharacters) {
      email = email.replaceAll(s[charKey], s[repKey]);
    }
    return email.trim();
  }
}
