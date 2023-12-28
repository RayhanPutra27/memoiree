import 'package:flutter/material.dart';
import 'package:memoiree/Screen/UpdateDiaryPage.dart';

import 'UploadImagePage.dart';

class DiaryDetailPage extends StatefulWidget {
  final String uid;
  final String diaryId;
  final String title;
  final String diary;
  final String date;
  final String imageUrl;

  DiaryDetailPage(
      {Key? key,
      required this.uid,
      required this.diaryId,
      required this.title,
      required this.diary,
      required this.date,
      required this.imageUrl})
      : super(key: key);

  @override
  State<DiaryDetailPage> createState() => _DiaryDetailPageState();
}

class _DiaryDetailPageState extends State<DiaryDetailPage> {
  Widget buttons = Container(
      padding: EdgeInsets.only(top: 13, bottom: 13),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          Icon(
            Icons.thumb_up,
            size: 21,
          ),
          Icon(
            Icons.comment,
            size: 21,
          ),
          Icon(
            Icons.share,
            size: 21,
          ),
        ],
      ));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blueAccent,
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            title: Text(
              widget.title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          body: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Container(
              decoration: const BoxDecoration(color: Colors.white),
              margin: EdgeInsets.only(bottom:40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      decoration: const BoxDecoration(color: Colors.white),
                      padding: EdgeInsets.all(13),
                      width: double.infinity,
                      constraints:
                      const BoxConstraints(maxHeight: double.infinity),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //username id
                                    Row(
                                      children: [
                                        Container(
                                            padding: EdgeInsets.all(3),
                                            child: Text(
                                              widget.title,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 22),
                                            )),
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(3),
                                      child: Text(
                                        widget.date,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 21),
                            child: Text(
                              widget.diary,
                              softWrap: true,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),

                          //Image
                          Container(
                            margin: const EdgeInsets.only(right: 10, top: 20),
                            decoration: BoxDecoration(
                              // borderRadius: BorderRadius.circular(100),
                                image: DecorationImage(
                                  image: NetworkImage(
                                      widget.imageUrl),
                                  fit: BoxFit.fitHeight,
                                )),
                            height: 250,
                          ),
                        ],
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UpdateDiaryPage(
                                    docId: widget.uid,
                                    diaryId: widget.diaryId,
                                    imageUrl: widget.imageUrl,
                                    date: widget.date,
                                    title: widget.title,
                                    diary: widget.diary,
                                  )));
                        },
                        style: TextButton.styleFrom(
                            fixedSize: const Size(100, 48),
                            primary: Colors.white,
                            elevation: 3,
                            backgroundColor: Colors.blueAccent),
                        child: Text("Update", style: TextStyle(fontSize: 16)),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UploadImagePage(
                                    docId: widget.uid,
                                    diaryId: widget.diaryId,
                                    imageUrl: widget.imageUrl,
                                    date: widget.date,
                                    title: widget.title,
                                    diary: widget.diary,)));
                        },
                        style: TextButton.styleFrom(
                            fixedSize: const Size(100, 48),
                            primary: Colors.white,
                            elevation: 3,
                            backgroundColor: Colors.blueAccent),
                        child: Text("Add Image", style: TextStyle(fontSize: 16)),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
