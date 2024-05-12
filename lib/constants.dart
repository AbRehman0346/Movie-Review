import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_review/service/auth_pack/requirements.dart';

class Constants {
  // User
  static User? user;
  static Uint8List? userProfilePicture;
  static String mainCollection = 'MovieReviewApp';
  static String commentAndRattingCollection = 'Comments';
  static String profileCollection = 'users';

  //Guest Account
  static String guestAccountUsername = 'guest@gmail.com';
  static String guestAccountPassword = '8942392';
  // static bool get isGuestAccountUsed => user?.email == guestAccountUsername;
  static bool get isSignedIn {
    return user?.email != guestAccountUsername && user?.email != null;
  }

  static String? _doc;
  static String get userDoc {
    // if (_collection == null || isGuestAccountUsed) {
    Requirements req = Requirements();
    _doc = req.formatEmail(user!.email!);
    return _doc!;
    // }
    // return _collection!;
  }

  static const String placeholderImage = 'assets/images/placeholder.jpg';
  String get userProfilePicturePath => "$userDoc/profilepic";
  static int rattingLimit = 5;
}

class Guest {
  //Guest Mode is by default turned On.
  // turnOnTheGuestMode() {
  //   Constants.collection;
  //   Constants.isGuestAccountUsed = true;
  // }

  // turnOffTheGuestMode() {
  //   Constants.collection;
  //   Constants.isGuestAccountUsed = false;
  // }
}
