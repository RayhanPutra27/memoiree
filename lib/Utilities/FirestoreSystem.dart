import 'package:cloud_firestore/cloud_firestore.dart';

import 'Response.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _Collection = _firestore.collection('users');

class FirestoreSystem {

  final FirebaseFirestore firestore;

  FirestoreSystem({required this.firestore});

  static Future<Response> addUser(
      {required String name,
        required String username,
        required String email,
        required String phoneNumber,
        required String uid}) async {
    Response response = Response();
    DocumentReference documentReference = _Collection.doc(uid);

    Map<String, dynamic> data = <String, dynamic>{
      "name": name,
      "username": username,
      "email": email,
      "phonenumber": phoneNumber
    };

    print("hai ${documentReference.id}");

    await documentReference.set(data).whenComplete(() {
      response.code = 200;
      response.message = "Sucessfully create proyek to database";
    }).catchError((e) {
      response.code = 500;
      response.message = e.toString();
    });
    return response;
  }

  static Stream<QuerySnapshot> readDiaries({required String docId}) {
    CollectionReference notesItemCollection =
    _Collection.doc(docId).collection('diary');

    return notesItemCollection.snapshots();
  }

  static Stream<QuerySnapshot> readDiariesByDate(
      {required String docId, required String dateDiary}) {
    CollectionReference notesItemCollection =
    _Collection.doc(docId).collection('diary');

    return notesItemCollection
        .where('datediary', isEqualTo: dateDiary)
        .snapshots();
  }

  static Future<Response> postDiary(
      {required String title,
        required String dateDiary,
        required String diaryItem,
        required String imageUrl,
        required String docId}) async {
    Response response = Response();
    DocumentReference documentReference =
    _Collection.doc(docId).collection('diary').doc();
    Map<String, dynamic> data = <String, dynamic>{
      "title": title,
      "diaryitem": diaryItem,
      "imageurl": imageUrl,
      "datediary": dateDiary,
    };

    var result = await documentReference.set(data).whenComplete(() {
      response.code = 200;
      response.message = "Post Success";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });
    return response;
  }

  static Future<Response> uploadImage(
      {required String title,
        required String dateDiary,
        required String diaryItem,
        required String imageUrl,
        required String docId,
        required String diaryId}) async {
    Response response = Response();
    DocumentReference documentReference = _Collection.doc(docId).collection('diary').doc(diaryId);

    Map<String, dynamic> data = <String, dynamic>{
      "title": title,
      "diaryitem": diaryItem,
      "imageurl": imageUrl,
      "datediary": dateDiary,
    };

    await documentReference.set(data).whenComplete(() {
      response.code = 200;
      response.message = "Upload Success";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });
    return response;
  }

  static Future<Response> updateDiary(
      {required String title,
        required String dateDiary,
        required String diaryItem,
        required String imageUrl,
        required String docId,
        required String diaryId}) async {
    Response response = Response();
    DocumentReference documentReferencer = _Collection.doc(docId).collection('diary').doc(diaryId);

    Map<String, dynamic> data = <String, dynamic>{
      "title": title,
      "diaryitem": diaryItem,
      "imageurl": imageUrl,
    };

    await documentReferencer.update(data).whenComplete(() {
      response.code = 200;
      response.message = "Update Success";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });

    return response;
  }

  static Future<Response> deleteDiary({
    required String docId,
    required String diaryId,
  }) async {
    Response response = Response();
    DocumentReference documentReferencer =
    _Collection.doc(docId).collection('diary').doc(diaryId);

    await documentReferencer.delete().whenComplete(() {
      response.code = 200;
      response.message = "Diary deleted";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });

    return response;
  }
}
