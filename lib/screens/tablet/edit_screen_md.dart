import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:movie_review/models/review_model.dart';
import 'package:movie_review/service/auth_pack/xutils/xprogressbarbutton.dart';
import 'package:movie_review/service/firebase_storage_service.dart';
import 'package:movie_review/xutils/alerts.dart';
import 'package:movie_review/xutils/xlabled_textfield.dart';
import 'package:movie_review/xutils/xtextfield.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../../xutils/dimension.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import '../../constants.dart';
import '../../service/firestore_service.dart';
import '../../xutils/xtext.dart';

class EditScreen_md extends StatefulWidget {
  final DocumentSnapshot doc;
  const EditScreen_md({Key? key, required this.doc}) : super(key: key);

  @override
  State<EditScreen_md> createState() => _EditScreen_mdState();
}

class _EditScreen_mdState extends State<EditScreen_md> {
  final List<Uint8List?> _imgBytes = [];
  List<dynamic> _imageURL = [];

  quill.QuillController _quillController = quill.QuillController.basic();
  final TextEditingController _titleController = TextEditingController();
  List<dynamic> _videoLinks = [];
  bool _submitLoading = false;

  //Below Commented is for Dropdown menues whose code is also commented for future use.
  // List<String> _dropdownValues = ['Movie', 'Serial'];
  // String _value = 'Movie';

  @override
  void initState() {
    ReviewModelFields reviewFields = ReviewModelFields();
    _videoLinks = widget.doc.get(reviewFields.videoLinks);
    _titleController.text = widget.doc.get(reviewFields.title);
    _quillController = quill.QuillController(
      document: quill.Document.fromJson(
        jsonDecode(widget.doc.get(reviewFields.review)),
      ),
      selection: const TextSelection.collapsed(offset: 0),
    );
    try {
      _imageURL = widget.doc.get(reviewFields.imgUrls);
    } catch (e) {
      print("INFO/Error: There exists no image in database. ${e}");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(28, 40, 52, 1),
        title: const Text("Movie Review"),
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
                  //Title
                  XLabledTextField(
                    fontSize: Dimension.getWidth(context, 40),
                    label: "Title:",
                    labelFontSize: Dimension.getWidth(context, 35),
                    height: Dimension.getHeight(context, 100),
                    width: Dimension.getWidth(context, 850),
                    editorColor: Colors.white,
                    controller: _titleController,
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

                      //Below double ternary operator refers to.
                      //if image changed then show changed image, other wise if image is present in database then
                      //show database image and if not then show just the place holder.
                      child: _imgBytes
                              .isNotEmpty //If not empty then image has changed.
                          ? Image.memory(
                              _imgBytes[0]!,
                              width: MediaQuery.of(context).size.width < 800
                                  ? MediaQuery.of(context).size.width
                                  : 800,
                            )
                          : _imageURL.isNotEmpty
                              ? Image.network(
                                  _imageURL.first!,
                                  width: MediaQuery.of(context).size.width < 800
                                      ? MediaQuery.of(context).size.width
                                      : 800,
                                )
                              : Image.asset(Constants.placeholderImage)
                      // : FutureBuilder(
                      //     future: FirebaseStorageService().getUint8ListImage(
                      //         'aqsaATTHERATEgmailPERIODcom/1681407219729'),
                      //     builder: (context, AsyncSnapshot snap) {
                      //       if (snap.hasData) {
                      //         return Image.memory(snap.data);
                      //       } else {
                      //         return Image.asset(Constants.placeholderImage);
                      //       }
                      //     }),
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
                  quill.QuillToolbar.simple(configurations: quill.QuillSimpleToolbarConfigurations(controller: _quillController)),
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
                  // Submit Button
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

                              List<Uint8List> img = [];
                              for (var element in _imgBytes) {
                                if (element != null) {
                                  img.add(element);
                                }
                              }
                              if (_imageURL.isNotEmpty) {
                                storage.deletePic(_imageURL);
                              }
                              urls = await storage.uploadUint8ListFile(img);
                            } else {
                              if (_imageURL.isNotEmpty) {
                                for (String imageURL in _imageURL) {
                                  urls.add(imageURL);
                                }
                              } else {
                                urls.add("");
                              }
                            }
                            //Gathering Data. Above urls also include.
                            String title = _titleController.text;
                            String review = jsonEncode(
                                _quillController.document.toDelta().toJson());
                            DateTime date = DateTime.now();
                            List<dynamic> links = _videoLinks;
                            String docId = widget.doc.id;

                            ReviewModelFields f = ReviewModelFields();
                            int views = widget.doc.get(f.views);

                            FirebaseFirestoreService().addWithDocId(
                                ReviewModel(
                                  title: title,
                                  review: review,
                                  date: date,
                                  videoLinks: links,
                                  imgUrls: urls,
                                  userEmail: Constants.user!.email!,
                                  views: views,
                                ).toMap(),
                                docId);
                            setState(() {
                              _submitLoading = false;
                            });
                            Alerts().alertPrimary(context, "Review Updated");
                          }),
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
                    height: 50,
                    width: double.infinity,
                    child: const Icon(Icons.delete),
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
