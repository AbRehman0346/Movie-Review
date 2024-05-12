import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_review/models/credits_model.dart';
import 'package:movie_review/service/firebase_storage_service.dart';
import '../../xutils/xtext.dart';
import 'feedback_sm.dart';

class Credits_sm extends StatefulWidget {
  const Credits_sm({Key? key}) : super(key: key);

  @override
  State<Credits_sm> createState() => _Credits_smState();
}

class _Credits_smState extends State<Credits_sm> {
  int ratting = 0;
  TextEditingController _comment = TextEditingController();
  bool _commentSubmitButtonLoadingStatus = false;

  @override
  Widget build(BuildContext context) {
    String collection = 'credits';
    String ar_doc = 'abrehman';
    String shahzeb_doc = 'shahzeb';
    String profileImgUrl = '';

    return Scaffold(
      appBar: AppBar(
        title: const Text("CREDITS"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Abdul Rehman Container
              Column(
                children: [
                  //Getting Image Of Abdul Rehman
                  FutureBuilder(
                    future: FirebaseStorageService()
                        .getImageDownloadURL('credentials/abrehman.jpg'),
                    builder: (context, AsyncSnapshot snap) {
                      if (snap.hasData) {
                        return Image.network(snap.data,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover);
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2),
                    child: FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection(collection)
                            .doc(ar_doc)
                            .get(),
                        builder: (context, AsyncSnapshot snap) {
                          if (snap.hasData) {
                            CreditsModel credit =
                                CreditsModel.fromDocument(snap.data);
                            return SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //    name, phone, email, description
                                  XText(
                                    credit.name,
                                    fontSize: 32,
                                    color: Colors.blue,
                                  ),
                                  const SizedBox(height: 10),
                                  const XText(
                                    'Developer',
                                    fontSize: 30,
                                    color: Colors.blueAccent,
                                  ),
                                  const SizedBox(height: 10),
                                  XText(credit.phone, fontSize: 30),
                                  const SizedBox(height: 10),
                                  XText(
                                    credit.email,
                                    fontSize: 25,
                                    maxLines: 2,
                                  ),
                                  const SizedBox(height: 10),
                                  XText(
                                    credit.desc,
                                    fontSize: 18,
                                    maxLines: 100,
                                  )
                                ],
                              ),
                            );
                          } else {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                //    name, phone, email, description
                                XText(
                                  "Abdul Rehman",
                                  fontSize: 32,
                                  color: Colors.blue,
                                ),
                                SizedBox(height: 10),
                                XText(
                                  "Developer",
                                  fontSize: 32,
                                  color: Colors.blue,
                                ),
                                SizedBox(height: 10),
                                XText("arehmanmuneer.bscsf19@iba-suk.edu.pk",
                                    maxLines: 2, fontSize: 30),
                                SizedBox(height: 10),
                              ],
                            );
                          }
                        }),
                  ),
                ],
              ),

              SizedBox(height: 40),

              //Shahzeb Container
              Column(
                children: [
                  //Getting Image Of Abdul Rehman
                  FutureBuilder(
                    future: FirebaseStorageService()
                        .getImageDownloadURL('credentials/shahzeb.jpeg'),
                    builder: (context, AsyncSnapshot snap) {
                      if (snap.hasData) {
                        return Image.network(
                          snap.data,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2),
                    child: FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection(collection)
                            .doc(shahzeb_doc)
                            .get(),
                        builder: (context, AsyncSnapshot snap) {
                          if (snap.hasData) {
                            CreditsModel credit =
                                CreditsModel.fromDocument(snap.data);
                            return SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //    name, phone, email, description
                                  XText(
                                    credit.name,
                                    fontSize: 32,
                                    color: Colors.blue,
                                  ),
                                  const SizedBox(height: 10),
                                  const XText('Owner',
                                      fontSize: 30, color: Colors.blueAccent),
                                  const SizedBox(height: 10),
                                  XText(credit.phone, fontSize: 30),
                                  const SizedBox(height: 10),
                                  XText(credit.email, fontSize: 20),
                                  const SizedBox(height: 10),
                                  XText(credit.desc,
                                      fontSize: 18, maxLines: 100)
                                ],
                              ),
                            );
                          } else {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                //    name, phone, email, description
                                XText(
                                  "Shahzeb Brohi",
                                  fontSize: 32,
                                  color: Colors.blue,
                                ),

                                SizedBox(height: 10),
                                XText(
                                  "Owner",
                                  fontSize: 32,
                                  color: Colors.blue,
                                ),
                                SizedBox(height: 10),
                                // XText("", fontSize: 30),
                                SizedBox(height: 10),
                              ],
                            );
                          }
                        }),
                  ),
                ],
              ),

              SizedBox(height: 40),

              //Feedback
              ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return const AlertDialog(
                            title:
                                Text("Tell us your thoughts about the site."),
                            content: Feedback_sm(),
                          );
                        });
                  },
                  child: const Text('Feedback'))
            ],
          ),
        ),
      ),
    );
  }
}
