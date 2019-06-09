import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mess/models/user.dart';
import 'package:mess/models/mess.dart';
import 'package:mess/services/storage.dart';
import 'package:intl/intl.dart';

class UserDetail extends StatefulWidget {
  UserDetail({this.user, this.storage});

  final User user;
  final BaseStorage storage;

  @override
  State<StatefulWidget> createState() => new _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  List<Mess> _messes;
  StreamSubscription<QuerySnapshot> _messesSub;

  @override
  void initState() {
    super.initState();

    _messes = new List<Mess>();
    String userId = widget.user.userId;

    _messesSub?.cancel();
    widget.storage
        .getAllMessByUserId(userId: userId)
        .listen((QuerySnapshot snapshot) {
      final List<Mess> messes = snapshot.documents.reversed
          .map((documentSnapshot) => Mess.fromMap(documentSnapshot.data))
          .toList();

      setState(() {
        this._messes = messes.toList();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();

    _messesSub?.cancel();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Detail"),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Container(
          child: ListView.builder(
            itemCount: _messes.length,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return listHeader();
              }

              return ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat("kk:mm - dd/MM/yyyy")
                          .format(_messes[index].date),
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget listHeader() {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: new BoxDecoration(
        border: new Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CircleAvatar(
            radius: 50.0,
            backgroundImage: NetworkImage(widget.user.photoUrl),
            backgroundColor: Colors.transparent,
          ),
          Container(
            padding: EdgeInsets.only(top: 15),
            child: Text(
              '${widget.user.displayName}',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
