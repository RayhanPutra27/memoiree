import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../Utilities/FirestoreSystem.dart';
import 'HomePage.dart';

class AddDiaryPage extends StatefulWidget {
  final String docId;

  AddDiaryPage({Key? key, required this.docId}) : super(key: key);

  @override
  State<AddDiaryPage> createState() => _AddDiaryPageState();
}

class _AddDiaryPageState extends State<AddDiaryPage> {
  final TextEditingController _diaryItem = TextEditingController();
  final TextEditingController _title = TextEditingController();
  DateTime _dateDiary = DateTime.now();
  String imageUrl = "";
  File? imageFile;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final nameField = TextFormField(
      key: const Key('_name_field'),
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
      key: const Key('_diary_item_field'),
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
      key: const Key('_date_field'),
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 10),
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
            key: const Key('_date_picker'),
            child: Text("Pick Date",
                style: TextStyle(fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
                // minimumSize: const Size.fromHeight(50),
                primary: Colors.white,
                onPrimary: Colors.blueAccent,
                elevation: 0,
                minimumSize: Size(100, 50)),
            onPressed: () {
              showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              ).then((date) {
                setState(() {
                  _dateDiary = date!;
                });
              });
            },
          )
        ],
      ),
    );

    final postDiaryButton = Container(
      key: const Key('_post_diary_button'),
      margin: EdgeInsets.only(top: 20),
      child: TextButton(
        onPressed: () async {
          var response = await FirestoreSystem.postDiary(
              title: _title.text,
              dateDiary: DateFormat.yMMMMd().format(_dateDiary),
              diaryItem: _diaryItem.text,
              imageUrl: "imageUrl",
              docId: widget.docId);

          if (_title.text == "" || _dateDiary == "" || _diaryItem.text == "") {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Item cannot be empty!"),
            ));
          } else {
            if (response == 200) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(response.message.toString()),
              ));
              Navigator.pop(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
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
        child: Text("Post Diary"),
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
                  const SizedBox(
                    height: 5,
                  ),
                  datePicker,
                  const SizedBox(
                    height: 10,
                  ),
                  postDiaryButton
                ],
              ))),
    );
  }
}
