import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mess/pages/user_detail.dart';
import 'package:mess/services/auth.dart';
import 'package:mess/services/storage.dart';
import 'package:mess/utils/colors.dart';
import 'package:mess/models/user.dart';
import 'package:mess/models/mess.dart';

class RankPage extends StatefulWidget {
  RankPage({this.auth, this.onSignedOut});

  final BaseAuth auth;
  final VoidCallback onSignedOut;

  @override
  State<StatefulWidget> createState() => new _RankPageState();
}

class _RankPageState extends State<RankPage> {
  User _user;
  BaseStorage _storage = Storage();

  @override
  void initState() {
    super.initState();

    widget.auth.currentUser().then((user) {
      setState(() {
        _user = user;
      });
    });
  }

  void _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (error) {
      print('Sign out error $error');
    }
  }

  void _onClicked() async {
    try {
      await _storage.createMess(userId: _user.userId);
    } catch (error) {
      print('Create mess error: $error');
    }
  }

  void _onUserTapped(user) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => UserDetail(
                user: user,
                storage: _storage,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rank'),
        actions: [
          // FIXME: add this again when multiple user creation is resolved
          // https://github.com/marquesm91/mess/issues/21
          FlatButton(
            child: Text(
              'Logout',
              style: TextStyle(
                fontSize: 17.0,
                color: Colors.white,
              ),
            ),
            onPressed: _signOut,
          )
        ],
      ),
      body: _user == null
          ? loadingContainer()
          : StreamBuilder<QuerySnapshot>(
              stream: _storage.getAllMess(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> messSnapshot) {
                Map<String, List<Mess>> allMess = Map<String, List<Mess>>();

                messSnapshot.data?.documents?.forEach((messRecord) {
                  Mess mess = Mess.fromMap(messRecord.data);

                  if (allMess[mess.userId] == null) {
                    allMess[mess.userId] = new List<Mess>();
                  }

                  allMess[mess.userId].add(mess);
                });

                return StreamBuilder<QuerySnapshot>(
                  stream: _storage.getAllUsers(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> usersSnapshot) {
                    if (!usersSnapshot.hasData) {
                      return loadingContainer();
                    }

                    List<User> users = List();

                    usersSnapshot.data?.documents?.forEach((userRecord) {
                      User user = User.fromMap(userRecord.data);

                      // condition for uses with 0 mess
                      if (allMess[user.userId] == null) {
                        allMess[user.userId] = new List<Mess>();
                      }

                      users.add(user);
                    });

                    users.sort((a, b) => allMess[b.userId]
                        .length
                        .compareTo(allMess[a.userId].length));

                    return ListView.builder(
                      itemCount: users?.length,
                      itemBuilder: (_, int index) {
                        User user = users[index];

                        return ListTile(
                          leading: CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(user.photoUrl),
                            backgroundColor: Colors.transparent,
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(user.displayName),
                              Text(
                                allMess[user.userId].length.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () => _onUserTapped(user),
                        );
                      },
                    );
                  },
                );
              }),
      floatingActionButton: Theme(
        data: Theme.of(context).copyWith(highlightColor: Colors.grey),
        child: FloatingActionButton(
          onPressed: _onClicked,
          backgroundColor: BaseColors.primaryBlack,
          child: Icon(Icons.timer),
        ),
      ),
    );
  }

  Widget loadingContainer() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 3,
        ),
      ),
    );
  }
}
