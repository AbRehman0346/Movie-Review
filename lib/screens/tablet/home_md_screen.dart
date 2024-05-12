import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_review/layouts/card_layout.dart';
import 'package:movie_review/service/auth_pack/firebase_auth_services.dart';
import 'package:movie_review/xutils/xcustom_text_button.dart';
import '../../constants.dart';
import '../../service/firestore_service.dart';
import '../../xutils/dimension.dart';
import '../../xutils/xtext.dart';
import '../feedback.dart' as feedback;

class HomeMdScreen extends StatefulWidget {
  const HomeMdScreen({Key? key}) : super(key: key);

  @override
  State<HomeMdScreen> createState() => _HomeMdScreenState();
}

class _HomeMdScreenState extends State<HomeMdScreen> {
  final TextEditingController _search = TextEditingController();
  List<DocumentSnapshot> docs =
      []; //For storing the data locally for later use.
  String searchValue =
      ""; //For storing the string that user searched records with.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(28, 40, 52, 1),
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: XCustomTextButton(
                    text: "Feedback",
                    background: Colors.transparent,
                    textColor: Colors.white,
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return const AlertDialog(
                              title:
                                  Text("Tell us your thoughts about the site."),
                              content: feedback.Feedback(),
                            );
                          });
                    },
                  ),
                ),
                !Constants.isSignedIn
                    //Sign in Button
                    ? MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: XCustomTextButton(
                          text: "Sign in",
                          background: Colors.transparent,
                          textColor: Colors.white,
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   RouteGenerator.generateRoute(
                            //     const RouteSettings(name: '/login'),
                            //   ),
                            // );
                            context.go('/login');
                          },
                        ),
                      )
                    : Row(
                        children: [
                          //Manage Button
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: XCustomTextButton(
                              text: "Manage",
                              background: Colors.transparent,
                              textColor: Colors.white,
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   RouteGenerator.generateRoute(
                                //     const RouteSettings(name: '/manage'),
                                //   ),
                                // );
                                context.go('/manage');
                              },
                            ),
                          ),
                          //Log out Button
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: XCustomTextButton(
                              text: "Logout",
                              background: Colors.transparent,
                              textColor: Colors.white,
                              onTap: () {
                                FirebaseAuthServices().signOut(context);
                              },
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //Hero Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //Hero Container
                Container(
                  width: double.infinity,
                  height: Dimension.getWidth(
                      context, Dimension.getHeightPercent(context, 100)),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/hero_background.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  //Text and TextField Column
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //Hero Text
                      XText(
                        "Movie Reviews",
                        color: Colors.white,
                        fontSize: Dimension.getHeight(context, 120),
                      ),
                      SizedBox(height: Dimension.getHeight(context, 20)),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 50,
                        //Hero TextField
                        child: TextField(
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Dimension.getWidth(context, 40),
                          ),
                          decoration: InputDecoration(
                            prefixIcon: SizedBox(
                              width: Dimension.getWidth(context, 80),
                              child: Row(
                                children: [
                                  SizedBox(
                                      width: Dimension.getWidth(context, 15)),
                                  Icon(Icons.search,
                                      size: Dimension.getWidth(context, 60)),
                                ],
                              ),
                            ),
                            hintText: "SEARCH REVIEWS",
                            hintStyle: const TextStyle(color: Colors.grey),
                            fillColor: const Color.fromRGBO(53, 64, 77, 1),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          onChanged: (e) {
                            setState(() {
                              searchValue = e;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // List View Section that displays all movie reviews in list tile
            // In case of docs is empty so it will fetch all the data from database and store it
            // in docs locally. once data is stored then docs won't be empty and data will be
            //loaded from docs variable not from database. "ListView.builder" has been duplicated
            //in and after this condition.
            docs.isEmpty
                ? FutureBuilder(
                    future: FirebaseFirestoreService().getDocs(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snap) {
                      //Gets the list of users only.
                      if (!snap.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      docs = snap.data!.docs;

                      return CardLayout(docs: docs, searchValue: searchValue);
                    })
                : CardLayout(docs: docs, searchValue: searchValue),
          ],
        ),
      ),
    );
  }
}
