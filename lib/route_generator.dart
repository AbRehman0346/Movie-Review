import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_review/screens/add_review.dart';
import 'package:movie_review/screens/display_screen.dart';
import 'package:movie_review/screens/error_screen.dart';
import 'package:movie_review/screens/home_screen.dart';
import 'package:movie_review/screens/manage_screen.dart';
import 'package:movie_review/screens/mobile/add_review_sm.dart';
import 'package:movie_review/screens/mobile/credits_sm.dart';
import 'package:movie_review/screens/mobile/edit_screen_sm.dart';
import 'package:movie_review/screens/tablet/add_review_md.dart';
import 'package:movie_review/screens/tablet/display_md_screen.dart';
import 'package:movie_review/screens/tablet/edit_screen_md.dart';
import 'package:movie_review/screens/credits.dart';
import 'package:movie_review/service/auth_pack/login_screen.dart';
import 'package:movie_review/service/auth_pack/register_screen.dart';
import 'package:movie_review/screens/edit_screen.dart';
import 'package:movie_review/startup_widget.dart';
import 'constants.dart';
import 'layouts/card_layout.dart';
import 'screens/mobile/display_sm_screen.dart';
import 'screens/mobile/home_sm_screen.dart';
import 'screens/tablet/home_md_screen.dart';
import 'xutils/dimension.dart';

class RouteNames {
  static String credits = '/credits';
  static String startup = '/';
}

final route = GoRouter(routes: [
  //Startup Widget -> Performs authentication and goes to Homescreen.
  GoRoute(
      path: RouteNames.startup,
      builder: (context, state) => const StartupWidget()),

  //Home Screen Route
  GoRoute(
    path: '/home',
    builder: (context, state) {
      if (Dimension.isLargeScreen(context)) {
        return const HomeScreen();
      } else if (Dimension.isMediumScreen(context)) {
        return const HomeMdScreen();
      } else if (Dimension.isSmallScreen(context)) {
        return const HomeSmallScreen();
      } else {
        return const HomeScreen();
      }
    },
    redirect: (context, state) => Constants.isSignedIn ? null : '/',
  ),

  //Add Review Route
  GoRoute(
    path: '/add',
    builder: (context, state) {
      if (Dimension.isLargeScreen(context)) {
        return const AddReview();
      } else if (Dimension.isMediumScreen(context)) {
        return const AddReview_md();
      } else if (Dimension.isSmallScreen(context)) {
        return const AddReview_sm();
      } else {
        return const AddReview();
      }
    },
    redirect: (context, state) => Constants.isSignedIn ? null : '/',
  ),

  //Display Screen Route.
  GoRoute(
      path: '/display',
      builder: (context, state) {
        if (Dimension.isLargeScreen(context)) {
          return DisplayScreen(doc: state.extra as DocumentSnapshot);
        } else if (Dimension.isMediumScreen(context)) {
          return DisplayMdScreen(doc: state.extra as DocumentSnapshot);
        } else if (Dimension.isSmallScreen(context)) {
          return DisplaySmScreen(doc: state.extra as DocumentSnapshot);
        } else {
          return DisplayScreen(doc: state.extra as DocumentSnapshot);
        }
      }),

  //Edit Screen Route
  GoRoute(
    path: '/edit',
    builder: (context, state) {
      if (Dimension.isLargeScreen(context)) {
        return EditScreen(doc: state.extra as DocumentSnapshot);
      } else if (Dimension.isMediumScreen(context)) {
        return EditScreen_md(doc: state.extra as DocumentSnapshot);
      } else if (Dimension.isSmallScreen(context)) {
        return EditScreen_sm(doc: state.extra as DocumentSnapshot);
      } else {
        return EditScreen(doc: state.extra as DocumentSnapshot);
      }
    },
    redirect: (context, state) => Constants.isSignedIn ? null : '/',
  ),

  //Login Route
  GoRoute(
    path: '/login',
    builder: (context, state) => const LoginScreen(),
    redirect: (context, state) => !Constants.isSignedIn ? null : '/',
  ),

  //Manage Screen Route
  GoRoute(
    path: '/manage',
    builder: (context, state) => const ManageScreen(),
    redirect: (context, state) => Constants.isSignedIn ? null : '/',
  ),

  //Register Screen Route
  GoRoute(
    path: '/register',
    builder: (context, state) => const RegisterScreen(),
    redirect: (context, state) => !Constants.isSignedIn ? null : '/',
  ),

  //Test Screen Route
  GoRoute(
      path: RouteNames.credits,
      builder: (context, state) {
        if (Dimension.isLargeScreen(context)) {
          return const Credits();
        } else if (Dimension.isMediumScreen(context)) {
          return const Credits();
        } else if (Dimension.isSmallScreen(context)) {
          return const Credits_sm();
        } else {
          return const Credits();
        }
      }),
]);

// class RouteGenerator {
//   static Route generateRoute(RouteSettings settings) {
//     final args = settings.arguments;
//
//     switch (settings.name) {
//       case '/':
//         return MaterialPageRoute(builder: (BuildContext context) {
//           if (Dimension.isLargeScreen(context)) {
//             return const HomeScreen();
//           } else if (Dimension.isMediumScreen(context)) {
//             return const HomeMdScreen();
//           } else if (Dimension.isSmallScreen(context)) {
//             return const HomeSmallScreen();
//           } else {
//             return const HomeScreen();
//           }
//         });
//
//       case '/add':
//         return MaterialPageRoute(builder: (context) {
//           if (Dimension.isLargeScreen(context)) {
//             return const AddReview();
//           } else if (Dimension.isMediumScreen(context)) {
//             return const AddReview_md();
//           } else if (Dimension.isSmallScreen(context)) {
//             return const AddReview_sm();
//           } else {
//             return const AddReview();
//           }
//         });
//
//       case '/display':
//         return MaterialPageRoute(builder: (context) {
//           if (Dimension.isLargeScreen(context)) {
//             return DisplayScreen(doc: args as DocumentSnapshot);
//           } else if (Dimension.isMediumScreen(context)) {
//             return DisplayMdScreen(doc: args as DocumentSnapshot);
//           } else if (Dimension.isSmallScreen(context)) {
//             return DisplaySmScreen(doc: args as DocumentSnapshot);
//           } else {
//             return DisplayScreen(doc: args as DocumentSnapshot);
//           }
//         });
//
//       case '/edit':
//         return MaterialPageRoute(builder: (context) {
//           if (Dimension.isLargeScreen(context)) {
//             return EditScreen(doc: args as DocumentSnapshot);
//           } else if (Dimension.isMediumScreen(context)) {
//             return EditScreen_md(doc: args as DocumentSnapshot);
//           } else if (Dimension.isSmallScreen(context)) {
//             return EditScreen_sm(doc: args as DocumentSnapshot);
//           } else {
//             return EditScreen(doc: args as DocumentSnapshot);
//           }
//         });
//
//       case '/login':
//         return MaterialPageRoute(builder: (context) {
//           return const LoginScreen();
//         });
//
//       case '/manage':
//         return MaterialPageRoute(builder: (context) {
//           return const ManageScreen();
//         });
//
//       case '/register':
//         return MaterialPageRoute(builder: (context) {
//           return const RegisterScreen();
//         });
//
//       case '/test':
//         return MaterialPageRoute(builder: (context) {
//           return Test();
//         });
//
//       default:
//         return MaterialPageRoute(builder: (context) {
//           return const ErrorScreen();
//         });
//     }
//   }
// }
