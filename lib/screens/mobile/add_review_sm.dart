import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:movie_review/models/review_model.dart';
import 'package:movie_review/service/auth_pack/xutils/xprogressbarbutton.dart';
import 'package:movie_review/service/firebase_storage_service.dart';
import 'package:movie_review/xutils/alerts.dart';
import 'package:movie_review/xutils/xtextfield.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../../xutils/dimension.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import '../../constants.dart';
import '../../service/firestore_service.dart';
import '../../xutils/xtext.dart';

class AddReview_sm extends StatefulWidget {
  const AddReview_sm({Key? key}) : super(key: key);

  @override
  State<AddReview_sm> createState() => _AddReview_smState();
}

class _AddReview_smState extends State<AddReview_sm> {
  final List<Uint8List> _imgBytes = [];
  final quill.QuillController _quillController = quill.QuillController.basic();
  final TextEditingController _titleController = TextEditingController();
  final List<String> _videoLinks = [];
  bool _submitLoading = false;

  // List<String> _dropdownValues = ['Movie', 'Serial'];
  // String _value = 'Movie';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(28, 40, 52, 1),
        title: const Text("Add Review"),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Center(
            child: Container(
              margin: EdgeInsets.only(
                left: Dimension.getWidth(context, 50),
                right: Dimension.getWidth(context, 50),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 50,
                  ),

                  //Title...TextField.
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const XText("Titles", fontSize: 22),
                      XTextField(
                        fontSize: Dimension.getWidth(context, 22),
                        height: Dimension.getHeight(context, 30),
                        width: Dimension.getWidth(context, 500),
                        controller: _titleController,
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 10,
                  ),
                  //If imgPath is equal to empty String then image hasn't been loaded. So It will load
                  // only placeholder image.
                  GestureDetector(
                    onTap: () async {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['jpg', 'jpeg', 'png'],
                      );
                      if (result != null) {
                        setState(() {
                          PlatformFile? file = result.files.first;
                          if (_imgBytes.isNotEmpty) {
                            _imgBytes.removeAt(0);
                          }
                          _imgBytes.add(file!.bytes!);
                        });
                      }
                    },
                    child: _imgBytes.isNotEmpty
                        ? Image.memory(_imgBytes[0]!)
                        : const Image(
                            height: 200,
                            width: 200,
                            image: AssetImage(Constants.placeholderImage),
                          ),
                  ),
                  const SizedBox(height: 12),

                  //Videos Section: It counts the links in videos List and generate videos.
                  SizedBox(
                    width: double.infinity,
                    child: Wrap(
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.start,
                      children: videos(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  //Add Video Button.
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Add Video Button.
                        GestureDetector(
                          onTap: () {
                            TextEditingController textController =
                                TextEditingController();
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return SizedBox(
                                    child: AlertDialog(
                                      title: const Text("Add Video"),
                                      content: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const XText("Video Link"),
                                          XTextField(
                                              controller: textController),
                                        ],
                                      ),
                                      actions: [
                                        //Alert Cancel Button
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Cancel")),
                                        //Alert Add REview Button.
                                        ElevatedButton(
                                          onPressed: () {
                                            String? videoId =
                                                YoutubePlayerController
                                                    .convertUrlToId(
                                                        textController.text);
                                            setState(() {
                                              _videoLinks.add(videoId ??
                                                  textController.text);
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Add"),
                                        )
                                      ],
                                    ),
                                  );
                                });
                          },
                          child: Container(
                            width: 200,
                            height: 50,
                            color: Colors.grey,
                            child: const Center(
                              child: Text("Add Video"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  //Quill Editor
                  quill.QuillToolbar.simple(
                    configurations: quill.QuillSimpleToolbarConfigurations(controller: _quillController)
                  ),
                  Container(
                    height: 500,
                    padding: const EdgeInsets.all(10),
                    color: Colors.white,
                    child: quill.QuillEditor.basic(
                      configurations: quill.QuillEditorConfigurations(controller: _quillController, checkBoxReadOnly: false),
                    ),
                  ),

                  //Categories are disabled. Looking forward for future.
                  // SizedBox(height: Dimension.getHeight(context, 20)),
                  // Row(
                  //   children: [
                  //     const Text("Category", style: TextStyle(fontSize: 20)),
                  //     const SizedBox(width: 30),
                  //     SizedBox(
                  //       width: 100,
                  //       child: DropdownButton(
                  //         isExpanded: true,
                  //         items: [
                  //           DropdownMenuItem(
                  //             value: _dropdownValues[0],
                  //             child: Text(_dropdownValues[0],
                  //                 style: TextStyle(fontSize: 20)),
                  //           ),
                  //           DropdownMenuItem(
                  //             value: _dropdownValues[1],
                  //             child: Text(_dropdownValues[1],
                  //                 style: TextStyle(fontSize: 20)),
                  //           ),
                  //         ],
                  //         onChanged: (e) {
                  //           setState(() {
                  //             _value = e ?? _dropdownValues[0];
                  //           });
                  //         },
                  //         value: _value,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  SizedBox(height: Dimension.getHeight(context, 20)),
                  Row(
                    children: [
                      XProgressBarButton(
                          loadingValue: _submitLoading,
                          buttonText: "Submit",
                          onPressed: () async {
                            setState(() {
                              _submitLoading = true;
                            });
                            List<String> urls = [];
                            if (_imgBytes.isNotEmpty) {
                              FirebaseStorageService storage =
                                  FirebaseStorageService();
                              urls =
                                  await storage.uploadUint8ListFile(_imgBytes);
                            }

                            //Gathering Data. Above urls also include.
                            String title = _titleController.text;
                            String review = jsonEncode(
                                _quillController.document.toDelta().toJson());
                            DateTime date = DateTime.now();
                            List<String> links = _videoLinks;

                            FirebaseFirestoreService().add(ReviewModel(
                              title: title,
                              review: review,
                              date: date,
                              videoLinks: links,
                              imgUrls: urls,
                              userEmail: Constants.user!.email!,
                              views: 0,
                            ).toMap());
                            setState(() {
                              _submitLoading = false;
                            });
                            Navigator.pop(context);
                            Alerts().alertPrimary(context, "Review Added");
                          }),
                      // ElevatedButton(
                      //     onPressed: null,
                      //     child: const Text("Submit")),
                    ],
                  ),
                  SizedBox(height: Dimension.getHeight(context, 20))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> videos() {
    // List of Video Containers
    List<Widget> widgets = List.generate(_videoLinks.length, (index) {
      return SizedBox(
        width: 500,
        height: 350,
        child: YoutubePlayerScaffold(
          controller: YoutubePlayerController.fromVideoId(
            videoId: _videoLinks[index],
            autoPlay: false,
            params: const YoutubePlayerParams(
              showFullscreenButton: true,
            ),
          ),
          aspectRatio: 16 / 9,
          builder: (context, player) {
            return Column(
              children: [
                player,
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _videoLinks.removeAt(index);
                    });
                  },
                  child: Container(
                    color: Colors.redAccent,
                    child: Icon(Icons.delete),
                    height: 50,
                    width: double.infinity,
                  ),
                )
              ],
            );
          },
        ),
      );
    });

    //Just of little space in right between widgets.
    widgets.add(const SizedBox(width: 10));
    return widgets;
  }
}
