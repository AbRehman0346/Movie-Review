import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_review/models/credits_model.dart';
import 'package:movie_review/service/firebase_storage_service.dart';
import 'feedback.dart' as feedback;
import '../constants.dart';
import '../xutils/xtext.dart';

class Credits extends StatefulWidget {
  const Credits({Key? key}) : super(key: key);

  @override
  State<Credits> createState() => _CreditsState();
}

class _CreditsState extends State<Credits> {
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
              Row(
                children: [
                  //Getting Image Of Abdul Rehman
                  FutureBuilder(
                    future: FirebaseStorageService()
                        .getImageDownloadURL('credentials/abrehman.jpg'),
                    builder: (context, AsyncSnapshot snap) {
                      if (snap.hasData) {
                        return Image.network(snap.data,
                            width: 200, fit: BoxFit.cover);
                      } else {
                        return Image.asset(Constants.placeholderImage,
                            width: 200, fit: BoxFit.cover);
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
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
                              width: MediaQuery.of(context).size.width - 250,
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
                                  const XText('Developer',
                                      fontSize: 30, color: Colors.blueAccent),
                                  SizedBox(height: 10),
                                  XText(credit.phone, fontSize: 30),
                                  SizedBox(height: 10),
                                  XText(credit.email, fontSize: 30),
                                  SizedBox(height: 10),
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
                              children: [
                                //    name, phone, email, description
                                XText(
                                  "Abdul Rehman",
                                  fontSize: 32,
                                  color: Colors.blue,
                                ),
                                SizedBox(height: 10),
                                XText("arehmanmuneer.bscsf19@iba-suk.edu.pk",
                                    fontSize: 30),
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
              Row(
                children: [
                  //Getting Image Of Abdul Rehman
                  FutureBuilder(
                    future: FirebaseStorageService()
                        .getImageDownloadURL('credentials/shahzeb.jpeg'),
                    builder: (context, AsyncSnapshot snap) {
                      if (snap.hasData) {
                        return Image.network(
                          snap.data,
                          width: 200,
                          fit: BoxFit.cover,
                        );
                      } else {
                        return Image.asset(Constants.placeholderImage,
                            width: 200, fit: BoxFit.cover);
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
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
                              width: MediaQuery.of(context).size.width - 250,
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
                                  XText(credit.email, fontSize: 30),
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
                            content: feedback.Feedback(),
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
