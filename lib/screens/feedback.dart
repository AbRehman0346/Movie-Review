import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/comment_model.dart';
import '../service/auth_pack/xutils/xprogressbarbutton.dart';
import '../service/firebase_storage_service.dart';
import '../service/firestore_service.dart';
import '../xutils/alerts.dart';
import '../xutils/dimension.dart';
import '../xutils/xtextfield.dart';

class Feedback extends StatefulWidget {
  const Feedback({Key? key}) : super(key: key);

  @override
  State<Feedback> createState() => _FeedbackState();
}

class _FeedbackState extends State<Feedback> {
  int ratting = 0;
  final TextEditingController _comment = TextEditingController();
  bool _commentSubmitButtonLoadingStatus = false;

  @override
  Widget build(BuildContext context) {
    String profileImgUrl = '';

    return SizedBox(
      height: 220,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Profile image
          Padding(
            padding: EdgeInsets.only(top: Dimension.getHeight(context, 15)),
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
                    controller: _comment,
                    minLines: 5,
                    hint: "Feedback",
                  ),
                ),

                const SizedBox(height: 10),

                // Submit Button For Comment And Ratting
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    XProgressBarButton(
                        loadingValue: _commentSubmitButtonLoadingStatus,
                        buttonText: "Submit",
                        height: 35,
                        width: 85,
                        fontSize: 18,
                        onPressed: () {
                          setState(() {
                            _commentSubmitButtonLoadingStatus = true;
                          });

                          String email = Constants.user == null
                              ? ""
                              : Constants.user!.email!;

                          CommentModel cm = CommentModel(
                            ratting: ratting,
                            commentator: email,
                            comment: _comment.text,
                            date: DateTime.now().toIso8601String(),
                            profile: profileImgUrl,
                          );

                          FirebaseFirestoreService().uploadFeedback(
                            cm.toMap(),
                          );
                          setState(() {
                            ratting = 0;
                            _comment.text = '';
                            _commentSubmitButtonLoadingStatus = false;
                          });
                          Alerts().alertPrimary(context, "Thanks For Comment");
                        }),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
