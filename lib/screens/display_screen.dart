import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_review/models/comment_model.dart';
import 'package:movie_review/service/auth_pack/xutils/xprogressbarbutton.dart';
import 'package:movie_review/service/firestore_service.dart';
import 'package:movie_review/xutils/alerts.dart';
import 'package:movie_review/xutils/xyoutube_videos.dart';
import '../constants.dart';
import '../models/review_model.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import '../service/auth_pack/firestore_auth_services.dart';
import '../service/auth_pack/models/user_data_model.dart';
import '../service/firebase_storage_service.dart';
import '../xutils/dimension.dart';
import '../xutils/xtext.dart';
import '../xutils/xtextfield.dart';

class DisplayScreen extends StatefulWidget {
  final DocumentSnapshot doc;
  DisplayScreen({Key? key, required this.doc}) : super(key: key);

  @override
  State<DisplayScreen> createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {
  final TextEditingController _commentController = TextEditingController();
  int ratting = 0;
  bool _commentSubmitButtonLoadingStatus = false;

  @override
  Widget build(BuildContext context) {
    quill.QuillController _quillController = quill.QuillController.basic();

    ReviewModelFields fields = ReviewModelFields();
    //Variables
    DocumentSnapshot docsnap = widget.doc;
    String profileImgUrl = '';
    DateTime date = DateTime.parse(docsnap.get(fields.date));
    List videoLinks = docsnap.get(fields.videoLinks);
    List imgUrls = docsnap.get(fields.imgUrls);
    String review = docsnap.get(fields.review);
    String title = docsnap.get(fields.title);
    _quillController = quill.QuillController(
      document: quill.Document.fromJson(jsonDecode(review)),
      selection: const TextSelection.collapsed(offset: 0),
    );

    // Incrementing a View.
    FirebaseFirestoreService().addView(widget.doc.id);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(28, 40, 52, 1),
        title: const Text("Movie Review"),
        actions: [
          !Constants.isSignedIn
              ? Row(
                  children: [
                    // Log in Button
                    ElevatedButton(
                        onPressed: () {
                          // Navigator.push(
                          //   context,
                          //   RouteGenerator.generateRoute(
                          //       const RouteSettings(name: '/login')),
                          // );
                          context.go('/login');
                        },
                        child: const Text("Sign in")),
                  ],
                )
              : const SizedBox(),
        ],
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // const SizedBox(
                //   height: 12,
                // ),
                Text(
                  title,
                  style: const TextStyle(fontSize: 50),
                ),
                const SizedBox(
                  height: 10,
                ),
                imgUrls.isEmpty
                    ? const SizedBox()
                    : Image.network(
                        imgUrls[0],
                        width: 600,
                      ),
                SizedBox(height: Dimension.getHeight(context, 10)),
                Wrap(
                  children: XYoutubeVideos().videos(videoLinks),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 500,
                  padding: const EdgeInsets.all(10),
                  color: Colors.white,
                  child: quill.QuillEditor.basic(
                    configurations: quill.QuillEditorConfigurations(controller: _quillController, checkBoxReadOnly: true),
                  ),
                ),
                const SizedBox(height: 10),

                //Rating And Comment Section
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Profile image
                    Padding(
                      padding: EdgeInsets.only(
                          top: Dimension.getHeight(context, 45)),
                      child: CircleAvatar(
                        radius: 30,
                        child: Stack(
                          children: [
                            ClipOval(
                              child: FutureBuilder(
                                  future: FirebaseStorageService()
                                      .getProfileImageDownloadURL(),
                                  builder: (context, AsyncSnapshot snap) {
                                    if (snap.hasData) {
                                      profileImgUrl = snap.data;
                                      return Image.network(
                                        profileImgUrl,
                                        fit: BoxFit.cover,
                                        height: double.infinity,
                                        width: double.infinity,
                                      );
                                    } else {
                                      return Image.asset(
                                        Constants.placeholderImage,
                                        fit: BoxFit.cover,
                                        height: double.infinity,
                                        width: double.infinity,
                                      );
                                    }
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),

                    //Rating and Comments
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Ratting Starts
                          Row(
                            children: List.generate(5, (index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    ratting = index + 1;
                                  });
                                },
                                child: ratting >= index + 1
                                    ? const Icon(Icons.star)
                                    : const Icon(Icons.star_border),
                              );
                            }),
                          ),

                          //Comment TextField
                          SizedBox(
                            width: Dimension.getWidth(context, 600),
                            child: XTextField(
                              controller: _commentController,
                              minLines: 5,
                              hint: "Comments",
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Submit Button For Comment And Ratting
                          XProgressBarButton(
                              loadingValue: _commentSubmitButtonLoadingStatus,
                              buttonText: "Submit",
                              height: 35,
                              width: 85,
                              fontSize: 18,
                              onPressed: !Constants.isSignedIn
                                  ? null
                                  : () {
                                      setState(() {
                                        _commentSubmitButtonLoadingStatus =
                                            true;
                                      });
                                      CommentModel cm = CommentModel(
                                        ratting: ratting,
                                        commentator: Constants.user!.email!,
                                        comment: _commentController.text,
                                        date: DateTime.now().toIso8601String(),
                                        profile: profileImgUrl,
                                      );

                                      FirebaseFirestoreService()
                                          .uploadRattingAndComment(
                                        widget.doc.id,
                                        cm.toMap(),
                                      );
                                      setState(() {
                                        ratting = 0;
                                        _commentController.text = '';
                                        _commentSubmitButtonLoadingStatus =
                                            false;
                                      });
                                      Alerts().alertPrimary(
                                          context, "Thanks For Comment");
                                    }),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 50),
                //Rating and Comments of Others.
                StreamBuilder(
                    stream: FirebaseFirestoreService()
                        .getRattingAndCommentsStream(widget.doc.id),
                    builder: (context, AsyncSnapshot snap) {
                      if (snap.hasData) {
                        List<DocumentSnapshot> docs = snap.data.docs;
                        return Column(
                          children: List.generate(docs.length, (index) {
                            CommentModel cm =
                                CommentModel.fromDocument(docs[index]);
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //Profile image
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: Dimension.getHeight(context, 9),
                                      bottom: Dimension.getHeight(context, 20)),
                                  child: CircleAvatar(
                                    radius: 30,
                                    child: Stack(
                                      children: [
                                        ClipOval(
                                          child: cm.profile == null
                                              ? Image.asset(
                                                  Constants.placeholderImage)
                                              : Image.network(
                                                  cm.profile ?? "",
                                                  fit: BoxFit.cover,
                                                  height: double.infinity,
                                                  width: double.infinity,
                                                ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                //Rating and Comments
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //Ratting Starts
                                      Row(
                                        children: [
                                          //Searching For User's Name For display beside
                                          //Users comment.
                                          FutureBuilder(
                                              future: FirestoreAuthServices()
                                                  .getUserDataByEmail(
                                                      cm.commentator),
                                              builder: (context,
                                                  AsyncSnapshot snap) {
                                                if (snap.hasData) {
                                                  UserFields f = UserFields();
                                                  return Text(
                                                      '${snap.data[f.firstName]}',
                                                      style: const TextStyle(
                                                          fontSize: 25));
                                                } else {
                                                  return const SizedBox();
                                                }
                                              }),
                                          Row(
                                            children: List.generate(
                                                Constants.rattingLimit,
                                                (index) {
                                              return cm.ratting >= index + 1
                                                  ? const Icon(Icons.star)
                                                  : const Icon(
                                                      Icons.star_border);
                                            }),
                                          ),
                                        ],
                                      ),

                                      //Comment TextField
                                      SizedBox(
                                        width: MediaQuery.of(context)
                                                .size
                                                .width -
                                            Dimension.getWidth(context, 200),
                                        child: XText(
                                          cm.comment,
                                          fontSize: 18,
                                          maxLines: 50,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }),
                        );
                      } else {
                        return const SizedBox();
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
