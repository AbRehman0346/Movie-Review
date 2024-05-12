import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_review/layouts/listview_layout.dart';
import 'package:movie_review/models/review_model.dart';
import 'package:movie_review/route_generator.dart';
import 'package:movie_review/service/auth_pack/firebase_auth_services.dart';
import 'package:movie_review/xutils/xcustom_text_button.dart';
import '../../constants.dart';
import '../../service/firestore_service.dart';
import '../../xutils/dimension.dart';
import '../../xutils/xtext.dart';
import 'feedback_sm.dart';

class HomeSmallScreen extends StatefulWidget {
  const HomeSmallScreen({Key? key}) : super(key: key);

  @override
  State<HomeSmallScreen> createState() => _HomeSmallScreenState();
}

class _HomeSmallScreenState extends State<HomeSmallScreen> {
  final TextEditingController _search = TextEditingController();
  List<DocumentSnapshot> docs =
      []; //For storing the data locally for later use.
  String searchValue =
      ""; //For storing the string that user searched records with.

  ReviewModelFields f = ReviewModelFields();
  @override
  Widget build(BuildContext context) {
    ScrollController controller = ScrollController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(28, 40, 52, 1),
      ),
      drawer: Drawer(
        backgroundColor: const Color.fromRGBO(31, 48, 68, 1),
        child: ListView(
          children: [
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: XCustomTextButton(
                text: "Credits",
                background: Colors.transparent,
                textColor: Colors.white,
                onTap: () {
                  context.go(RouteNames.credits);
                },
              ),
            ),
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
                          title: Text("Tell us your thoughts about the site."),
                          content: Feedback_sm(),
                        );
                      });
                },
              ),
            ),
            !Constants.isSignedIn
                //Sign in Button
                ? XCustomTextButton(
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
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Manage Button
                      XCustomTextButton(
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
                      //Log out Button
                      XCustomTextButton(
                        text: "Logout",
                        background: Colors.transparent,
                        textColor: Colors.white,
                        onTap: () {
                          FirebaseAuthServices().signOut(context);
                        },
                      ),
                    ],
                  ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        controller: controller,
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
                      context, Dimension.getHeightPercent(context, 50)),
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
                        fontSize: Dimension.getHeight(context, 80),
                      ),
                      SizedBox(height: Dimension.getHeight(context, 20)),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 20,
                        //Hero TextField
                        child: TextField(
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Dimension.getWidth(context, 22),
                          ),
                          decoration: InputDecoration(
                            prefixIcon: SizedBox(
                              width: Dimension.getWidth(context, 50),
                              child: Row(
                                children: [
                                  SizedBox(
                                      width: Dimension.getWidth(context, 15)),
                                  Icon(Icons.search,
                                      size: Dimension.getWidth(context, 30)),
                                ],
                              ),
                            ),
                            hintText: "SEARCH REVIEW",
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

                      return ListViewLayout(
                        docs: docs,
                        searchValue: searchValue,
                        controller: controller,
                      );
                    })
                : ListViewLayout(
                    docs: docs,
                    searchValue: searchValue,
                    controller: controller,
                  ),
          ],
        ),
      ),
    );
  }
}
