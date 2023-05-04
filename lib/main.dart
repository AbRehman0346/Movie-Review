// Main Collection
// All the Users Main Documents.
// data -> Collection
// profileDataDocument (Profile Data)
// content -> All the Content

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_review/route_generator.dart';
import 'package:movie_review/screens/add_review.dart';
import 'package:movie_review/screens/display_screen.dart';
import 'package:movie_review/screens/home_screen.dart';
import 'package:movie_review/screens/manage_screen.dart';
import 'package:movie_review/screens/mobile/home_sm_screen.dart';
import 'package:movie_review/screens/tablet/home_md_screen.dart';
import 'package:movie_review/screens/credits.dart';
import 'package:movie_review/service/auth_pack/firebase_auth_services.dart';
import 'package:movie_review/service/auth_pack/firestore_auth_services.dart';
import 'package:movie_review/service/auth_pack/login_screen.dart';
import 'package:movie_review/xutils/dimension.dart';
import 'constants.dart';
import 'constants.dart';
import 'firebase_options.dart';

void main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Movie Review',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(
          background: Colors.white10,
        ),
      ),
      // home: Test(), //Just for development purpose.
      routerConfig: route,
    );
  }
}
