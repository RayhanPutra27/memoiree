import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../Utilities/FirestoreSystem.dart';

class UpdateDiaryPage extends StatefulWidget {
  final String docId;
  final String diaryId;
  final String title;
  final String diary;
  final String date;
  final String imageUrl;

  UpdateDiaryPage(
      {Key? key,
        required this.docId,
        required this.diaryId,
        required this.title,
        required this.diary,
        required this.date,
        required this.imageUrl})
      : super(key: key);

  @override
  State<UpdateDiaryPage> createState() => _UpdateDiaryPageState();
}

class _UpdateDiaryPageState extends State<UpdateDiaryPage> {
  final TextEditingController _diaryItem = TextEditingController();
  final TextEditingController _title = TextEditingController();
  DateTime _dateDiary = DateTime.now();
  String imageUrl = "";
  File? imageFile;

  @override
  void initState() {
    _title.text = widget.title;
    _diaryItem.text = widget.diary;
    _dateDiary = DateFormat.yMMMMd().parse(widget.date);
  }

  @override
  Widget build(BuildContext context) {

    final nameField = TextFormField(
      decoration: InputDecoration(
          hintText: "Diary title", filled: true, fillColor: Colors.white),
      controller: _title,
      autofocus: false,
      maxLength: 25,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'This field is required';
        }
      },
    );

    final diaryItemField = TextFormField(
      keyboardType: TextInputType.multiline,
      maxLines: null,
      decoration: InputDecoration(
          hintText: "What's going on today?",
          filled: true,
          fillColor: Colors.white),
      controller: _diaryItem,
      autofocus: false,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'This field is required';
        }
      },
    );
    final datePicker = Container(
      color: Colors.white,
      padding: EdgeInsets.only(right: 10, left: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(_dateDiary == null
                  ? 'Nothing has been picked yet'
                  : DateFormat.yMMMMd().format(_dateDiary)),
            ],
          ),
          ElevatedButton(
            child: Text("Pick Date",
                style: TextStyle(fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              // minimumSize: const Size.fromHeight(50),
                primary: Colors.white,
                onPrimary: Colors.blueAccent,
                elevation: 0,
                minimumSize: Size(100, 50)),
            onPressed: null,
          )
        ],
      ),
    );

    final updateDiaryButton = Container(
      margin: EdgeInsets.only(top: 10),
      child: TextButton(
        onPressed: () async {
          var response = await FirestoreSystem.updateDiary(
              title: _title.text,
              dateDiary: DateFormat.yMMMMd().format(_dateDiary),
              diaryItem: _diaryItem.text,
              imageUrl: "imageUrl",
              docId: widget.docId,
              diaryId: widget.diaryId);

          if (_title.text == "" || _diaryItem.text == "") {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Item cannot be empty!"),
            ));
          } else {
            if (response == 200) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(response.message.toString()),
              ));
              Navigator.popUntil(context, (route) => route.isFirst);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(response.message.toString()),
              ));
            }
          }
        },
        style: TextButton.styleFrom(
            fixedSize: Size(150, 48),
            primary: Colors.white,
            backgroundColor: Colors.blueAccent),
        child: Text("Update Diary"),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          "How's your day?",
          style: TextStyle(fontSize: 20),
        ),
        leading: BackButton(
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      resizeToAvoidBottomInset: false, // set it to false
      body: SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    nameField,
                    const SizedBox(
                      height: 5,
                    ),
                    diaryItemField,
                    datePicker,
                    const SizedBox(
                      height: 10,
                    ),
                    updateDiaryButton
                  ],
                ))),
      ),
    );
  }
}
