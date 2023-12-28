import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../Utilities/FirestoreSystem.dart';

class UploadImagePage extends StatefulWidget {
  final String docId;
  final String diaryId;
  final String title;
  final String diary;
  final String date;
  final String imageUrl;

  UploadImagePage(
      {Key? key,
      required this.docId,
      required this.diaryId,
      required this.title,
      required this.diary,
      required this.date,
      required this.imageUrl})
      : super(key: key);

  @override
  State<UploadImagePage> createState() => _UploadImagePageState();
}

class _UploadImagePageState extends State<UploadImagePage> {
  String progId = "0";
  String imageUrl = "";
  String nama = "";
  int status = 0;
  File? imageFile;

  Future<File> urlToFile(String imageUrl) async {
    var rng = Random();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File file = File('$tempPath${rng.nextInt(100)}.png');
    http.Response response = await http.get(imageUrl as Uri);
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

  @override
  void initState() {
    // imageFile = urlToFile(imageUrl) as File?;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _getFromGallery() async {
      XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 300,
        maxHeight: 300,
      );
      if (pickedFile != null) {
        setState(() {
          imageFile = File(pickedFile.path);
          print("${imageFile?.path}");
        });
      }
    }

    /// Get from Camera
    _getFromCamera() async {
      XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxWidth: 300,
        maxHeight: 300,
      );
      if (pickedFile != null) {
        setState(() {
          imageFile = File(pickedFile.path);
          print("${imageFile?.path}");
        });
      }
    }

    final buttonAddImage = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                _getFromCamera();
              },
              style: TextButton.styleFrom(
                  fixedSize: const Size(150, 48),
                  primary: Colors.white,
                  elevation: 3,
                  backgroundColor: Colors.blueAccent),
              child: Text("From Camera"),
            )
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                _getFromGallery();
              },
              style: TextButton.styleFrom(
                  fixedSize: const Size(150, 48),
                  primary: Colors.white,
                  elevation: 3,
                  backgroundColor: Colors.blueAccent),
              child: Text("From Gallery"),
            ),
          ],
        )
      ],
    );

    final imageContainer = Container(
        child: imageFile == null
            ? Container(
                alignment: Alignment.center,
                child: buttonAddImage,
              )
            : Column(
                children: [
                  Container(
                    child: Image.file(
                      imageFile!,
                      fit: BoxFit.fitHeight,
                    ),
                    height: 200,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  buttonAddImage
                ],
              ));

    // final buttonAddImage =

    final tambahProyekButton = Container(
      margin: EdgeInsets.only(top: 20),
      child: TextButton(
        onPressed: () async {
          print("${imageFile?.path}");

          if (imageFile == null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Image is empty!"),
            ));
          } else {
            String uniqueName =
                DateTime.now().millisecondsSinceEpoch.toString();

            Reference referenceRoot = FirebaseStorage.instance.ref();
            Reference referenceDirImages = referenceRoot.child("images");
            Reference referenceImageToUpload =
                referenceDirImages.child(uniqueName);

            try {
              await referenceImageToUpload.putFile(File(imageFile!.path));
              imageUrl = await referenceImageToUpload.getDownloadURL();
              var response = await FirestoreSystem.uploadImage(
                  title: widget.title,
                  diaryItem: widget.diary,
                  imageUrl: imageUrl,
                  dateDiary: widget.date,
                  diaryId: widget.diaryId,
                  docId: widget.docId);

              if (response != 200) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(response.message.toString()),
                ));
                Navigator.popUntil(context, (route) => route.isFirst);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(response.message.toString()),
                ));
              }

              print("prog id : ${progId}");
            } catch (error) {
              print(error);
            }
            print(imageUrl);
          }
        },
        style: TextButton.styleFrom(
            fixedSize: const Size(150, 48),
            primary: Colors.white,
            backgroundColor: Colors.blueAccent),
        child: Text("Upload Image"),
      ),
    );

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          "Upload Image",
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
                  imageContainer,
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  // buttonAddImage,
                  const SizedBox(
                    height: 10,
                  ),
                  tambahProyekButton
                ],
              ))),
    );
  }
}
