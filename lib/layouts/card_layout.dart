// This class is used in HomeScreen to show the posts in CARDS in Grid Layout Form.
// It's alternative is ListView that is used in HomeScreen for showing the posts...
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_review/models/comment_model.dart';
import 'package:movie_review/models/review_model.dart';
import 'package:movie_review/service/firestore_service.dart';
import 'package:movie_review/xutils/getAverageRatting.dart';

import '../constants.dart';
import '../service/auth_pack/firestore_auth_services.dart';
import '../service/auth_pack/models/user_data_model.dart';
import '../xutils/xtext.dart';

class CardLayout extends StatelessWidget {
  List<DocumentSnapshot> docs;
  String searchValue;
  CardLayout({Key? key, required this.docs, this.searchValue = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Wrap(
        alignment: WrapAlignment.center,
        children: List.generate(
          docs.length,
          (index) {
            DocumentSnapshot doc = docs[index];
            ReviewModel review = ReviewModel.fromDocument(doc);

            if (!review.title
                .toLowerCase()
                .contains(searchValue.toLowerCase())) {
              return const SizedBox();
            }

            return MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  context.go('/display', extra: doc);
                },
                child: Card(
                  margin: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: Colors.blue,
                        width: 250,
                        height: 180,
                        child: review.imgUrls.isEmpty
                            ? SizedBox()
                            : Image.network(review.imgUrls[0],
                                fit: BoxFit.cover),
                      ),

                      // Title, User Name, Ratings.
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 5),
                            XText(review.title,
                                color: Colors.blue, fontSize: 22),
                            const SizedBox(height: 5),
                            // Getting user by name by email.
                            FutureBuilder(
                                future: FirestoreAuthServices()
                                    .getUserDataByEmail(review.userEmail),
                                builder: (context, AsyncSnapshot snap) {
                                  if (snap.hasData) {
                                    UserDataModel m =
                                        UserDataModel.fromDocument(snap.data);
                                    return XText(
                                      '${m.firstName} ${m.lastName}',
                                      color:
                                          const Color.fromRGBO(25, 145, 233, 1),
                                      fontSize: 15,
                                    );
                                  } else {
                                    return const SizedBox();
                                  }
                                }),
                            const SizedBox(height: 5),
                            //Ratings And Views.
                            SizedBox(
                              width: 230,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  FutureBuilder(
                                      future: GetAverageRating()
                                          .getAverageRating(doc.id),
                                      builder: (context, AsyncSnapshot snap) {
                                        if (snap.hasData) {
                                          String ratingString =
                                              snap.data.toString();
                                          if (ratingString != 'NaN') {
                                            int rating =
                                                double.parse(ratingString)
                                                    .toInt();
                                            return SizedBox(
                                              width: 100,
                                              child: Row(
                                                children: List.generate(
                                                    Constants.rattingLimit,
                                                    (index) {
                                                  return rating >= index + 1
                                                      ? const Icon(Icons.star,
                                                          size: 20)
                                                      : const Icon(
                                                          Icons.star_border,
                                                          size: 20);
                                                }),
                                              ),
                                            );
                                          } else {
                                            return const SizedBox(height: 20);
                                          }
                                        } else {
                                          return const SizedBox(
                                              width: 0, height: 0);
                                        }
                                      }),
                                  Text('Views: ${review.views}'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
