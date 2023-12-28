import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:memoiree/Screen/AddDiaryPage.dart';
import 'package:memoiree/Screen/DiaryDetailPage.dart';
import 'package:memoiree/Screen/DiaryListItem.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utilities/AuthService.dart';
import '../Utilities/FirestoreSystem.dart';
import 'LoginPage.dart';

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
final User? user = FirebaseAuth.instance.currentUser;

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late SharedPreferences prefs;
  DateTime _dateDiary = DateTime.now();
  late String username;
  bool? log;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final datePicker = Container(
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
              Text(
                _dateDiary == null
                    ? 'Nothing has been picked yet'
                    : DateFormat.yMMMMd().format(_dateDiary),
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          ElevatedButton(
            child: Text("Pick Date",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
                lastDate: DateTime(2099),
              ).then((date) {
                setState(() {
                  _dateDiary = date!;
                  print(_dateDiary);
                });
              });
            },
          )
        ],
      ),
    );
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Text(
            "Diary",
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                AuthService service = AuthService(FirebaseAuth.instance);
                service.logOut();
                if (_firebaseAuth.currentUser == null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                }
              },
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueAccent,
          child: Icon(CupertinoIcons.plus),
          onPressed: () {
            print(_firebaseAuth.currentUser!.uid);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddDiaryPage(
                        docId: _firebaseAuth.currentUser!.uid,
                      )),
            );
          },
        ),
        // body: Text(username)
        body: Column(
          children: [
            datePicker,
            Divider(
              height: 2,
              color: Colors.black26,
            ),
            Expanded(
                child: StreamBuilder(
              // stream:
              // FirestoreSystem.readDiaries(docId: _firebaseAuth.currentUser!.uid),
              stream: FirestoreSystem.readDiariesByDate(
                  docId: _firebaseAuth.currentUser!.uid,
                  dateDiary: DateFormat.yMMMMd().format(_dateDiary)),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return ListView.separated(
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext, index) {
                      var data = snapshot.data!.docs[index];
                      return GestureDetector(
                        child: DiaryListItem(
                            title: data.get('title'),
                            diary: data.get('diaryitem'),
                            date: data.get('datediary'),
                            imageUrl: data.get('imageurl')),
                        onTap: () async {
                          print(data.id);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DiaryDetailPage(
                                      uid: _firebaseAuth.currentUser!.uid,
                                      diaryId: data.id,
                                      title: data.get('title'),
                                      diary: data.get('diaryitem'),
                                      date: data.get('datediary'),
                                      imageUrl: data.get('imageurl'))));
                        },
                      );
                    },
                    separatorBuilder: (BuildContext, index) {
                      return Divider(
                        height: 1,
                      );
                    },
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                  );
                }

                return Container();
              },
            )),
          ],
        ));
  }
}
