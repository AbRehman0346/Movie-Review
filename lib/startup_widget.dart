import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_review/screens/home_screen.dart';
import 'package:movie_review/screens/mobile/home_sm_screen.dart';
import 'package:movie_review/screens/tablet/home_md_screen.dart';
import 'package:movie_review/service/auth_pack/firebase_auth_services.dart';
import 'package:movie_review/xutils/dimension.dart';

import 'constants.dart';

class StartupWidget extends StatelessWidget {
  const StartupWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      //username: 'guest@gmail.com'
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          Constants.user = snapshot.data;
          return decideAndCallScreen(context);
        } else {
          return FutureBuilder(
              future: FirebaseAuthServices().signInWithEmailAndPassword(
                  Constants.guestAccountUsername,
                  Constants.guestAccountPassword),
              builder: (context, AsyncSnapshot snap) {
                if (snap.hasData) {
                  Constants.user = snapshot.data;

                  //Checking for Screen and returning the appropriate screen.
                  return decideAndCallScreen(context);
                } else {
                  return const SizedBox(
                    height: double.infinity,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              });
        }
      },
    );
  }
}

Widget decideAndCallScreen(BuildContext context) {
  //Checking for Screen and returning the appropriate screen.
  if (Dimension.isLargeScreen(context)) {
    return const HomeScreen();
  } else if (Dimension.isMediumScreen(context)) {
    return const HomeMdScreen();
  } else if (Dimension.isSmallScreen(context)) {
    return const HomeSmallScreen();
  } else {
    return const HomeScreen();
  }
}
