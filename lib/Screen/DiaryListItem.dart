import 'package:flutter/material.dart';

class DiaryListItem extends StatefulWidget {
  final String title;
  final String diary;
  final String date;
  final String imageUrl;

  DiaryListItem(
      {Key? key,
        required this.title,
        required this.diary,
        required this.date,
        required this.imageUrl})
      : super(key: key);

  @override
  State<DiaryListItem> createState() => _DiaryListItemState();
}

class _DiaryListItemState extends State<DiaryListItem> {
  int _counter = 0;
  late String name;
  late String diaryitem;
  late String datediary;
  late String imageUrl;

  void counter() {
    setState(() {
      _counter++;
    });
  }

  Widget buttons = Container(
      padding: EdgeInsets.only(top: 13),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          Icon(
            Icons.thumb_up,
            size: 20,
          ),
          Icon(
            Icons.comment,
            size: 20,
          ),
          Icon(
            Icons.share,
            size: 20,
          ),
        ],
      ));

  Widget divider = const Divider(
    thickness: 1.05,
    height: 1,
    color: Colors.grey,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(color: Colors.white),
        padding: EdgeInsets.all(13),
        width: double.infinity,
        constraints: const BoxConstraints(maxHeight: double.infinity),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Image
                // Container(
                //   padding: const EdgeInsets.all(3),
                //   margin: const EdgeInsets.only(right: 10),
                //   decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(100),
                //       image: DecorationImage(
                //         image: NetworkImage("asd"),
                //         fit: BoxFit.cover,
                //       )),
                //   height: 55,
                //   width: 55,
                // ),
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
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              )),
                        ],
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(3,0,3,0),
                          child: Text(
                            widget.date,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          )),
                      SizedBox(height: 10,),
                      //Container untuk text/image post
                      Padding(
                        padding: EdgeInsets.all(3),
                        child: Text(
                          widget.diary,
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // divider
          ],
        ));
  }
}
