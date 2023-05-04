import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants.dart';
import '../models/review_model.dart';
import '../service/auth_pack/firestore_auth_services.dart';
import '../service/auth_pack/models/user_data_model.dart';
import '../xutils/xtext.dart';

class ListViewLayout extends StatelessWidget {
  List<DocumentSnapshot> docs;
  String searchValue;
  ScrollController? controller;
  ListViewLayout(
      {Key? key, required this.docs, this.searchValue = "", this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        controller: controller,
        shrinkWrap: true,
        itemCount: docs.length,
        itemBuilder: (context, index) {
          DocumentSnapshot doc = docs[index];
          ReviewModel review = ReviewModel.fromDocument(doc);

          if (!review.title.toLowerCase().contains(searchValue.toLowerCase())) {
            return const SizedBox();
          }

          return Column(
            children: [
              const SizedBox(height: 15),
              GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   RouteGenerator.generateRoute(
                  //     RouteSettings(
                  //         name: '/display', arguments: doc),
                  //   ),
                  // );
                  context.go('/display', extra: doc);
                },
                child: ListTile(
                  leading: review.imgUrls.isEmpty
                      ? Image.asset(Constants.placeholderImage)
                      : Image.network(review.imgUrls[0], fit: BoxFit.cover),
                  // trailing: const Text("Likes"),
                  title: XText(
                    review.title,
                    color: Colors.blue,
                    fontSize: 23,
                    fontWeight: FontWeight.w500,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Review Description
                      XText(
                        review.review.toString(),
                        color: Colors.black,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 5),
                      // Date
                      XText(
                        review.date.toString(),
                        color: Colors.grey,
                      ),
                      // Publisher's Name
                      Container(
                        color: const Color.fromRGBO(231, 248, 255, 1),
                        padding: const EdgeInsets.all(5),
                        child: FutureBuilder(
                            future: FirestoreAuthServices()
                                .getUserDataByEmail(review.userEmail),
                            builder: (context, AsyncSnapshot snap) {
                              if (snap.hasData) {
                                UserDataModel m =
                                    UserDataModel.fromDocument(snap.data);
                                return XText(
                                  '${m.firstName} ${m.lastName}',
                                  color: const Color.fromRGBO(25, 145, 233, 1),
                                  fontSize: 15,
                                );
                              } else {
                                return const SizedBox();
                              }
                            }),
                      ),
                    ],
                  ),
                  trailing: Text('Views: ${review.views.toString()}'),
                  hoverColor: Colors.grey,
                ),
              ),
            ],
          );
        });
  }
}
