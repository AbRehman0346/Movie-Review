import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_review/service/auth_pack/firestore_auth_services.dart';
import 'package:movie_review/service/auth_pack/models/user_data_model.dart';
import 'package:movie_review/service/firebase_storage_service.dart';
import 'package:movie_review/service/firestore_service.dart';
import '../constants.dart';
import '../models/review_model.dart';
import '../xutils/xcustom_text_button.dart';
import '../xutils/xtext.dart';

class ManageScreen extends StatefulWidget {
  const ManageScreen({Key? key}) : super(key: key);

  @override
  State<ManageScreen> createState() => _ManageScreenState();
}

class _ManageScreenState extends State<ManageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(28, 40, 52, 1),
        title: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                context.go('/home');
              },
              child: const Text("Movies"),
            )),
        actions: [
          !Constants.isSignedIn
              ? const SizedBox()
              :
              //Add Review Button
              Row(
                  children: [
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: XCustomTextButton(
                        text: "Add Review",
                        fontSize: 18,
                        background: Colors.transparent,
                        textColor: Colors.white,
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   RouteGenerator.generateRoute(
                          //     const RouteSettings(name: '/add'),
                          //   ),
                          // );
                          context.go('/add');
                        },
                      ),
                    ),
                  ],
                ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                //Profile Picture
                SizedBox(
                  child: FutureBuilder(
                      future:
                          FirebaseStorageService().getProfileImageDownloadURL(),
                      builder: (context, AsyncSnapshot snap) {
                        if (snap.hasData) {
                          return CircleAvatar(
                            radius: 100,
                            child: Stack(
                              children: [
                                ClipOval(
                                  child: Image.network(snap.data,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity),
                                )
                              ],
                            ),
                          );
                        } else {
                          return CircleAvatar(
                            radius: 100,
                            child: Stack(
                              children: [
                                ClipOval(
                                  child: Image(
                                    image:
                                        AssetImage(Constants.placeholderImage),
                                    fit: BoxFit.cover,
                                    height: double.infinity,
                                    width: double.infinity,
                                  ),
                                )
                              ],
                            ),
                          );
                        }
                      }),
                ),
                //Other Profile Data
                SizedBox(
                  child: FutureBuilder(
                      future: FirestoreAuthServices().getUserData(),
                      builder: (context, AsyncSnapshot snap) {
                        if (!snap.hasData) {
                          return const CircularProgressIndicator();
                        }
                        UserDataModel data =
                            UserDataModel.fromDocument(snap.data);

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${data.firstName} ${data.lastName}",
                                style: const TextStyle(
                                    fontSize: 30, color: Colors.blue)),
                            Text("${data.phone}",
                                style: const TextStyle(
                                    fontSize: 30, color: Colors.blue)),
                            Text("${data.email}",
                                style: const TextStyle(
                                    fontSize: 30, color: Colors.blue)),
                          ],
                        );
                      }),
                ),

                const SizedBox(height: 150),
                // List View for All the user uploaded reviews/documents.
                SizedBox(
                  child: StreamBuilder(
                      stream: FirebaseFirestoreService().userDocumentsStream(),
                      builder: (context, AsyncSnapshot snap) {
                        if (!snap.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snap.data.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot doc = snap.data.docs[index];
                              ReviewModel review =
                                  ReviewModel.fromDocument(doc);
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
                                          ? Image.asset(
                                              Constants.placeholderImage,
                                            )
                                          : Image.network(
                                              review.imgUrls[0],
                                              fit: BoxFit.cover,
                                            ),
                                      trailing: SizedBox(
                                        width: 150,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            //Delete Button
                                            ElevatedButton(
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (widget) {
                                                        //Delete Conformation Dialog.
                                                        return AlertDialog(
                                                          title: const Text(
                                                              'Alert'),
                                                          content: const Text(
                                                              "Do you really want to Delete the Document"),
                                                          actions: [
                                                            //Cancel Button
                                                            ElevatedButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Text(
                                                                  'Cancel'),
                                                            ),
                                                            //Delete Button
                                                            ElevatedButton(
                                                              onPressed: () {
                                                                FirebaseStorageService()
                                                                    .deletePic(
                                                                        review
                                                                            .imgUrls);
                                                                FirebaseFirestoreService()
                                                                    .deleteDocument(
                                                                        doc.id);
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: const Text(
                                                                  'Delete'),
                                                            )
                                                          ],
                                                        );
                                                      });
                                                },
                                                child: const Text("Delete")),
                                            const SizedBox(width: 10),
                                            //Edit Button
                                            ElevatedButton(
                                              onPressed: () {
                                                // Navigator.push(
                                                //   context,
                                                //   RouteGenerator.generateRoute(
                                                //     RouteSettings(
                                                //       name: '/edit',
                                                //       arguments: doc,
                                                //     ),
                                                //   ),
                                                // );
                                                context.go('/edit', extra: doc);
                                              },
                                              child: const Text("Edit"),
                                            ),
                                          ],
                                        ),
                                      ),
                                      title: XText(
                                        review.title,
                                        color: Colors.blue,
                                        fontSize: 23,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          //Review Description
                                          XText(
                                            'Views: ${review.views.toString()}',
                                            color: Colors.black,
                                            maxLines: 1,
                                          ),
                                          const SizedBox(height: 5),
                                          XText(
                                            review.date.toString(),
                                            color: Colors.grey,
                                          ),
                                          Container(
                                            color: const Color.fromRGBO(
                                                231, 248, 255, 1),
                                            padding: const EdgeInsets.all(5),
                                            child: FutureBuilder(
                                                future: FirestoreAuthServices()
                                                    .getUserDataByEmail(
                                                        review.userEmail),
                                                builder: (context,
                                                    AsyncSnapshot snap) {
                                                  if (snap.hasData) {
                                                    UserDataModel m =
                                                        UserDataModel
                                                            .fromDocument(
                                                                snap.data);
                                                    return XText(
                                                      '${m.firstName} ${m.lastName}',
                                                      color:
                                                          const Color.fromRGBO(
                                                              25, 145, 233, 1),
                                                      fontSize: 15,
                                                    );
                                                  } else {
                                                    return const SizedBox();
                                                  }
                                                }),
                                          ),
                                        ],
                                      ),
                                      hoverColor: Colors.grey,
                                    ),
                                  ),
                                ],
                              );
                            });
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
