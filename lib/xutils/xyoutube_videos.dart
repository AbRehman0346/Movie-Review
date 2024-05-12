import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class XYoutubeVideos {
  List<Widget> videos(List videoLinks, {bool idsProvided = false}) {
    // List of Video Containers
    List<Widget> widgets = List.generate(videoLinks.length, (index) {
      String? videolink = idsProvided
          ? videoLinks[index]
          : YoutubePlayerController.convertUrlToId(videoLinks[index]);
      return SizedBox(
        width: 500,
        height: 350,
        child: YoutubePlayerScaffold(
          controller: YoutubePlayerController.fromVideoId(
            videoId: videolink ?? "",
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
                // showDeleteButton
                //     ? GestureDetector(
                //   onTap: () {
                //     setState(() {
                //       _videoLinks.removeAt(index);
                //     });
                //   },
                //   child: Container(
                //     color: Colors.redAccent,
                //     child: const Icon(Icons.delete),
                //     height: 50,
                //     width: double.infinity,
                //   ),
                // )
                //     : Container(),
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
